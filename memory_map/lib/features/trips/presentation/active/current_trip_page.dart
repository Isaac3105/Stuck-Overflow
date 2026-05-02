import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/data/geography.dart';
import '../../../../core/services/media_capture_service.dart';
import '../../../media/audio_player_tile.dart';
import '../../../media/audio_recorder_button.dart';
import '../../../media/photo_thumbnail.dart';
import '../../../music/data/spotify_repository.dart';
import '../../data/trip_providers.dart';
import '../../domain/day.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';
import '../../domain/trip_itinerary_unlock.dart';
import '../widgets/activity_block_tile.dart';
import '../widgets/day_rating_sheet.dart';
import '../widgets/days_strip.dart';
import '../widgets/empty_state.dart';
import '../widgets/weather_card.dart';
import '../widgets/suggestions_sidebar.dart';
import '../widgets/itinerary_popup.dart';
import 'full_itinerary_page.dart';

class CurrentTripPage extends ConsumerWidget {
  const CurrentTripPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrip = ref.watch(currentTripProvider);

    return currentTrip.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Current trip')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Current trip')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (trip) {
        if (trip == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Current trip')),
            body: EmptyState(
              icon: Icons.flight_takeoff_outlined,
              title: 'No active trip',
              message:
                  'When a planned trip includes today, it will show up here automatically.',
              action: FilledButton.icon(
                onPressed: () => context.go('/plan'),
                icon: const Icon(Icons.map_outlined),
                label: const Text('Go to planner'),
              ),
            ),
          );
        }
        return _CurrentTripBody(trip: trip);
      },
    );
  }
}

class _CurrentTripBody extends ConsumerStatefulWidget {
  const _CurrentTripBody({required this.trip});
  final Trip trip;

  @override
  ConsumerState<_CurrentTripBody> createState() => _CurrentTripBodyState();
}

enum _CaptureAction { takePhoto, recordVideo, pickPhoto, pickVideo }

class _CurrentTripBodyState extends ConsumerState<_CurrentTripBody> {
  bool _mandatoryRatingInFlight = false;
  int? _selectedDayIndex;

  @override
  Widget build(BuildContext context) {
    ref.watch(dayCalendarTickProvider);
    final daysAsync = ref.watch(tripDaysProvider(widget.trip.id));

    ref.listen<AsyncValue<List<TripDay>>>(tripDaysProvider(widget.trip.id), (prev, next) {
      next.whenData((days) {
        final pending = pendingPastDayNeedingRating(days, DateTime.now());
        if (pending != null && !_mandatoryRatingInFlight) {
          _offerMandatoryRating(pending);
        }
      });
    });

    return daysAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Current trip')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Current trip')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (days) {
        if (days.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Current trip')),
            body: const Center(child: Text('No days generated yet.')),
          );
        }

        final now = DateTime.now();
        final unlockedDay = unlockedItineraryDay(days, now);

        final resolvedIndex = _selectedDayIndex ??
            (unlockedDay != null ? days.indexOf(unlockedDay) : days.length - 1);
        final day = days[resolvedIndex.clamp(0, days.length - 1)];

        final t0 = DateTime(now.year, now.month, now.day);
        final todayIndex = days.indexWhere((d) {
          final dk = DateTime(d.date.year, d.date.month, d.date.day);
          return dk == t0;
        });
        final currentIndex = days.indexOf(day);

        final mediaEnabled = todayIndex != -1 && currentIndex == todayIndex;
        final ratingEnabled = todayIndex != -1 &&
            (currentIndex == todayIndex ||
                (currentIndex == todayIndex - 1 && day.dayRating == null));

        final blocksAsync = ref.watch(dayBlocksProvider(day.id));
        final mediaAsync = ref.watch(dayMediaProvider(day.id));
        final dateLabel =
            DateFormat('EEEE, MMMM d', 'en').format(day.date);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Current trip'),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.auto_awesome),
                  tooltip: 'Suggestions',
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
            ],
          ),
          endDrawer: SuggestionsSidebar(
            trip: widget.trip,
            dayId: day.id,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              const SizedBox(height: 12),
              _HeaderCard(trip: widget.trip, dateLabel: dateLabel, day: day),
            const SizedBox(height: 16),
            DaysStrip(
              days: days,
              selectedIndex: resolvedIndex.clamp(0, days.length - 1),
              onSelect: (i) => setState(() => _selectedDayIndex = i),
            ),
            const SizedBox(height: 10),
            WeatherCard(countries: widget.trip.countries),
            const SizedBox(height: 12),



            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FullItineraryPage(
                        trip: widget.trip,
                        day: day,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Itinerary',
                              style: Theme.of(context).textTheme.titleMedium),
                          const Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                      const Divider(height: 16),
                      blocksAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text('Error: $e'),
                        data: (blocks) {
                          if (blocks.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('No blocks for today.'),
                            );
                          }
                          return Column(
                            children: [
                              for (final b in blocks)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: ActivityBlockTile(
                                    block: b,
                                    onTap: null, // Tap bubbles to InkWell
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        mediaEnabled ? () => _captureMedia(context, day.id) : null,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Add media'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: AudioRecorderButton(
                    tripId: widget.trip.id,
                    dayId: day.id,
                    enabled: mediaEnabled,
                    onRecorded: (mediaId) => ref
                        .read(tripRepositoryProvider)
                        .setDayAudio(day.id, mediaId),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _PlaylistCard(tripId: widget.trip.id),

            const SizedBox(height: 10),
            const SizedBox(height: 10),
            if (todayIndex != -1 && currentIndex <= todayIndex)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final stars = i + 1;
                  final currentRating = day.dayRating ?? 0;
                  final isFilled = stars <= currentRating;
                  return IconButton(
                    iconSize: 32,
                    onPressed: ratingEnabled
                        ? () async {
                            try {
                              await ref.read(tripRepositoryProvider).setDayRating(
                                    dayId: day.id,
                                    stars: stars,
                                  );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error saving rating: $e')),
                                );
                              }
                            }
                          }
                        : null,
                    icon: Icon(
                      isFilled ? Icons.star : Icons.star_border,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }),
              ),
            const SizedBox(height: 16),
            _CapturesSection(dayId: day.id, mediaAsync: mediaAsync),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => _confirmTerminateTrip(context),
              child: const Text('END TRIP'),
            ),
          ],
        ),
      );
    },
  );
}


  Future<void> _offerMandatoryRating(TripDay day) async {
    if (!mounted || _mandatoryRatingInFlight) return;
    _mandatoryRatingInFlight = true;
    try {
      final stars = await showDayRatingSheet(
        context,
        day: day,
        title: 'How was this day?',
        subtitle: 'Before moving on, rate this day from 1 to 5 stars.',
        barrierDismissible: false,
      );
      if (!mounted) return;
      if (stars != null) {
        await ref.read(tripRepositoryProvider).setDayRating(
              dayId: day.id,
              stars: stars,
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving rating: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _mandatoryRatingInFlight = false);
      }
    }
  }

  Future<void> _captureMedia(BuildContext context, String dayId) async {
    final messenger = ScaffoldMessenger.of(context);
    final action = await showModalBottomSheet<_CaptureAction>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Add to this day'),
              subtitle: Text('Choose what you want to capture or pick.'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.of(ctx).pop(_CaptureAction.takePhoto),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Record video'),
              onTap: () => Navigator.of(ctx).pop(_CaptureAction.recordVideo),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pick photo from gallery'),
              onTap: () => Navigator.of(ctx).pop(_CaptureAction.pickPhoto),
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Pick video from gallery'),
              onTap: () => Navigator.of(ctx).pop(_CaptureAction.pickVideo),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == null) return;

    final svc = ref.read(mediaCaptureServiceProvider);
    final media = switch (action) {
      _CaptureAction.takePhoto => await svc.capturePhoto(
          tripId: widget.trip.id,
          dayId: dayId,
        ),
      _CaptureAction.recordVideo => await svc.captureVideo(
          tripId: widget.trip.id,
          dayId: dayId,
        ),
      _CaptureAction.pickPhoto => await svc.pickPhotoFromGallery(
          tripId: widget.trip.id,
          dayId: dayId,
        ),
      _CaptureAction.pickVideo => await svc.pickVideoFromGallery(
          tripId: widget.trip.id,
          dayId: dayId,
        ),
    };
    if (media == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Capture canceled or permission denied.')),
      );
    }
  }

  Future<void> _pickFromGallery(BuildContext context, String dayId) async {
    final messenger = ScaffoldMessenger.of(context);
    final media = await ref.read(mediaCaptureServiceProvider).pickPhotoFromGallery(
          tripId: widget.trip.id,
          dayId: dayId,
        );
    if (media == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Picking canceled or permission denied.')),
      );
    }
  }

  Future<void> _confirmTerminateTrip(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End trip'),
        content: const Text(
          'This marks the trip as completed. You can still browse memories in the archive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref
        .read(tripRepositoryProvider)
        .setStatus(widget.trip.id, TripStatus.completed);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip completed.')),
      );
    }
  }
}


class _HeaderCard extends ConsumerWidget {
  const _HeaderCard({
    required this.trip,
    required this.dateLabel,
    required this.day,
  });

  final Trip trip;
  final String dateLabel;
  final TripDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(dayMediaProvider(day.id));
    final cover = mediaAsync.maybeWhen(
      data: (media) {
        if (day.coverMediaId != null) {
          final found = media
              .where((m) => m.id == day.coverMediaId)
              .firstOrNull;
          if (found != null) return found;
        }
        return media
            .where((m) => m.type == MediaType.photo || m.type == MediaType.video)
            .cast<MediaItem?>()
            .firstWhere(
              (_) => true,
              orElse: () => null,
            );
      },
      orElse: () => null,
    );

    final locationParts = <String>[];
    if (trip.countries.length > 2) {
      final names = trip.countries
          .take(2)
          .map((c) => resolveGeography(c)?.name ?? c)
          .join(', ');
      locationParts.add('$names (+${trip.countries.length - 2})');
    } else if (trip.countries.isNotEmpty) {
      locationParts.addAll(
        trip.countries.map((c) => resolveGeography(c)?.name ?? c),
      );
    }
    final locationLine = locationParts.isEmpty ? null : locationParts.join(', ');

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (cover != null)
              MediaThumbnail(
                type: cover.type,
                filePath: cover.filePath,
                borderRadius: 0,
              )
            else
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                  ),
                  const Spacer(),
                  if (locationLine != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: InkWell(
                        onTap: () => showItineraryPopup(context, trip),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  locationLine,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CapturesSection extends ConsumerWidget {
  const _CapturesSection({required this.dayId, required this.mediaAsync});

  final String dayId;
  final AsyncValue<List<MediaItem>> mediaAsync;

  Future<void> _confirmDeleteAudio(BuildContext context, WidgetRef ref, String mediaId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete audio?'),
        content: const Text('This recording will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await ref.read(tripRepositoryProvider).deleteMedia(mediaId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Today's captures", style: Theme.of(context).textTheme.titleMedium),
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
            final photos = media
                .where((m) => m.type == MediaType.photo || m.type == MediaType.video)
                .toList();
            final audios = media.where((m) => m.type == MediaType.audio).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (photos.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (_, i) => MediaThumbnail(
                      type: photos[i].type,
                      filePath: photos[i].filePath,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MediaViewerPage(
                            type: photos[i].type,
                            filePath: photos[i].filePath,
                            dayId: dayId,
                            mediaId: photos[i].id,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (audios.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...audios.map(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: AudioPlayerTile(
                        filePath: a.filePath,
                        label: 'recorded at ${DateFormat('HH:mm').format(a.takenAt)}',
                        onDelete: () => _confirmDeleteAudio(context, ref, a.id),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

}

class _PlaylistCard extends ConsumerWidget {
  const _PlaylistCard({required this.tripId});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistAsync = ref.watch(_selectedPlaylistProviderForTrip(tripId));
    return playlistAsync.when(
      loading: () => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            ),
          ),
        ),
      ),
      error: (e, st) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Go to the full itinerary to select the playlist of the day')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_note_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 6),
                Text(
                  'Playlist',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      data: (p) => p == null
          ? Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Go to the full itinerary to select the playlist of the day')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.music_note_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Playlist',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: p.deepLink == null
                    ? null
                    : () => launchUrl(
                          Uri.parse(p.deepLink!),
                          mode: LaunchMode.externalApplication,
                        ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.music_note_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

final _selectedPlaylistProviderForTrip =
    StreamProvider.autoDispose.family((ref, String tripId) {
  return ref.watch(spotifyRepositoryProvider).watchSelectedPlaylistForTrip(tripId);
});

