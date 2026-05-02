import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/geography.dart';
import '../../../media/audio_player_tile.dart';
import '../../../media/photo_thumbnail.dart';
import '../../../music/data/spotify_repository.dart';
import '../../../music/presentation/trip_playlist_card.dart';
import '../../data/trip_providers.dart';
import '../../domain/day.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';
import '../widgets/activity_block_tile.dart';
import 'trip_gallery_page.dart';
import '../../../../core/services/weather_service.dart';

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
                  SliverAppBar(
                    title: Text(trip.name),
                    expandedHeight: 260,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: _TripHeaderImage(trip: trip),
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
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => TripGalleryPage(tripId: tripId),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.collections_outlined),
                              label: const Text('See gallery'),
                            ),
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

class _TripHeaderImage extends ConsumerWidget {
  const _TripHeaderImage({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverPath = ref.watch(tripCoverImagePathProvider(trip));

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
    final locationLine =
        locationParts.isEmpty ? null : locationParts.join(', ');

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background: photo or placeholder
        if (coverPath != null)
          Image.file(
            File(coverPath),
            fit: BoxFit.cover,
          )
        else
          Container(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: const Center(
              child: Icon(Icons.image_outlined, size: 64),
            ),
          ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.40),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.75),
              ],
            ),
          ),
        ),
        // Text overlay
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              if (locationLine != null)
                Text(
                  locationLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
            ],
          ),
        ),
      ],
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
          Row(
            children: [
              _DayRatingRow(rating: day.dayRating),
              const Spacer(),
              _DayWeatherRow(day: day),
            ],
          ),
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
                  media
                      .where((m) =>
                          m.type == MediaType.photo || m.type == MediaType.video)
                      .toList();
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
                            child: MediaThumbnail(
                              type: photos[i].type,
                              filePath: photos[i].filePath,
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => MediaViewerPage(
                                  type: photos[i].type,
                                  filePath: photos[i].filePath,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    if (audios.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...audios.map((a) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: AudioPlayerTile(
                            filePath: a.filePath,
                            label:
                                'recorded at ${DateFormat('HH:mm').format(a.takenAt)}',
                          ),
                        );
                      }),
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

class _DayWeatherRow extends ConsumerWidget {
  const _DayWeatherRow({required this.day});
  final TripDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripProvider(day.tripId));
    return tripAsync.maybeWhen(
      data: (trip) {
        if (trip == null) return const SizedBox.shrink();
        final coords = coordsForCountries(trip.countries);
        if (coords == null) return const SizedBox.shrink();

        final weatherAsync = ref.watch(_historicalWeatherProvider((
          lat: coords.lat,
          lng: coords.lng,
          date: day.date,
        )));

        return weatherAsync.when(
          loading: () => const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (e, _) => const SizedBox.shrink(),
          data: (w) {
            if (w == null) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(w.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '${w.temperatureC.toStringAsFixed(0)}°C',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            );
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

final _historicalWeatherProvider = FutureProvider.autoDispose
    .family<WeatherSnapshot?, ({double lat, double lng, DateTime date})>(
        (ref, args) {
  return ref.watch(weatherServiceProvider).fetchHistorical(
        latitude: args.lat,
        longitude: args.lng,
        date: args.date,
      );
});

final _selectedPlaylistProviderForTrip =
    StreamProvider.autoDispose.family((ref, String tripId) {
  return ref
      .watch(spotifyRepositoryProvider)
      .watchSelectedPlaylistForTrip(tripId);
});
