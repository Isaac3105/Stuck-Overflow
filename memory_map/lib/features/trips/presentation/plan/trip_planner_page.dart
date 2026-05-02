import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/env.dart';
import '../../../../core/data/geography.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/services/spotify_service.dart';
import '../../data/trip_providers.dart';
import '../../domain/day.dart';
import '../../domain/trip.dart';
import '../../../music/data/spotify_repository.dart';
import '../widgets/activity_block_tile.dart';
import '../widgets/days_strip.dart';
import '../widgets/empty_state.dart';
import '../widgets/suggestions_sidebar.dart';
import 'activity_block_form.dart';

class TripPlannerPage extends ConsumerStatefulWidget {
  const TripPlannerPage({
    super.key,
    required this.tripId,
    this.initialDayId,
  });

  final String tripId;
  /// When set (e.g. `?day=` from rotas), o separador abre neste dia.
  final String? initialDayId;

  @override
  ConsumerState<TripPlannerPage> createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends ConsumerState<TripPlannerPage> {
  int _selectedDayIndex = 0;
  bool _didApplyRouteDay = false;
  bool _routeDayPostFrameScheduled = false;

  Future<void> _confirmDelete() async {
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete trip'),
        content: const Text(
          'This action removes the trip, days, blocks, and associated media. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(tripRepositoryProvider).deleteTrip(widget.tripId);
    if (mounted) navigator.pop();
  }

  Future<void> _openBlockSheet(String dayId, {dynamic existing}) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ActivityBlockForm(dayId: dayId, existing: existing),
    );
  }

  @override
  void didUpdateWidget(TripPlannerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tripId != widget.tripId ||
        oldWidget.initialDayId != widget.initialDayId) {
      _didApplyRouteDay = false;
      _routeDayPostFrameScheduled = false;
    }
  }

  void _applyInitialDayFromRoute(List<TripDay> days) {
    if (_didApplyRouteDay || !mounted) return;
    final id = widget.initialDayId;
    if (id == null) {
      setState(() => _didApplyRouteDay = true);
      return;
    }
    final idx = days.indexWhere((d) => d.id == id);
    setState(() {
      _didApplyRouteDay = true;
      if (idx >= 0) _selectedDayIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripProvider(widget.tripId));
    final daysAsync = ref.watch(tripDaysProvider(widget.tripId));

    daysAsync.whenData((days) {
      if (_didApplyRouteDay || _routeDayPostFrameScheduled) return;
      _routeDayPostFrameScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _routeDayPostFrameScheduled = false;
        if (!mounted || _didApplyRouteDay) return;
        _applyInitialDayFromRoute(days);
      });
    });

    ref.listen(tripProvider(widget.tripId), (previous, next) {
      next.whenData((trip) {
        if (trip == null ||
            trip.resolvedStatus(DateTime.now()) == TripStatus.completed) {
          if (context.mounted) {
            context.go('/plan');
          }
        }
      });
    });

    return Scaffold(
      endDrawer: (tripAsync.valueOrNull != null && daysAsync.valueOrNull != null && daysAsync.valueOrNull!.isNotEmpty)
          ? SuggestionsSidebar(
              trip: tripAsync.valueOrNull!,
              dayId: daysAsync.valueOrNull![_selectedDayIndex.clamp(0, daysAsync.valueOrNull!.length - 1)].id,
            )
          : null,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: tripAsync.maybeWhen(
          data: (t) => Text(t?.name ?? ''),
          orElse: () => const Text('Trip'),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: 'Sugestões',
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'delete') _confirmDelete();
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'delete', child: Text('Delete trip')),
            ],
          ),
        ],
      ),
      body: tripAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (trip) {
          if (trip == null) return const SizedBox.shrink();
          return daysAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (days) {
              if (days.isEmpty) {
                return const EmptyState(
                  icon: Icons.event_outlined,
                  title: 'No days',
                  message: 'This trip does not have any days generated yet.',
                );
              }
              final selected =
                  days[_selectedDayIndex.clamp(0, days.length - 1)];
              return Column(
                children: [
                  _TripHeader(trip: trip),
                  DaysStrip(
                    days: days,
                    selectedIndex: _selectedDayIndex.clamp(0, days.length - 1),
                    onSelect: (i) => setState(() => _selectedDayIndex = i),
                  ),
                  Expanded(
                    child: _DayBlocksList(
                      day: selected,
                      onAdd: () => _openBlockSheet(selected.id),
                      onTapBlock: (b) =>
                          _openBlockSheet(selected.id, existing: b),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _TripHeader extends StatelessWidget {
  const _TripHeader({required this.trip});
  final dynamic trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          ...trip.countries.take(4).map<Widget>(
                (name) {
                  final code = resolveGeography(name)?.code;
                  if (code == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        width: 24,
                        height: 16,
                        child: Flag.fromString(code, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
          if (trip.cities.isNotEmpty)
            Expanded(
              child: Text(
                trip.cities.join(' · '),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayBlocksList extends ConsumerWidget {
  const _DayBlocksList({
    required this.day,
    required this.onAdd,
    required this.onTapBlock,
  });

  final TripDay day;
  final VoidCallback onAdd;
  final void Function(dynamic block) onTapBlock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(dayBlocksProvider(day.id));
    return blocksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (blocks) {
        if (blocks.isEmpty) {
          return EmptyState(
            icon: Icons.add_chart,
            title: 'No activities',
            message: 'Create the first block for this day.',
            action: FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add block'),
            ),
          );
        }
        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
              itemCount: blocks.length,
              itemBuilder: (_, i) {
                final b = blocks[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ActivityBlockTile(
                    block: b,
                    onTap: () => onTapBlock(b),
                  ),
                );
              },
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.extended(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Block'),
              ),
            ),
          ],
        );
      },
    );
  }
}

