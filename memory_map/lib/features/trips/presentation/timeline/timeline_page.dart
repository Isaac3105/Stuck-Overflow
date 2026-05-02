import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../media/audio_player_tile.dart';
import '../../../media/photo_thumbnail.dart';
import '../../data/trip_providers.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';
import '../widgets/empty_state.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(allMediaProvider);
    final tripsAsync = ref.watch(allTripsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Memories')),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (trips) {
          final tripById = {for (final t in trips) t.id: t};
          return mediaAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (media) {
              if (media.isEmpty) {
                return const EmptyState(
                  icon: Icons.auto_stories_outlined,
                  title: 'No memories yet',
                  message:
                      'Your photos and audios appear here in chronological order, spanning across all trips.',
                );
              }

              final photos =
                  media
                      .where((m) =>
                          m.type == MediaType.photo || m.type == MediaType.video)
                      .toList();
              final audios =
                  media.where((m) => m.type == MediaType.audio).toList();

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _SectionTitle(
                    title: '',
                    subtitle:
                        '${media.length} items · ${photos.where((m) => m.type == MediaType.photo).length} photos · ${photos.where((m) => m.type == MediaType.video).length} videos · ${audios.length} audios',
                  ),
                  const SizedBox(height: 8),
                  ...media.map((m) {
                    final trip = tripById[m.tripId];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: _MemoryCard(media: m, trip: trip),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.media, required this.trip});
  final MediaItem media;
  final Trip? trip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final when = DateFormat('d MMM yyyy • HH:mm', 'en').format(media.takenAt);

    return Card(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  media.type == MediaType.photo
                      ? Icons.photo_outlined
                      : media.type == MediaType.video
                          ? Icons.videocam_outlined
                          : Icons.mic_none,
                  color: scheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: trip == null
                        ? null
                        : () {
                            final status = trip!.resolvedStatus(DateTime.now());
                            if (status == TripStatus.completed) {
                              context.go('/archive/${trip!.id}');
                            } else if (status == TripStatus.active) {
                              context.go('/current');
                            } else {
                              context.go('/plan/${trip!.id}');
                            }
                          },
                    child: Text(
                      trip?.name ?? 'Trip',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: scheme.primary,
                            decoration: trip != null
                                ? TextDecoration.underline
                                : null,
                          ),
                    ),
                  ),
                ),
                Text(
                  when,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (media.type == MediaType.photo || media.type == MediaType.video)
              SizedBox(
                height: 200,
                width: double.infinity,
                child: MediaThumbnail(
                  type: media.type,
                  filePath: media.filePath,
                  borderRadius: 14,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MediaViewerPage(
                        type: media.type,
                        filePath: media.filePath,
                      ),
                    ),
                  ),
                ),
              )
            else
              AudioPlayerTile(
                filePath: media.filePath,
                label: 'recorded at ${DateFormat('HH:mm').format(media.takenAt)}',
              ),
          ],
        ),
      ),
    );
  }
}
