import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Trips,
  Days,
  ActivityBlocks,
  MediaItems,
  Playlists,
  PlaylistTracks,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(trips, trips.selectedPlaylistId);
          }
          if (from < 3) {
            try {
              await m.addColumn(days, days.coverMediaId);
            } catch (e) {
              debugPrint('Migration warning coverMediaId: $e');
            }
            try {
              await m.addColumn(days, days.dayRating);
            } catch (e) {
              debugPrint('Migration warning dayRating: $e');
            }
            try {
              await m.addColumn(trips, trips.averageDayRating);
            } catch (e) {
              debugPrint('Migration warning averageDayRating: $e');
            }
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'memory_map.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(
      file,
      logStatements: kDebugMode,
    );
  });
}
