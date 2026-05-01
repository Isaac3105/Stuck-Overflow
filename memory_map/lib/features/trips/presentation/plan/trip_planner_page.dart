import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/env.dart';
import '../../../../core/services/gemini_service.dart';
import '../../data/trip_providers.dart';
import '../../domain/day.dart';
import '../../../music/data/spotify_repository.dart';
import '../../../music/presentation/preview_player.dart';
import '../widgets/activity_block_tile.dart';
import '../widgets/empty_state.dart';
import 'activity_block_form.dart';

class TripPlannerPage extends ConsumerStatefulWidget {
  const TripPlannerPage({super.key, required this.tripId});
  final String tripId;

  @override
  ConsumerState<TripPlannerPage> createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends ConsumerState<TripPlannerPage> {
  int _selectedDayIndex = 0;

  Future<void> _confirmDelete() async {
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Apagar viagem'),
        content: const Text(
          'Esta acção remove a viagem, dias, blocos e mídia associada. Tens a certeza?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Apagar'),
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
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripProvider(widget.tripId));
    final daysAsync = ref.watch(tripDaysProvider(widget.tripId));

    return Scaffold(
      appBar: AppBar(
        title: tripAsync.maybeWhen(
          data: (t) => Text(t?.name ?? ''),
          orElse: () => const Text('Viagem'),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'delete') _confirmDelete();
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'delete', child: Text('Apagar viagem')),
            ],
          ),
        ],
      ),
      body: tripAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (trip) {
          if (trip == null) return const SizedBox.shrink();
          return daysAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erro: $e')),
            data: (days) {
              if (days.isEmpty) {
                return const EmptyState(
                  icon: Icons.event_outlined,
                  title: 'Sem dias',
                  message: 'Esta viagem ainda não tem dias gerados.',
                );
              }
              final selected =
                  days[_selectedDayIndex.clamp(0, days.length - 1)];
              return Column(
                children: [
                  _TripHeader(trip: trip),
                  if (Env.hasSpotify && trip.countries.isNotEmpty)
                    _SpotifySuggestions(
                      tripId: trip.id,
                      country: trip.countries.first,
                    ),
                  if (Env.hasGemini &&
                      trip.countries.isNotEmpty &&
                      trip.cities.isNotEmpty &&
                      days.isNotEmpty)
                    _GeminiSuggestions(
                      country: trip.countries.first,
                      city: trip.cities.first,
                      dayId: days[_selectedDayIndex.clamp(0, days.length - 1)].id,
                    ),
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
    final repo = ref.watch(spotifyRepositoryProvider);
    final playlistsAsync = ref.watch(_tripPlaylistsProvider(tripId));

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
                      'Playlists locais',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => repo.searchAndStorePlaylists(
                      country: country,
                      tripId: tripId,
                    ),
                    child: const Text('Sugerir'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              playlistsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Erro: $e'),
                data: (rows) {
                  if (rows.isEmpty) {
                    return Text(
                      'Carrega em “Sugerir” para buscar playlists via Spotify.',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  final p = rows.first;
                  final tracksAsync = ref.watch(_playlistTracksProvider(p.id));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Abrir no Spotify',
                            onPressed: p.deepLink == null
                                ? null
                                : () => launchUrl(
                                      Uri.parse(p.deepLink!),
                                      mode: LaunchMode.externalApplication,
                                    ),
                            icon: const Icon(Icons.open_in_new),
                          ),
                          IconButton(
                            tooltip: 'Atualizar previews',
                            onPressed: () => repo.refreshPlaylistTracks(p.id),
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      tracksAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (e, _) => Text('Erro: $e'),
                        data: (tracks) {
                          final urls = tracks
                              .map((t) => t.previewUrl)
                              .whereType<String>()
                              .toList();
                          return PreviewPlayer(
                            title: 'Previews',
                            previewUrls: urls,
                          );
                        },
                      ),
                    ],
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

final _tripPlaylistsProvider =
    StreamProvider.autoDispose.family((ref, String tripId) {
  return ref.watch(spotifyRepositoryProvider).watchPlaylistsForTrip(tripId);
});

final _playlistTracksProvider =
    StreamProvider.autoDispose.family((ref, String playlistId) {
  return ref.watch(spotifyRepositoryProvider).watchTracks(playlistId);
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
                      'Sugestões culturais (IA)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(_geminiPlacesProvider((country: country, city: city))),
                    child: const Text('Gerar'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Erro: $e'),
                data: (items) {
                  if (items.isEmpty) {
                    return Text(
                      'Sem sugestões. Tenta “Gerar” novamente.',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return Column(
                    children: items.take(6).map((p) {
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
                              prefillNotes: '${p.category} · ${p.suggestedTimeSlot}\n${p.whyTypical}',
                            ),
                          );
                        },
                      );
                    }).toList(),
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
    final dfDay = DateFormat('d', 'pt_PT');
    final dfMonth = DateFormat('MMM', 'pt_PT');
    final dfWeekday = DateFormat('EEE', 'pt_PT');
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
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (blocks) {
        if (blocks.isEmpty) {
          return EmptyState(
            icon: Icons.add_chart,
            title: 'Sem actividades',
            message: 'Cria o primeiro bloco para este dia.',
            action: FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar bloco'),
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
                label: const Text('Bloco'),
              ),
            ),
          ],
        );
      },
    );
  }
}
