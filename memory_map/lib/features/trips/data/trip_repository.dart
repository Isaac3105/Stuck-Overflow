import '../domain/activity_block.dart';
import '../domain/day.dart';
import '../domain/media.dart';
import '../domain/trip.dart';

/// Abstract layer so we can swap to a Cloud-backed implementation later
/// without changing presentation code.
abstract class TripRepository {
  Stream<List<Trip>> watchTrips({TripStatus? status});
  Stream<Trip?> watchTrip(String tripId);
  Future<Trip?> getTrip(String tripId);
  Future<Trip> createTrip({
    required String name,
    required List<String> countries,
    required List<String> cities,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<void> updateTrip(Trip trip);
  Future<void> deleteTrip(String tripId);
  Future<void> setStatus(String tripId, TripStatus status);

  Stream<List<TripDay>> watchDays(String tripId);
  Future<List<TripDay>> getDays(String tripId);
  Future<TripDay?> getDayByDate(String tripId, DateTime date);

  Stream<List<ActivityBlock>> watchBlocks(String dayId);
  Future<ActivityBlock> createBlock({
    required String dayId,
    required int startMinutes,
    required int endMinutes,
    required String title,
    String? locationText,
    double? latitude,
    double? longitude,
    String? notes,
  });
  Future<void> updateBlock(ActivityBlock block);
  Future<void> deleteBlock(String blockId);

  Stream<List<MediaItem>> watchMediaForTrip(String tripId);
  Stream<List<MediaItem>> watchMediaForDay(String dayId);
  Stream<List<MediaItem>> watchAllMedia();
  Future<MediaItem> addMedia({
    required String tripId,
    String? dayId,
    String? activityBlockId,
    required MediaType type,
    required String filePath,
    int? durationMs,
  });
  Future<void> deleteMedia(String mediaId);
  Future<MediaItem?> getMedia(String mediaId);
  Future<void> setTripCover(String tripId, String mediaId);
  Future<void> setDayAudio(String dayId, String mediaId);
  Future<void> setTripPlaylist(String tripId, String? playlistId);
}
