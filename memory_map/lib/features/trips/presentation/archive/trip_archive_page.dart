import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../media/audio_player_tile.dart';
import '../../../media/photo_thumbnail.dart';
import '../../../music/data/spotify_repository.dart';
import '../../../music/presentation/trip_playlist_card.dart';
import '../../data/trip_providers.dart';
import '../../domain/day.dart';
import '../../domain/media.dart';
import '../widgets/activity_block_tile.dart';

class TripArchivePage extends ConsumerWidget {
  const TripArchivePage({super.key, required this.tripId});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripProvider(tripId));
    final daysAsync = ref.watch(tripDaysProvider(tripId));
    final playlistAsync = ref.watch(_selectedPlaylistProviderForTrip(tripId));

    return Scaffold(
      body: tripAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (trip) {
          if (trip == null) return const SizedBox.shrink();
          return daysAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (days) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    title: Text(trip.name),
                    expandedHeight: 160,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _Header(countries: trip.countries),
                      title: null,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateFormat('d MMM yyyy', 'en').format(trip.startDate)} → '
                            '${DateFormat('d MMM yyyy', 'en').format(trip.endDate)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          playlistAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (e, _) => const SizedBox.shrink(),
                            data: (p) => p == null
                                ? const SizedBox.shrink()
                                : TripPlaylistCard(playlist: p),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: days.length,
                    itemBuilder: (context, i) =>
                        _DaySection(day: days[i], dayIndex: i + 1),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.countries});
  final List<String> countries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.tertiaryContainer],
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
      child: Wrap(
        spacing: 6,
        children: countries
            .take(8)
            .map(
              (c) => ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SizedBox(
                  width: 28,
                  height: 18,
                  child: Flag.fromString(c, fit: BoxFit.cover),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DaySection extends ConsumerWidget {
  const _DaySection({required this.day, required this.dayIndex});
  final TripDay day;
  final int dayIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(dayBlocksProvider(day.id));
    final mediaAsync = ref.watch(dayMediaProvider(day.id));
    final dateLabel =
        DateFormat('EEEE, MMMM d', 'en').format(day.date);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text('$dayIndex'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _DayRatingRow(rating: day.dayRating),
          const SizedBox(height: 8),
          blocksAsync.maybeWhen(
            data: (blocks) {
              if (blocks.isEmpty) return const SizedBox.shrink();
              return Column(
                children: blocks
                    .map((b) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ActivityBlockTile(block: b, dense: true),
                        ))
                    .toList(),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          mediaAsync.maybeWhen(
            data: (media) {
              final photos =
                  media.where((m) => m.type == MediaType.photo).toList();
              final audios =
                  media.where((m) => m.type == MediaType.audio).toList();
              if (photos.isEmpty && audios.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (photos.isNotEmpty)
                      SizedBox(
                        height: 96,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: photos.length,
                          separatorBuilder: (context, i) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) => SizedBox(
                            width: 96,
                            child: PhotoThumbnail(
                              filePath: photos[i].filePath,
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => PhotoViewerPage(
                                  filePath: photos[i].filePath,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    if (audios.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...audios.map((a) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: AudioPlayerTile(
                              filePath: a.filePath,
                              label:
                                  'Audio at ${DateFormat('HH:mm').format(a.takenAt)}',
                            ),
                          )),
                    ],
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }
}

class _DayRatingRow extends StatelessWidget {
  const _DayRatingRow({required this.rating});
  final int? rating;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stars = rating;
    if (stars == null) {
      return Text(
        'No rating',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
      );
    }
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = i < stars;
          return Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 18,
            color: filled ? Colors.amber : scheme.onSurfaceVariant,
          );
        }),
        const SizedBox(width: 8),
        Text(
          '$stars / 5',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

final _selectedPlaylistProviderForTrip =
    StreamProvider.autoDispose.family((ref, String tripId) {
  return ref
      .watch(spotifyRepositoryProvider)
      .watchSelectedPlaylistForTrip(tripId);
});
