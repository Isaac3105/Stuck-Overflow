import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/trip_providers.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';

class FeaturedTripData {
  const FeaturedTripData({
    required this.trip,
    required this.photos,
    required this.audios,
  });
  final Trip trip;
  final List<MediaItem> photos;
  final List<MediaItem> audios;

  String? get coverImagePath {
    if (photos.isEmpty) return null;
    
    // 1. Trip-wide cover
    if (trip.coverMediaId != null) {
      final found = photos.where((p) => p.id == trip.coverMediaId).firstOrNull;
      if (found != null) return found.filePath;
    }

    // 2. We don't easily have access to days here, 
    // but the photos list is already sorted chronologically.
    // So photos.first is the first photo of the trip.
    
    return photos.first.filePath;
  }

  String get subtitle {
    final start = trip.startDate;
    final months = <String>[
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
    ];
    return '${months[start.month - 1]} de ${start.year}';
  }
}

/// Re-rolls each time it's invalidated.
final _rollSeedProvider = StateProvider<int>(
    (ref) => DateTime.now().millisecondsSinceEpoch);

final featuredCompletedTripProvider =
    FutureProvider<FeaturedTripData?>((ref) async {
  final seed = ref.watch(_rollSeedProvider);
  final tripsAsync = ref.watch(allTripsProvider);
  final trips = tripsAsync.maybeWhen(
    data: (t) => t,
    orElse: () => const <Trip>[],
  );
  final now = DateTime.now();
  final completed = trips
      .where((t) => t.resolvedStatus(now) == TripStatus.completed)
      .toList();
  if (completed.isEmpty) return null;

  final repo = ref.watch(tripRepositoryProvider);
  // Try up to N times to find a trip with photos.
  final rng = Random(seed);
  for (var attempts = 0; attempts < completed.length; attempts++) {
    final t = completed[rng.nextInt(completed.length)];
    final days = await repo.getDays(t.id);
    final mainImageIds = days.map((d) => d.coverMediaId).whereType<String>().toSet();

    final media = await repo.watchMediaForTrip(t.id).first;
    final photos = media.where((m) => m.type == MediaType.photo).toList()
      ..sort((a, b) => a.takenAt.compareTo(b.takenAt));

    if (photos.isEmpty) continue;
    final audios = media.where((m) => m.type == MediaType.audio).toList()
      ..sort((a, b) => a.takenAt.compareTo(b.takenAt));
    return FeaturedTripData(trip: t, photos: photos, audios: audios);
  }
  // Fallback: any completed trip even without photos.
  final t = completed.first;
  return FeaturedTripData(trip: t, photos: const [], audios: const []);
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

  return FeaturedTripData(trip: trip, photos: photos, audios: audios);
});
