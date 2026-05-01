import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../domain/activity_block.dart';
import '../domain/day.dart';
import '../domain/media.dart';
import '../domain/trip.dart';
import 'local_trip_repository.dart';
import 'trip_repository.dart';

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return LocalTripRepository(ref.watch(databaseProvider));
});

final tripsByStatusProvider =
    StreamProvider.family<List<Trip>, TripStatus?>((ref, status) {
  return ref.watch(tripRepositoryProvider).watchTrips(status: status);
});

final allTripsProvider = StreamProvider<List<Trip>>((ref) {
  return ref.watch(tripRepositoryProvider).watchTrips();
});

final tripProvider = StreamProvider.family<Trip?, String>((ref, tripId) {
  return ref.watch(tripRepositoryProvider).watchTrip(tripId);
});

final tripDaysProvider =
    StreamProvider.family<List<TripDay>, String>((ref, tripId) {
  return ref.watch(tripRepositoryProvider).watchDays(tripId);
});

final dayProvider = StreamProvider.family<TripDay?, String>((ref, dayId) {
  return ref.watch(tripRepositoryProvider).watchDaysByDayId(dayId);
});

final dayBlocksProvider =
    StreamProvider.family<List<ActivityBlock>, String>((ref, dayId) {
  return ref.watch(tripRepositoryProvider).watchBlocks(dayId);
});

final tripMediaProvider =
    StreamProvider.family<List<MediaItem>, String>((ref, tripId) {
  return ref.watch(tripRepositoryProvider).watchMediaForTrip(tripId);
});

final dayMediaProvider =
    StreamProvider.family<List<MediaItem>, String>((ref, dayId) {
  return ref.watch(tripRepositoryProvider).watchMediaForDay(dayId);
});

final allMediaProvider = StreamProvider<List<MediaItem>>((ref) {
  return ref.watch(tripRepositoryProvider).watchAllMedia();
});

/// Resolves the trip whose date range contains today and is not yet completed.
final currentTripProvider = Provider<AsyncValue<Trip?>>((ref) {
  final tripsAsync = ref.watch(allTripsProvider);
  return tripsAsync.whenData((trips) {
    final now = DateTime.now();
    for (final t in trips) {
      if (t.status == TripStatus.completed) continue;
      final start = DateTime(t.startDate.year, t.startDate.month, t.startDate.day);
      final end = DateTime(t.endDate.year, t.endDate.month, t.endDate.day, 23, 59, 59);
      if (!now.isBefore(start) && !now.isAfter(end)) {
        return t;
      }
    }
    return null;
  });
});
