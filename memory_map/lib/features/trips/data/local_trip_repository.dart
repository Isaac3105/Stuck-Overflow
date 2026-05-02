import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../domain/activity_block.dart';
import '../domain/day.dart';
import '../domain/media.dart';
import '../domain/trip.dart';
import 'trip_repository.dart';

class LocalTripRepository implements TripRepository {
  LocalTripRepository(this.db);
  final AppDatabase db;
  static const _uuid = Uuid();

  Trip _toTrip(TripRow r) => Trip(
        id: r.id,
        name: r.name,
        countries: List<String>.from(jsonDecode(r.countriesJson) as List),
        cities: List<String>.from(jsonDecode(r.citiesJson) as List),
        startDate: DateTime.fromMillisecondsSinceEpoch(r.startDate),
        endDate: DateTime.fromMillisecondsSinceEpoch(r.endDate),
        status: TripStatus.values.byName(r.status),
        coverMediaId: r.coverMediaId,
        selectedPlaylistId: r.selectedPlaylistId,
        averageDayRating: r.averageDayRating,
        createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
      );

  TripDay _toDay(DayRow r) => TripDay(
        id: r.id,
        tripId: r.tripId,
        date: DateTime.fromMillisecondsSinceEpoch(r.date),
        journalNote: r.journalNote,
        audioJournalMediaId: r.audioJournalMediaId,
        coverMediaId: r.coverMediaId,
        dayRating: r.dayRating,
      );

  ActivityBlock _toBlock(ActivityBlockRow r) => ActivityBlock(
        id: r.id,
        dayId: r.dayId,
        startMinutes: r.startMinutes,
        endMinutes: r.endMinutes,
        title: r.title,
        locationText: r.locationText,
        latitude: r.latitude,
        longitude: r.longitude,
        notes: r.notes,
        sortOrder: r.sortOrder,
      );

  MediaItem _toMedia(MediaRow r) => MediaItem(
        id: r.id,
        tripId: r.tripId,
        dayId: r.dayId,
        activityBlockId: r.activityBlockId,
        type: MediaType.values.byName(r.type),
        filePath: r.filePath,
        takenAt: DateTime.fromMillisecondsSinceEpoch(r.takenAt),
        durationMs: r.durationMs,
        sortOrder: r.sortOrder,
      );

  @override
  Stream<List<Trip>> watchTrips({TripStatus? status}) {
    final query = db.select(db.trips)
      ..orderBy([
        (t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc),
      ]);
    if (status != null) {
      query.where((t) => t.status.equals(status.name));
    }
    return query.watch().map((rows) => rows.map(_toTrip).toList());
  }

  @override
  Stream<Trip?> watchTrip(String tripId) {
    final query = db.select(db.trips)..where((t) => t.id.equals(tripId));
    return query.watchSingleOrNull().map((r) => r == null ? null : _toTrip(r));
  }

  @override
  Future<Trip?> getTrip(String tripId) async {
    final r = await (db.select(db.trips)..where((t) => t.id.equals(tripId)))
        .getSingleOrNull();
    return r == null ? null : _toTrip(r);
  }

  @override
  Future<Trip> createTrip({
    required String name,
    required List<String> countries,
    required List<String> cities,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    await db.transaction(() async {
      await db.into(db.trips).insert(TripsCompanion.insert(
            id: id,
            name: name,
            countriesJson: Value(jsonEncode(countries)),
            citiesJson: Value(jsonEncode(cities)),
            startDate: start.millisecondsSinceEpoch,
            endDate: end.millisecondsSinceEpoch,
            createdAt: now.millisecondsSinceEpoch,
          ));

      // Generate one Day row per date in the inclusive range.
      final totalDays = end.difference(start).inDays + 1;
      for (var i = 0; i < totalDays; i++) {
        final d = start.add(Duration(days: i));
        await db.into(db.days).insert(DaysCompanion.insert(
              id: _uuid.v4(),
              tripId: id,
              date: d.millisecondsSinceEpoch,
            ));
      }
    });

    return (await getTrip(id))!;
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    await db.transaction(() async {
      await (db.update(db.trips)..where((t) => t.id.equals(trip.id))).write(
        TripsCompanion(
          name: Value(trip.name),
          countriesJson: Value(jsonEncode(trip.countries)),
          citiesJson: Value(jsonEncode(trip.cities)),
          startDate: Value(trip.startDate.millisecondsSinceEpoch),
          endDate: Value(trip.endDate.millisecondsSinceEpoch),
          status: Value(trip.status.name),
          coverMediaId: Value(trip.coverMediaId),
          selectedPlaylistId: Value(trip.selectedPlaylistId),
          averageDayRating: Value(trip.averageDayRating),
        ),
      );

      // Sync days
      final existingRows = await (db.select(db.days)
            ..where((d) => d.tripId.equals(trip.id))
            ..orderBy([(d) => OrderingTerm(expression: d.date)]))
          .get();

      final start = DateTime(trip.startDate.year, trip.startDate.month, trip.startDate.day);
      final end = DateTime(trip.endDate.year, trip.endDate.month, trip.endDate.day);
      final newTotalDays = end.difference(start).inDays + 1;

      for (var i = 0; i < newTotalDays; i++) {
        final d = start.add(Duration(days: i));
        if (i < existingRows.length) {
          // Update existing day's date
          await (db.update(db.days)..where((row) => row.id.equals(existingRows[i].id)))
              .write(DaysCompanion(date: Value(d.millisecondsSinceEpoch)));
        } else {
          // Add new day
          await db.into(db.days).insert(DaysCompanion.insert(
                id: _uuid.v4(),
                tripId: trip.id,
                date: d.millisecondsSinceEpoch,
              ));
        }
      }

      // Delete excess days and their children
      if (existingRows.length > newTotalDays) {
        for (var i = newTotalDays; i < existingRows.length; i++) {
          final dayId = existingRows[i].id;
          await (db.delete(db.activityBlocks)..where((b) => b.dayId.equals(dayId))).go();
          await (db.delete(db.mediaItems)..where((m) => m.dayId.equals(dayId))).go();
          await (db.delete(db.days)..where((d) => d.id.equals(dayId))).go();
        }
      }
    });
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    await db.transaction(() async {
      final dayIds = await (db.select(db.days)
            ..where((d) => d.tripId.equals(tripId)))
          .map((d) => d.id)
          .get();
      for (final did in dayIds) {
        await (db.delete(db.activityBlocks)
              ..where((b) => b.dayId.equals(did)))
            .go();
      }
      await (db.delete(db.days)..where((d) => d.tripId.equals(tripId))).go();
      await (db.delete(db.mediaItems)..where((m) => m.tripId.equals(tripId)))
          .go();
      await (db.delete(db.trips)..where((t) => t.id.equals(tripId))).go();
    });
  }

  @override
  Future<void> setStatus(String tripId, TripStatus status) async {
    await (db.update(db.trips)..where((t) => t.id.equals(tripId)))
        .write(TripsCompanion(status: Value(status.name)));
  }

  @override
  Stream<List<TripDay>> watchDays(String tripId) {
    final q = db.select(db.days)
      ..where((d) => d.tripId.equals(tripId))
      ..orderBy([(d) => OrderingTerm(expression: d.date)]);
    return q.watch().map((rows) => rows.map(_toDay).toList());
  }

  @override
  Stream<TripDay?> watchDaysByDayId(String dayId) {
    final q = db.select(db.days)..where((d) => d.id.equals(dayId));
    return q.watchSingleOrNull().map((r) => r == null ? null : _toDay(r));
  }

  @override
  Future<List<TripDay>> getDays(String tripId) async {
    final q = db.select(db.days)
      ..where((d) => d.tripId.equals(tripId))
      ..orderBy([(d) => OrderingTerm(expression: d.date)]);
    final rows = await q.get();
    return rows.map(_toDay).toList();
  }

  @override
  Future<TripDay?> getDayByDate(String tripId, DateTime date) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final q = db.select(db.days)
      ..where((d) =>
          d.tripId.equals(tripId) &
          d.date.equals(dayStart.millisecondsSinceEpoch));
    final r = await q.getSingleOrNull();
    return r == null ? null : _toDay(r);
  }

  @override
  Stream<List<ActivityBlock>> watchBlocks(String dayId) {
    final q = db.select(db.activityBlocks)
      ..where((b) => b.dayId.equals(dayId))
      ..orderBy([
        (b) => OrderingTerm(expression: b.startMinutes),
        (b) => OrderingTerm(expression: b.sortOrder),
      ]);
    return q.watch().map((rows) => rows.map(_toBlock).toList());
  }

  @override
  Future<ActivityBlock> createBlock({
    required String dayId,
    required int startMinutes,
    required int endMinutes,
    required String title,
    String? locationText,
    double? latitude,
    double? longitude,
    String? notes,
  }) async {
    final id = _uuid.v4();
    await db.into(db.activityBlocks).insert(ActivityBlocksCompanion.insert(
          id: id,
          dayId: dayId,
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          title: title,
          locationText: Value(locationText),
          latitude: Value(latitude),
          longitude: Value(longitude),
          notes: Value(notes),
        ));
    final row = await (db.select(db.activityBlocks)
          ..where((b) => b.id.equals(id)))
        .getSingle();
    return _toBlock(row);
  }

  @override
  Future<void> updateBlock(ActivityBlock block) async {
    await (db.update(db.activityBlocks)..where((b) => b.id.equals(block.id)))
        .write(ActivityBlocksCompanion(
      startMinutes: Value(block.startMinutes),
      endMinutes: Value(block.endMinutes),
      title: Value(block.title),
      locationText: Value(block.locationText),
      latitude: Value(block.latitude),
      longitude: Value(block.longitude),
      notes: Value(block.notes),
      sortOrder: Value(block.sortOrder),
    ));
  }

  @override
  Future<void> deleteBlock(String blockId) async {
    await (db.delete(db.activityBlocks)..where((b) => b.id.equals(blockId)))
        .go();
  }

  @override
  Future<ActivityBlock?> getActivityBlock(String blockId) async {
    final row = await (db.select(db.activityBlocks)
          ..where((b) => b.id.equals(blockId)))
        .getSingleOrNull();
    return row == null ? null : _toBlock(row);
  }

  @override
  Stream<List<MediaItem>> watchMediaForTrip(String tripId) {
    final q = db.select(db.mediaItems)
      ..where((m) => m.tripId.equals(tripId))
      ..orderBy([(m) => OrderingTerm(expression: m.takenAt)]);
    return q.watch().map((rows) => rows.map(_toMedia).toList());
  }

  @override
  Stream<List<MediaItem>> watchMediaForDay(String dayId) {
    final q = db.select(db.mediaItems)
      ..where((m) => m.dayId.equals(dayId))
      ..orderBy([(m) => OrderingTerm(expression: m.takenAt)]);
    return q.watch().map((rows) => rows.map(_toMedia).toList());
  }

  @override
  Stream<List<MediaItem>> watchAllMedia() {
    final q = db.select(db.mediaItems)
      ..orderBy([
        (m) => OrderingTerm(expression: m.takenAt, mode: OrderingMode.desc),
      ]);
    return q.watch().map((rows) => rows.map(_toMedia).toList());
  }

  @override
  Future<MediaItem> addMedia({
    required String tripId,
    String? dayId,
    String? activityBlockId,
    required MediaType type,
    required String filePath,
    int? durationMs,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await db.into(db.mediaItems).insert(MediaItemsCompanion.insert(
          id: id,
          tripId: tripId,
          dayId: Value(dayId),
          activityBlockId: Value(activityBlockId),
          type: type.name,
          filePath: filePath,
          takenAt: now.millisecondsSinceEpoch,
          durationMs: Value(durationMs),
        ));
    return (await getMedia(id))!;
  }

  @override
  Future<void> deleteMedia(String mediaId) async {
    await (db.delete(db.mediaItems)..where((m) => m.id.equals(mediaId))).go();
  }

  @override
  Future<MediaItem?> getMedia(String mediaId) async {
    final r = await (db.select(db.mediaItems)
          ..where((m) => m.id.equals(mediaId)))
        .getSingleOrNull();
    return r == null ? null : _toMedia(r);
  }

  @override
  Future<void> setTripCover(String tripId, String mediaId) async {
    await (db.update(db.trips)..where((t) => t.id.equals(tripId)))
        .write(TripsCompanion(coverMediaId: Value(mediaId)));
  }

  @override
  Future<void> setDayAudio(String dayId, String mediaId) async {
    await (db.update(db.days)..where((d) => d.id.equals(dayId)))
        .write(DaysCompanion(audioJournalMediaId: Value(mediaId)));
  }

  @override
  Future<void> setDayCover(String dayId, String? mediaId) async {
    await (db.update(db.days)..where((d) => d.id.equals(dayId)))
        .write(DaysCompanion(coverMediaId: Value(mediaId)));
  }

  @override
  Future<void> setTripPlaylist(String tripId, String? playlistId) async {
    await (db.update(db.trips)..where((t) => t.id.equals(tripId))).write(
      TripsCompanion(selectedPlaylistId: Value(playlistId)),
    );
  }

  @override
  Future<void> setDayRating({required String dayId, required int stars}) async {
    if (stars < 1 || stars > 5) {
      throw ArgumentError.value(stars, 'stars', 'must be between 1 and 5');
    }
    final row = await (db.select(db.days)..where((d) => d.id.equals(dayId)))
        .getSingleOrNull();
    if (row == null) return;
    await (db.update(db.days)..where((d) => d.id.equals(dayId)))
        .write(DaysCompanion(dayRating: Value(stars)));
    await _recomputeTripAverageRating(row.tripId);
  }

  @override
  Future<void> clearDayRating(String dayId) async {
    final row = await (db.select(db.days)..where((d) => d.id.equals(dayId)))
        .getSingleOrNull();
    if (row == null) return;
    await (db.update(db.days)..where((d) => d.id.equals(dayId))).write(
      const DaysCompanion(dayRating: Value(null)),
    );
    await _recomputeTripAverageRating(row.tripId);
  }

  Future<void> _recomputeTripAverageRating(String tripId) async {
    final rows = await (db.select(db.days)..where((d) => d.tripId.equals(tripId)))
        .get();
    if (rows.isEmpty) return;
    final hasAnyRating = rows.any((r) => r.dayRating != null);
    final double? avg = hasAnyRating
        ? rows.map((r) => (r.dayRating ?? 0).toDouble()).fold<double>(0, (a, b) => a + b) /
            rows.length
        : null;
    await (db.update(db.trips)..where((t) => t.id.equals(tripId))).write(
      TripsCompanion(averageDayRating: Value(avg)),
    );
  }
}
