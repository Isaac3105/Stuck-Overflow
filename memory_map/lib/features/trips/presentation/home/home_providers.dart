import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/weather_service.dart'
    show coordsForCountries, coordsMidpointOfCapitals;
import '../../data/trip_providers.dart';
import '../../data/trip_repository.dart';
import '../../domain/activity_block.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';

class FeaturedTripData {
  const FeaturedTripData({
    required this.trip,
    required this.photos,
    required this.audios,
    this.mainImageIds = const {},
    this.mapLatitude,
    this.mapLongitude,
    this.mapZoom,
  });
  final Trip trip;
  final List<MediaItem> photos;
  final List<MediaItem> audios;
  final Set<String> mainImageIds;

  /// Center for the home preview map (block GPS or trip country capital).
  final double? mapLatitude;
  final double? mapLongitude;
  final double? mapZoom;

  bool get hasMap =>
      mapLatitude != null && mapLongitude != null && mapZoom != null;

  MediaItem? get coverPhoto {
    if (photos.isEmpty) return null;
    if (trip.coverMediaId != null) {
      for (final p in photos) {
        if (p.id == trip.coverMediaId) return p;
      }
    }
    if (mainImageIds.isNotEmpty) {
      for (final p in photos) {
        if (mainImageIds.contains(p.id)) return p;
      }
    }
    return photos.first;
  }

  String? get coverImagePath => coverPhoto?.filePath;

  String get subtitle {
    final start = trip.startDate;
    final months = <String>[
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
    ];
    return '${months[start.month - 1]} de ${start.year}';
  }
}

Future<({double lat, double lng, double zoom})?> _resolveMapFocus({
  required TripRepository repo,
  required Trip trip,
  required List<MediaItem> photos,
  required Set<String> mainImageIds,
}) async {
  MediaItem? cover;
  if (photos.isNotEmpty) {
    if (trip.coverMediaId != null) {
      for (final p in photos) {
        if (p.id == trip.coverMediaId) {
          cover = p;
          break;
        }
      }
    }
    cover ??= () {
      if (mainImageIds.isNotEmpty) {
        for (final p in photos) {
          if (mainImageIds.contains(p.id)) return p;
        }
      }
      return photos.first;
    }();
  }

  final blockId = cover?.activityBlockId;
  if (blockId != null) {
    final ActivityBlock? block = await repo.getActivityBlock(blockId);
    final lat = block?.latitude;
    final lng = block?.longitude;
    if (lat != null && lng != null) {
      return (lat: lat, lng: lng, zoom: 14.0);
    }
  }

  final c = trip.countries.length > 1
      ? (coordsMidpointOfCapitals(trip.countries) ??
          coordsForCountries(trip.countries))
      : coordsForCountries(trip.countries);
  if (c != null) {
    return (lat: c.lat, lng: c.lng, zoom: 6.5);
  }
  return null;
}

Future<FeaturedTripData> _buildFeaturedData({
  required TripRepository repo,
  required Trip trip,
  required List<MediaItem> photos,
  required List<MediaItem> audios,
  required Set<String> mainImageIds,
}) async {
  final focus = await _resolveMapFocus(
    repo: repo,
    trip: trip,
    photos: photos,
    mainImageIds: mainImageIds,
  );
  return FeaturedTripData(
    trip: trip,
    photos: photos,
    audios: audios,
    mainImageIds: mainImageIds,
    mapLatitude: focus?.lat,
    mapLongitude: focus?.lng,
    mapZoom: focus?.zoom,
  );
}

/// Re-rolls each time it's invalidated.
final _rollSeedProvider = StateProvider<int>(
    (ref) => DateTime.now().millisecondsSinceEpoch);

final featuredCompletedTripProvider =
    FutureProvider<FeaturedTripData?>((ref) async {
  final all = await ref.watch(allFeaturedTripsProvider.future);
  if (all.isEmpty) return null;
  final seed = ref.watch(_rollSeedProvider);
  return all[Random(seed).nextInt(all.length)];
});

final allFeaturedTripsProvider =
    FutureProvider<List<FeaturedTripData>>((ref) async {
  final tripsAsync = ref.watch(allTripsProvider);
  final trips = tripsAsync.maybeWhen(
    data: (t) => t,
    orElse: () => const <Trip>[],
  );
  final now = DateTime.now();
  final completed = trips
      .where((t) => t.resolvedStatus(now) == TripStatus.completed)
      .toList()
    ..sort((a, b) => b.startDate.compareTo(a.startDate)); // Newest first

  if (completed.isEmpty) return const [];

  final repo = ref.watch(tripRepositoryProvider);
  final results = <FeaturedTripData>[];

  for (final t in completed) {
    final days = await repo.getDays(t.id);
    final mainImageIds =
        days.map((d) => d.coverMediaId).whereType<String>().toSet();

    final media = await repo.watchMediaForTrip(t.id).first;
    final photos = media.where((m) => m.type == MediaType.photo).toList()
      ..sort((a, b) => a.takenAt.compareTo(b.takenAt));

    if (photos.isEmpty) continue;

    final audios = media.where((m) => m.type == MediaType.audio).toList()
      ..sort((a, b) => a.takenAt.compareTo(b.takenAt));

    results.add(await _buildFeaturedData(
      repo: repo,
      trip: t,
      photos: photos,
      audios: audios,
      mainImageIds: mainImageIds,
    ));
  }
  return results;
});

void rollNewFeatured(WidgetRef ref) {
  ref.read(_rollSeedProvider.notifier).state =
      DateTime.now().millisecondsSinceEpoch;
}

final tripFeaturedDataProvider =
    FutureProvider.family<FeaturedTripData?, String>((ref, tripId) async {
  final trip = await ref.watch(tripProvider(tripId).future);
  if (trip == null) return null;

  final days = await ref.watch(tripDaysProvider(tripId).future);
  final mainImageIds = days
      .map((d) => d.coverMediaId)
      .whereType<String>()
      .toSet();

  final media = await ref.watch(tripMediaProvider(tripId).future);
  final photos = media.where((m) => m.type == MediaType.photo).toList()
    ..sort((a, b) => a.takenAt.compareTo(b.takenAt));

  final audios = media.where((m) => m.type == MediaType.audio).toList()
    ..sort((a, b) => a.takenAt.compareTo(b.takenAt));

  final repo = ref.watch(tripRepositoryProvider);
  return _buildFeaturedData(
    repo: repo,
    trip: trip,
    photos: photos,
    audios: audios,
    mainImageIds: mainImageIds,
  );
});
