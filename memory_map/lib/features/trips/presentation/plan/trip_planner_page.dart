import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/env.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/services/spotify_service.dart';
import '../../data/trip_providers.dart';
import '../../domain/day.dart';
import '../../domain/trip.dart';
import '../../../music/data/spotify_repository.dart';
import '../widgets/activity_block_tile.dart';
import '../widgets/empty_state.dart';
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
          ? _SuggestionsSidebar(
              trip: tripAsync.valueOrNull,
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
                  _DaysStrip(
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
                (c) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: SizedBox(
                      width: 24,
                      height: 16,
                      child: Flag.fromString(c, fit: BoxFit.cover),
                    ),
                  ),
                ),
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

class _SpotifySuggestions extends ConsumerWidget {
  const _SpotifySuggestions({required this.tripId, required this.country});
  final String tripId;
  final String country;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAsync = ref.watch(_selectedPlaylistProvider(tripId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.music_note_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Local playlists',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (selectedAsync.hasValue && selectedAsync.valueOrNull != null)
                    IconButton(
                      tooltip: 'Open playlist',
                      onPressed: () {
                        final p = selectedAsync.value!;
                        if (p.deepLink == null) return;
                        launchUrl(
                          Uri.parse(p.deepLink!),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: const Icon(Icons.open_in_new),
                    ),
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => _SpotifyPlaylistPickerSheet(
                          tripId: tripId,
                          countryCode: country,
                        ),
                      );
                    },
                    child: const Text('Choose'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              selectedAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => Text('Error: $e'),
                data: (p) {
                  if (p == null) {
                    return Text(
                      'No playlist chosen for this trip.',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Playlist set for the trip',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: p.deepLink == null
                        ? null
                        : () => launchUrl(
                              Uri.parse(p.deepLink!),
                              mode: LaunchMode.externalApplication,
                            ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpotifyPlaylistPickerSheet extends ConsumerWidget {
  const _SpotifyPlaylistPickerSheet({
    required this.tripId,
    required this.countryCode,
  });

  final String tripId;
  final String countryCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(spotifyRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final async = ref.watch(
      _spotifySuggestionsProvider((tripId: tripId, countryCode: countryCode)),
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Choose playlist',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(
                    _spotifySuggestionsProvider(
                      (tripId: tripId, countryCode: countryCode),
                    ),
                  ),
                  child: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            async.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Spotify error: $e'),
              ),
              data: (options) {
                if (options.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No suggestions. Try "Refresh".',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }

                return Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final p = options[i];
                      return Card(
                        child: ListTile(
                          title: Text(
                            p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: const Icon(Icons.queue_music),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                tooltip: 'Open in Spotify',
                                onPressed: () => launchUrl(
                                  Uri.parse(p.deepLink),
                                  mode: LaunchMode.externalApplication,
                                ),
                                icon: const Icon(Icons.open_in_new),
                              ),
                              FilledButton(
                                onPressed: () async {
                                  try {
                                    await repo.selectPlaylistForTrip(
                                      tripId: tripId,
                                      countryName: countryCode,
                                      playlist: p,
                                    );
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text('Playlist chosen.'),
                                      ),
                                    );
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  } catch (e) {
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text('Spotify error: $e'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Choose'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

final _selectedPlaylistProvider =
    StreamProvider.autoDispose.family((ref, String tripId) {
  return ref
      .watch(spotifyRepositoryProvider)
      .watchSelectedPlaylistForTrip(tripId);
});

final _spotifySuggestionsProvider = FutureProvider.autoDispose.family
    <List<SpotifyPlaylist>, ({String tripId, String countryCode})>((ref, args) {
  return ref.watch(spotifyRepositoryProvider).suggestPlaylists(
        countryName: args.countryCode,
        limit: 3,
      );
});

class _GeminiSuggestions extends ConsumerWidget {
  const _GeminiSuggestions({
    required this.country,
    required this.city,
    required this.dayId,
  });

  final String country;
  final String city;
  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!Env.hasGemini) return const SizedBox.shrink();
    final async = ref.watch(_geminiPlacesProvider((country: country, city: city)));
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cultural suggestions (AI)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(_geminiPlacesProvider((country: country, city: city))),
                    child: const Text('Generate'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (items) {
                  if (items.isEmpty) {
                    return Text(
                      'No suggestions. Try "Generate" again.',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final p = items[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(p.name),
                          subtitle: Text(p.whyTypical),
                          trailing: const Icon(Icons.add),
                          onTap: () {
                            // Pre-fill a new activity block
                            showModalBottomSheet<bool>(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => ActivityBlockForm(
                                dayId: dayId,
                                prefillTitle: p.name,
                                prefillNotes: p.whyTypical,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _geminiPlacesProvider = FutureProvider.autoDispose
    .family<List<PlaceSuggestion>, ({String country, String city})>((ref, args) {
  return ref.watch(geminiServiceProvider).suggestPlaces(
        country: args.country,
        city: args.city,
      );
});

class _DaysStrip extends StatelessWidget {
  const _DaysStrip({
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
  });
  final List<TripDay> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dfDay = DateFormat('d', 'en');
    final dfMonth = DateFormat('MMM', 'en');
    final dfWeekday = DateFormat('EEE', 'en');
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        separatorBuilder: (context, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final d = days[i];
          final selected = i == selectedIndex;
          return InkWell(
            onTap: () => onSelect(i),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 64,
              decoration: BoxDecoration(
                color: selected ? scheme.primary : scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dfWeekday.format(d.date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dfDay.format(d.date),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: selected ? scheme.onPrimary : scheme.onSurface,
                    ),
                  ),
                  Text(
                    dfMonth.format(d.date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
                  if (d.dayRating != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '★ ${d.dayRating}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: selected ? scheme.onPrimary : scheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
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

class _SuggestionsSidebar extends StatelessWidget {
  const _SuggestionsSidebar({
    required this.trip,
    required this.dayId,
  });

  final dynamic trip;
  final String dayId;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.88,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome),
                  const SizedBox(width: 8),
                  Text(
                    'Sugestões',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            if (Env.hasSpotify && trip.countries.isNotEmpty)
              _SpotifySuggestions(
                tripId: trip.id,
                country: trip.countries.first,
              ),
            if (Env.hasGemini &&
                trip.countries.isNotEmpty &&
                trip.cities.isNotEmpty)
              _GeminiSuggestions(
                country: trip.countries.first,
                city: trip.cities.first,
                dayId: dayId,
              ),
          ],
        ),
      ),
    );
  }
}
