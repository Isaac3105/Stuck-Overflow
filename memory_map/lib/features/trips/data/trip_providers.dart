import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../domain/activity_block.dart';
import '../domain/day.dart';
import '../domain/media.dart';
import '../domain/trip.dart';
import '../domain/trip_itinerary_unlock.dart';
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

/// Ticks so itinerary / backlog rules refresh after midnight without a DB change.
final dayCalendarTickProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  await for (final _ in Stream.periodic(const Duration(minutes: 1))) {
    yield DateTime.now();
  }
});

/// Calendar day strictly before today that still needs a 1–5 rating.
final pendingPastTripDayRatingProvider =
    Provider.autoDispose.family<AsyncValue<TripDay?>, String>((ref, tripId) {
  ref.watch(dayCalendarTickProvider);
  return ref.watch(tripDaysProvider(tripId)).whenData(
        (days) => pendingPastDayNeedingRating(days, DateTime.now()),
      );
});

/// Unlocked itinerary day (respects early end: next day only on next calendar day).
final activeTripItineraryDayProvider =
    Provider.autoDispose.family<AsyncValue<TripDay?>, String>((ref, tripId) {
  ref.watch(dayCalendarTickProvider);
  return ref.watch(tripDaysProvider(tripId)).whenData(
        (days) => unlockedItineraryDay(days, DateTime.now()),
      );
});

/// Resolves the cover image path for a given trip.
final tripCoverImagePathProvider = Provider.autoDispose.family<String?, Trip>((ref, trip) {
  final mediaAsync = ref.watch(tripMediaProvider(trip.id));
  final daysAsync = ref.watch(tripDaysProvider(trip.id));

  return mediaAsync.maybeWhen(
    data: (list) {
      // 1. Specific trip cover
      if (trip.coverMediaId != null) {
        for (final m in list) {
          if (m.id == trip.coverMediaId) return m.filePath;
        }
      }

      // 2. Try to find the first "main image" of any day
      final mainImageIds = daysAsync.maybeWhen(
        data: (days) => days.map((d) => d.coverMediaId).whereType<String>().toSet(),
        orElse: () => <String>{},
      );

      if (mainImageIds.isNotEmpty) {
        for (final m in list) {
          if (mainImageIds.contains(m.id)) return m.filePath;
        }
      }

      // 3. Fallback to first photo
      for (final m in list) {
        if (m.type.name == 'photo') return m.filePath;
      }
      return null;
    },
    orElse: () => null,
  );
});

/// Resolves the cover visual (photo or video) for a given trip.
final tripCoverMediaProvider =
    Provider.autoDispose.family<MediaItem?, Trip>((ref, trip) {
  final mediaAsync = ref.watch(tripMediaProvider(trip.id));
  final daysAsync = ref.watch(tripDaysProvider(trip.id));

  return mediaAsync.maybeWhen(
    data: (list) {
      MediaItem? byId(String id) {
        for (final m in list) {
          if (m.id == id) return m;
        }
        return null;
      }

      // 1. Specific trip cover
      if (trip.coverMediaId != null) {
        final m = byId(trip.coverMediaId!);
        if (m != null) return m;
      }

      // 2. Try to find the first "main image" of any day
      final mainIds = daysAsync.maybeWhen(
        data: (days) =>
            days.map((d) => d.coverMediaId).whereType<String>().toSet(),
        orElse: () => <String>{},
      );
      if (mainIds.isNotEmpty) {
        for (final id in mainIds) {
          final m = byId(id);
          if (m != null) return m;
        }
      }

      // 3. Fallback to first photo/video
      for (final m in list) {
        if (m.type == MediaType.photo || m.type == MediaType.video) return m;
      }
      return null;
    },
    orElse: () => null,
  );
});
