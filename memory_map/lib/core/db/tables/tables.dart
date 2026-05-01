import 'package:drift/drift.dart';

@DataClassName('TripRow')
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get countriesJson => text().withDefault(const Constant('[]'))();
  TextColumn get citiesJson => text().withDefault(const Constant('[]'))();
  IntColumn get startDate => integer()();
  IntColumn get endDate => integer()();
  TextColumn get status => text().withDefault(const Constant('planning'))();
  TextColumn get coverMediaId => text().nullable()();
  TextColumn get selectedPlaylistId => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DayRow')
class Days extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  IntColumn get date => integer()();
  TextColumn get journalNote => text().nullable()();
  TextColumn get audioJournalMediaId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ActivityBlockRow')
class ActivityBlocks extends Table {
  TextColumn get id => text()();
  TextColumn get dayId => text()();
  IntColumn get startMinutes => integer()();
  IntColumn get endMinutes => integer()();
  TextColumn get title => text()();
  TextColumn get locationText => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MediaRow')
class MediaItems extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get dayId => text().nullable()();
  TextColumn get activityBlockId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get filePath => text()();
  IntColumn get takenAt => integer()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlaylistRow')
class Playlists extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('spotify'))();
  TextColumn get externalId => text()();
  TextColumn get name => text()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get country => text()();
  TextColumn get deepLink => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlaylistTrackRow')
class PlaylistTracks extends Table {
  TextColumn get id => text()();
  TextColumn get playlistId => text()();
  TextColumn get externalId => text()();
  TextColumn get name => text()();
  TextColumn get artist => text()();
  TextColumn get previewUrl => text().nullable()();
  TextColumn get albumArtUrl => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
