import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/media_capture_service.dart';
import '../../../media/audio_player_tile.dart';
import '../../../media/audio_recorder_button.dart';
import '../../../media/photo_thumbnail.dart';
import '../../../music/data/spotify_repository.dart';
import '../../../music/presentation/trip_playlist_card.dart';
import '../../data/trip_providers.dart';
import '../../domain/day.dart';
import '../../domain/media.dart';
import '../widgets/activity_block_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/weather_card.dart';

class ActivePage extends ConsumerWidget {
  const ActivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrip = ref.watch(currentTripProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Current trip')),
      body: currentTrip.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (trip) {
          if (trip == null) {
            return EmptyState(
              icon: Icons.flight_takeoff_outlined,
              title: 'No active trip',
              message:
                  'When a planned trip includes today, it will show up here automatically.',
              action: FilledButton.icon(
                onPressed: () => context.go('/plan'),
                icon: const Icon(Icons.map_outlined),
                label: const Text('Go to planner'),
              ),
            );
          }
          return _ActiveTripBody(tripId: trip.id, tripName: trip.name,
              countries: trip.countries);
        },
      ),
    );
  }
}

class _ActiveTripBody extends ConsumerWidget {
  const _ActiveTripBody({
    required this.tripId,
    required this.tripName,
    required this.countries,
  });
  final String tripId;
  final String tripName;
  final List<String> countries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(tripDaysProvider(tripId));
    return daysAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (days) {
        final today = DateTime.now();
        final todayKey = DateTime(today.year, today.month, today.day);
        final day = days
            .where((d) =>
                DateTime(d.date.year, d.date.month, d.date.day) == todayKey)
            .cast<TripDay?>()
            .firstWhere((_) => true, orElse: () => null);
        if (day == null) {
          return const EmptyState(
            icon: Icons.event_busy_outlined,
            title: 'No day for today',
            message: 'The trip is active but there is no itinerary day for today.',
          );
        }
        return _TodayView(
          tripId: tripId,
          tripName: tripName,
          countries: countries,
          day: day,
        );
      },
    );
  }
}

class _TodayView extends ConsumerWidget {
  const _TodayView({
    required this.tripId,
    required this.tripName,
    required this.countries,
    required this.day,
  });
  final String tripId;
  final String tripName;
  final List<String> countries;
  final TripDay day;

  Future<void> _capturePhoto(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final media = await ref.read(mediaCaptureServiceProvider).capturePhoto(
          tripId: tripId,
          dayId: day.id,
        );
    if (media == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Capture canceled or permission denied.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(dayBlocksProvider(day.id));
    final mediaAsync = ref.watch(dayMediaProvider(day.id));
    final playlistAsync =
        ref.watch(_selectedPlaylistProviderForTrip(tripId));
    final dateLabel =
        DateFormat('EEEE, MMMM d', 'en').format(day.date);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(tripName, style: Theme.of(context).textTheme.titleLarge),
        Text(
          dateLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        playlistAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => const SizedBox.shrink(),
          data: (p) =>
              p == null ? const SizedBox.shrink() : TripPlaylistCard(playlist: p),
        ),
        if (playlistAsync.hasValue && playlistAsync.valueOrNull != null)
          const SizedBox(height: 12),
        WeatherCard(countries: countries),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AudioRecorderButton(
                tripId: tripId,
                dayId: day.id,
                onRecorded: (mediaId) =>
                    ref.read(tripRepositoryProvider).setDayAudio(day.id, mediaId),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _capturePhoto(context, ref),
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Take photo'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text("Today's itinerary",
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        blocksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (blocks) {
            if (blocks.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No blocks for today. Add them in the planner.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }
            return Column(
              children: blocks
                  .map((b) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ActivityBlockTile(block: b),
                      ))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        Text("Today's captures",
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        mediaAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (media) {
            if (media.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No photos or audio for today yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }
            final photos =
                media.where((m) => m.type == MediaType.photo).toList();
            final audios =
                media.where((m) => m.type == MediaType.audio).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (photos.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (_, i) => PhotoThumbnail(
                      filePath: photos[i].filePath,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            PhotoViewerPage(filePath: photos[i].filePath),
                      )),
                    ),
                  ),
                if (audios.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...audios.map((a) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: AudioPlayerTile(
                          filePath: a.filePath,
                          label: 'Audio at ${DateFormat('HH:mm').format(a.takenAt)}',
                        ),
                      )),
                ],
              ],
            );
          },
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
