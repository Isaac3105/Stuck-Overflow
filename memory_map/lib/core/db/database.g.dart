// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TripsTable extends Trips with TableInfo<$TripsTable, TripRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countriesJsonMeta = const VerificationMeta(
    'countriesJson',
  );
  @override
  late final GeneratedColumn<String> countriesJson = GeneratedColumn<String>(
    'countries_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _citiesJsonMeta = const VerificationMeta(
    'citiesJson',
  );
  @override
  late final GeneratedColumn<String> citiesJson = GeneratedColumn<String>(
    'cities_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<int> startDate = GeneratedColumn<int>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<int> endDate = GeneratedColumn<int>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planning'),
  );
  static const VerificationMeta _coverMediaIdMeta = const VerificationMeta(
    'coverMediaId',
  );
  @override
  late final GeneratedColumn<String> coverMediaId = GeneratedColumn<String>(
    'cover_media_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedPlaylistIdMeta =
      const VerificationMeta('selectedPlaylistId');
  @override
  late final GeneratedColumn<String> selectedPlaylistId =
      GeneratedColumn<String>(
        'selected_playlist_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    countriesJson,
    citiesJson,
    startDate,
    endDate,
    status,
    coverMediaId,
    selectedPlaylistId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('countries_json')) {
      context.handle(
        _countriesJsonMeta,
        countriesJson.isAcceptableOrUnknown(
          data['countries_json']!,
          _countriesJsonMeta,
        ),
      );
    }
    if (data.containsKey('cities_json')) {
      context.handle(
        _citiesJsonMeta,
        citiesJson.isAcceptableOrUnknown(data['cities_json']!, _citiesJsonMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('cover_media_id')) {
      context.handle(
        _coverMediaIdMeta,
        coverMediaId.isAcceptableOrUnknown(
          data['cover_media_id']!,
          _coverMediaIdMeta,
        ),
      );
    }
    if (data.containsKey('selected_playlist_id')) {
      context.handle(
        _selectedPlaylistIdMeta,
        selectedPlaylistId.isAcceptableOrUnknown(
          data['selected_playlist_id']!,
          _selectedPlaylistIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      countriesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}countries_json'],
      )!,
      citiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cities_json'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      coverMediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_media_id'],
      ),
      selectedPlaylistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_playlist_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class TripRow extends DataClass implements Insertable<TripRow> {
  final String id;
  final String name;
  final String countriesJson;
  final String citiesJson;
  final int startDate;
  final int endDate;
  final String status;
  final String? coverMediaId;
  final String? selectedPlaylistId;
  final int createdAt;
  const TripRow({
    required this.id,
    required this.name,
    required this.countriesJson,
    required this.citiesJson,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.coverMediaId,
    this.selectedPlaylistId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['countries_json'] = Variable<String>(countriesJson);
    map['cities_json'] = Variable<String>(citiesJson);
    map['start_date'] = Variable<int>(startDate);
    map['end_date'] = Variable<int>(endDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || coverMediaId != null) {
      map['cover_media_id'] = Variable<String>(coverMediaId);
    }
    if (!nullToAbsent || selectedPlaylistId != null) {
      map['selected_playlist_id'] = Variable<String>(selectedPlaylistId);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      name: Value(name),
      countriesJson: Value(countriesJson),
      citiesJson: Value(citiesJson),
      startDate: Value(startDate),
      endDate: Value(endDate),
      status: Value(status),
      coverMediaId: coverMediaId == null && nullToAbsent
          ? const Value.absent()
          : Value(coverMediaId),
      selectedPlaylistId: selectedPlaylistId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedPlaylistId),
      createdAt: Value(createdAt),
    );
  }

  factory TripRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      countriesJson: serializer.fromJson<String>(json['countriesJson']),
      citiesJson: serializer.fromJson<String>(json['citiesJson']),
      startDate: serializer.fromJson<int>(json['startDate']),
      endDate: serializer.fromJson<int>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      coverMediaId: serializer.fromJson<String?>(json['coverMediaId']),
      selectedPlaylistId: serializer.fromJson<String?>(
        json['selectedPlaylistId'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'countriesJson': serializer.toJson<String>(countriesJson),
      'citiesJson': serializer.toJson<String>(citiesJson),
      'startDate': serializer.toJson<int>(startDate),
      'endDate': serializer.toJson<int>(endDate),
      'status': serializer.toJson<String>(status),
      'coverMediaId': serializer.toJson<String?>(coverMediaId),
      'selectedPlaylistId': serializer.toJson<String?>(selectedPlaylistId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  TripRow copyWith({
    String? id,
    String? name,
    String? countriesJson,
    String? citiesJson,
    int? startDate,
    int? endDate,
    String? status,
    Value<String?> coverMediaId = const Value.absent(),
    Value<String?> selectedPlaylistId = const Value.absent(),
    int? createdAt,
  }) => TripRow(
    id: id ?? this.id,
    name: name ?? this.name,
    countriesJson: countriesJson ?? this.countriesJson,
    citiesJson: citiesJson ?? this.citiesJson,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    status: status ?? this.status,
    coverMediaId: coverMediaId.present ? coverMediaId.value : this.coverMediaId,
    selectedPlaylistId: selectedPlaylistId.present
        ? selectedPlaylistId.value
        : this.selectedPlaylistId,
    createdAt: createdAt ?? this.createdAt,
  );
  TripRow copyWithCompanion(TripsCompanion data) {
    return TripRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      countriesJson: data.countriesJson.present
          ? data.countriesJson.value
          : this.countriesJson,
      citiesJson: data.citiesJson.present
          ? data.citiesJson.value
          : this.citiesJson,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      coverMediaId: data.coverMediaId.present
          ? data.coverMediaId.value
          : this.coverMediaId,
      selectedPlaylistId: data.selectedPlaylistId.present
          ? data.selectedPlaylistId.value
          : this.selectedPlaylistId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('countriesJson: $countriesJson, ')
          ..write('citiesJson: $citiesJson, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('coverMediaId: $coverMediaId, ')
          ..write('selectedPlaylistId: $selectedPlaylistId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    countriesJson,
    citiesJson,
    startDate,
    endDate,
    status,
    coverMediaId,
    selectedPlaylistId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.countriesJson == this.countriesJson &&
          other.citiesJson == this.citiesJson &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.coverMediaId == this.coverMediaId &&
          other.selectedPlaylistId == this.selectedPlaylistId &&
          other.createdAt == this.createdAt);
}

class TripsCompanion extends UpdateCompanion<TripRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> countriesJson;
  final Value<String> citiesJson;
  final Value<int> startDate;
  final Value<int> endDate;
  final Value<String> status;
  final Value<String?> coverMediaId;
  final Value<String?> selectedPlaylistId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.countriesJson = const Value.absent(),
    this.citiesJson = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.coverMediaId = const Value.absent(),
    this.selectedPlaylistId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsCompanion.insert({
    required String id,
    required String name,
    this.countriesJson = const Value.absent(),
    this.citiesJson = const Value.absent(),
    required int startDate,
    required int endDate,
    this.status = const Value.absent(),
    this.coverMediaId = const Value.absent(),
    this.selectedPlaylistId = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate),
       createdAt = Value(createdAt);
  static Insertable<TripRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? countriesJson,
    Expression<String>? citiesJson,
    Expression<int>? startDate,
    Expression<int>? endDate,
    Expression<String>? status,
    Expression<String>? coverMediaId,
    Expression<String>? selectedPlaylistId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (countriesJson != null) 'countries_json': countriesJson,
      if (citiesJson != null) 'cities_json': citiesJson,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (coverMediaId != null) 'cover_media_id': coverMediaId,
      if (selectedPlaylistId != null)
        'selected_playlist_id': selectedPlaylistId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? countriesJson,
    Value<String>? citiesJson,
    Value<int>? startDate,
    Value<int>? endDate,
    Value<String>? status,
    Value<String?>? coverMediaId,
    Value<String?>? selectedPlaylistId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      countriesJson: countriesJson ?? this.countriesJson,
      citiesJson: citiesJson ?? this.citiesJson,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      coverMediaId: coverMediaId ?? this.coverMediaId,
      selectedPlaylistId: selectedPlaylistId ?? this.selectedPlaylistId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (countriesJson.present) {
      map['countries_json'] = Variable<String>(countriesJson.value);
    }
    if (citiesJson.present) {
      map['cities_json'] = Variable<String>(citiesJson.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<int>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<int>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (coverMediaId.present) {
      map['cover_media_id'] = Variable<String>(coverMediaId.value);
    }
    if (selectedPlaylistId.present) {
      map['selected_playlist_id'] = Variable<String>(selectedPlaylistId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('countriesJson: $countriesJson, ')
          ..write('citiesJson: $citiesJson, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('coverMediaId: $coverMediaId, ')
          ..write('selectedPlaylistId: $selectedPlaylistId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DaysTable extends Days with TableInfo<$DaysTable, DayRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _journalNoteMeta = const VerificationMeta(
    'journalNote',
  );
  @override
  late final GeneratedColumn<String> journalNote = GeneratedColumn<String>(
    'journal_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioJournalMediaIdMeta =
      const VerificationMeta('audioJournalMediaId');
  @override
  late final GeneratedColumn<String> audioJournalMediaId =
      GeneratedColumn<String>(
        'audio_journal_media_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    date,
    journalNote,
    audioJournalMediaId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'days';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('journal_note')) {
      context.handle(
        _journalNoteMeta,
        journalNote.isAcceptableOrUnknown(
          data['journal_note']!,
          _journalNoteMeta,
        ),
      );
    }
    if (data.containsKey('audio_journal_media_id')) {
      context.handle(
        _audioJournalMediaIdMeta,
        audioJournalMediaId.isAcceptableOrUnknown(
          data['audio_journal_media_id']!,
          _audioJournalMediaIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      journalNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal_note'],
      ),
      audioJournalMediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_journal_media_id'],
      ),
    );
  }

  @override
  $DaysTable createAlias(String alias) {
    return $DaysTable(attachedDatabase, alias);
  }
}

class DayRow extends DataClass implements Insertable<DayRow> {
  final String id;
  final String tripId;
  final int date;
  final String? journalNote;
  final String? audioJournalMediaId;
  const DayRow({
    required this.id,
    required this.tripId,
    required this.date,
    this.journalNote,
    this.audioJournalMediaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || journalNote != null) {
      map['journal_note'] = Variable<String>(journalNote);
    }
    if (!nullToAbsent || audioJournalMediaId != null) {
      map['audio_journal_media_id'] = Variable<String>(audioJournalMediaId);
    }
    return map;
  }

  DaysCompanion toCompanion(bool nullToAbsent) {
    return DaysCompanion(
      id: Value(id),
      tripId: Value(tripId),
      date: Value(date),
      journalNote: journalNote == null && nullToAbsent
          ? const Value.absent()
          : Value(journalNote),
      audioJournalMediaId: audioJournalMediaId == null && nullToAbsent
          ? const Value.absent()
          : Value(audioJournalMediaId),
    );
  }

  factory DayRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayRow(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      date: serializer.fromJson<int>(json['date']),
      journalNote: serializer.fromJson<String?>(json['journalNote']),
      audioJournalMediaId: serializer.fromJson<String?>(
        json['audioJournalMediaId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'date': serializer.toJson<int>(date),
      'journalNote': serializer.toJson<String?>(journalNote),
      'audioJournalMediaId': serializer.toJson<String?>(audioJournalMediaId),
    };
  }

  DayRow copyWith({
    String? id,
    String? tripId,
    int? date,
    Value<String?> journalNote = const Value.absent(),
    Value<String?> audioJournalMediaId = const Value.absent(),
  }) => DayRow(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    date: date ?? this.date,
    journalNote: journalNote.present ? journalNote.value : this.journalNote,
    audioJournalMediaId: audioJournalMediaId.present
        ? audioJournalMediaId.value
        : this.audioJournalMediaId,
  );
  DayRow copyWithCompanion(DaysCompanion data) {
    return DayRow(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      date: data.date.present ? data.date.value : this.date,
      journalNote: data.journalNote.present
          ? data.journalNote.value
          : this.journalNote,
      audioJournalMediaId: data.audioJournalMediaId.present
          ? data.audioJournalMediaId.value
          : this.audioJournalMediaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayRow(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('date: $date, ')
          ..write('journalNote: $journalNote, ')
          ..write('audioJournalMediaId: $audioJournalMediaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tripId, date, journalNote, audioJournalMediaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayRow &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.date == this.date &&
          other.journalNote == this.journalNote &&
          other.audioJournalMediaId == this.audioJournalMediaId);
}

class DaysCompanion extends UpdateCompanion<DayRow> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<int> date;
  final Value<String?> journalNote;
  final Value<String?> audioJournalMediaId;
  final Value<int> rowid;
  const DaysCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.date = const Value.absent(),
    this.journalNote = const Value.absent(),
    this.audioJournalMediaId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DaysCompanion.insert({
    required String id,
    required String tripId,
    required int date,
    this.journalNote = const Value.absent(),
    this.audioJournalMediaId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       date = Value(date);
  static Insertable<DayRow> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<int>? date,
    Expression<String>? journalNote,
    Expression<String>? audioJournalMediaId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (date != null) 'date': date,
      if (journalNote != null) 'journal_note': journalNote,
      if (audioJournalMediaId != null)
        'audio_journal_media_id': audioJournalMediaId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DaysCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<int>? date,
    Value<String?>? journalNote,
    Value<String?>? audioJournalMediaId,
    Value<int>? rowid,
  }) {
    return DaysCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      date: date ?? this.date,
      journalNote: journalNote ?? this.journalNote,
      audioJournalMediaId: audioJournalMediaId ?? this.audioJournalMediaId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (journalNote.present) {
      map['journal_note'] = Variable<String>(journalNote.value);
    }
    if (audioJournalMediaId.present) {
      map['audio_journal_media_id'] = Variable<String>(
        audioJournalMediaId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DaysCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('date: $date, ')
          ..write('journalNote: $journalNote, ')
          ..write('audioJournalMediaId: $audioJournalMediaId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityBlocksTable extends ActivityBlocks
    with TableInfo<$ActivityBlocksTable, ActivityBlockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationTextMeta = const VerificationMeta(
    'locationText',
  );
  @override
  late final GeneratedColumn<String> locationText = GeneratedColumn<String>(
    'location_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayId,
    startMinutes,
    endMinutes,
    title,
    locationText,
    latitude,
    longitude,
    notes,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityBlockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinutesMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('location_text')) {
      context.handle(
        _locationTextMeta,
        locationText.isAcceptableOrUnknown(
          data['location_text']!,
          _locationTextMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityBlockRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityBlockRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      )!,
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      locationText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_text'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ActivityBlocksTable createAlias(String alias) {
    return $ActivityBlocksTable(attachedDatabase, alias);
  }
}

class ActivityBlockRow extends DataClass
    implements Insertable<ActivityBlockRow> {
  final String id;
  final String dayId;
  final int startMinutes;
  final int endMinutes;
  final String title;
  final String? locationText;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final int sortOrder;
  const ActivityBlockRow({
    required this.id,
    required this.dayId,
    required this.startMinutes,
    required this.endMinutes,
    required this.title,
    this.locationText,
    this.latitude,
    this.longitude,
    this.notes,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_id'] = Variable<String>(dayId);
    map['start_minutes'] = Variable<int>(startMinutes);
    map['end_minutes'] = Variable<int>(endMinutes);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || locationText != null) {
      map['location_text'] = Variable<String>(locationText);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ActivityBlocksCompanion toCompanion(bool nullToAbsent) {
    return ActivityBlocksCompanion(
      id: Value(id),
      dayId: Value(dayId),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      title: Value(title),
      locationText: locationText == null && nullToAbsent
          ? const Value.absent()
          : Value(locationText),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
    );
  }

  factory ActivityBlockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityBlockRow(
      id: serializer.fromJson<String>(json['id']),
      dayId: serializer.fromJson<String>(json['dayId']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      title: serializer.fromJson<String>(json['title']),
      locationText: serializer.fromJson<String?>(json['locationText']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayId': serializer.toJson<String>(dayId),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'title': serializer.toJson<String>(title),
      'locationText': serializer.toJson<String?>(locationText),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ActivityBlockRow copyWith({
    String? id,
    String? dayId,
    int? startMinutes,
    int? endMinutes,
    String? title,
    Value<String?> locationText = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
  }) => ActivityBlockRow(
    id: id ?? this.id,
    dayId: dayId ?? this.dayId,
    startMinutes: startMinutes ?? this.startMinutes,
    endMinutes: endMinutes ?? this.endMinutes,
    title: title ?? this.title,
    locationText: locationText.present ? locationText.value : this.locationText,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ActivityBlockRow copyWithCompanion(ActivityBlocksCompanion data) {
    return ActivityBlockRow(
      id: data.id.present ? data.id.value : this.id,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      title: data.title.present ? data.title.value : this.title,
      locationText: data.locationText.present
          ? data.locationText.value
          : this.locationText,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityBlockRow(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('title: $title, ')
          ..write('locationText: $locationText, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayId,
    startMinutes,
    endMinutes,
    title,
    locationText,
    latitude,
    longitude,
    notes,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityBlockRow &&
          other.id == this.id &&
          other.dayId == this.dayId &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.title == this.title &&
          other.locationText == this.locationText &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder);
}

class ActivityBlocksCompanion extends UpdateCompanion<ActivityBlockRow> {
  final Value<String> id;
  final Value<String> dayId;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<String> title;
  final Value<String?> locationText;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ActivityBlocksCompanion({
    this.id = const Value.absent(),
    this.dayId = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.title = const Value.absent(),
    this.locationText = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityBlocksCompanion.insert({
    required String id,
    required String dayId,
    required int startMinutes,
    required int endMinutes,
    required String title,
    this.locationText = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayId = Value(dayId),
       startMinutes = Value(startMinutes),
       endMinutes = Value(endMinutes),
       title = Value(title);
  static Insertable<ActivityBlockRow> custom({
    Expression<String>? id,
    Expression<String>? dayId,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<String>? title,
    Expression<String>? locationText,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayId != null) 'day_id': dayId,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (title != null) 'title': title,
      if (locationText != null) 'location_text': locationText,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityBlocksCompanion copyWith({
    Value<String>? id,
    Value<String>? dayId,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<String>? title,
    Value<String?>? locationText,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ActivityBlocksCompanion(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      title: title ?? this.title,
      locationText: locationText ?? this.locationText,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (locationText.present) {
      map['location_text'] = Variable<String>(locationText.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityBlocksCompanion(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('title: $title, ')
          ..write('locationText: $locationText, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaItemsTable extends MediaItems
    with TableInfo<$MediaItemsTable, MediaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityBlockIdMeta = const VerificationMeta(
    'activityBlockId',
  );
  @override
  late final GeneratedColumn<String> activityBlockId = GeneratedColumn<String>(
    'activity_block_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<int> takenAt = GeneratedColumn<int>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    dayId,
    activityBlockId,
    type,
    filePath,
    takenAt,
    durationMs,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    }
    if (data.containsKey('activity_block_id')) {
      context.handle(
        _activityBlockIdMeta,
        activityBlockId.isAcceptableOrUnknown(
          data['activity_block_id']!,
          _activityBlockIdMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      ),
      activityBlockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_block_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taken_at'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $MediaItemsTable createAlias(String alias) {
    return $MediaItemsTable(attachedDatabase, alias);
  }
}

class MediaRow extends DataClass implements Insertable<MediaRow> {
  final String id;
  final String tripId;
  final String? dayId;
  final String? activityBlockId;
  final String type;
  final String filePath;
  final int takenAt;
  final int? durationMs;
  final int sortOrder;
  const MediaRow({
    required this.id,
    required this.tripId,
    this.dayId,
    this.activityBlockId,
    required this.type,
    required this.filePath,
    required this.takenAt,
    this.durationMs,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    if (!nullToAbsent || dayId != null) {
      map['day_id'] = Variable<String>(dayId);
    }
    if (!nullToAbsent || activityBlockId != null) {
      map['activity_block_id'] = Variable<String>(activityBlockId);
    }
    map['type'] = Variable<String>(type);
    map['file_path'] = Variable<String>(filePath);
    map['taken_at'] = Variable<int>(takenAt);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  MediaItemsCompanion toCompanion(bool nullToAbsent) {
    return MediaItemsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      dayId: dayId == null && nullToAbsent
          ? const Value.absent()
          : Value(dayId),
      activityBlockId: activityBlockId == null && nullToAbsent
          ? const Value.absent()
          : Value(activityBlockId),
      type: Value(type),
      filePath: Value(filePath),
      takenAt: Value(takenAt),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      sortOrder: Value(sortOrder),
    );
  }

  factory MediaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaRow(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      dayId: serializer.fromJson<String?>(json['dayId']),
      activityBlockId: serializer.fromJson<String?>(json['activityBlockId']),
      type: serializer.fromJson<String>(json['type']),
      filePath: serializer.fromJson<String>(json['filePath']),
      takenAt: serializer.fromJson<int>(json['takenAt']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'dayId': serializer.toJson<String?>(dayId),
      'activityBlockId': serializer.toJson<String?>(activityBlockId),
      'type': serializer.toJson<String>(type),
      'filePath': serializer.toJson<String>(filePath),
      'takenAt': serializer.toJson<int>(takenAt),
      'durationMs': serializer.toJson<int?>(durationMs),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  MediaRow copyWith({
    String? id,
    String? tripId,
    Value<String?> dayId = const Value.absent(),
    Value<String?> activityBlockId = const Value.absent(),
    String? type,
    String? filePath,
    int? takenAt,
    Value<int?> durationMs = const Value.absent(),
    int? sortOrder,
  }) => MediaRow(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    dayId: dayId.present ? dayId.value : this.dayId,
    activityBlockId: activityBlockId.present
        ? activityBlockId.value
        : this.activityBlockId,
    type: type ?? this.type,
    filePath: filePath ?? this.filePath,
    takenAt: takenAt ?? this.takenAt,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  MediaRow copyWithCompanion(MediaItemsCompanion data) {
    return MediaRow(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      activityBlockId: data.activityBlockId.present
          ? data.activityBlockId.value
          : this.activityBlockId,
      type: data.type.present ? data.type.value : this.type,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaRow(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('dayId: $dayId, ')
          ..write('activityBlockId: $activityBlockId, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('takenAt: $takenAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    dayId,
    activityBlockId,
    type,
    filePath,
    takenAt,
    durationMs,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaRow &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.dayId == this.dayId &&
          other.activityBlockId == this.activityBlockId &&
          other.type == this.type &&
          other.filePath == this.filePath &&
          other.takenAt == this.takenAt &&
          other.durationMs == this.durationMs &&
          other.sortOrder == this.sortOrder);
}

class MediaItemsCompanion extends UpdateCompanion<MediaRow> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String?> dayId;
  final Value<String?> activityBlockId;
  final Value<String> type;
  final Value<String> filePath;
  final Value<int> takenAt;
  final Value<int?> durationMs;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const MediaItemsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.dayId = const Value.absent(),
    this.activityBlockId = const Value.absent(),
    this.type = const Value.absent(),
    this.filePath = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaItemsCompanion.insert({
    required String id,
    required String tripId,
    this.dayId = const Value.absent(),
    this.activityBlockId = const Value.absent(),
    required String type,
    required String filePath,
    required int takenAt,
    this.durationMs = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       type = Value(type),
       filePath = Value(filePath),
       takenAt = Value(takenAt);
  static Insertable<MediaRow> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? dayId,
    Expression<String>? activityBlockId,
    Expression<String>? type,
    Expression<String>? filePath,
    Expression<int>? takenAt,
    Expression<int>? durationMs,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (dayId != null) 'day_id': dayId,
      if (activityBlockId != null) 'activity_block_id': activityBlockId,
      if (type != null) 'type': type,
      if (filePath != null) 'file_path': filePath,
      if (takenAt != null) 'taken_at': takenAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String?>? dayId,
    Value<String?>? activityBlockId,
    Value<String>? type,
    Value<String>? filePath,
    Value<int>? takenAt,
    Value<int?>? durationMs,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return MediaItemsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      dayId: dayId ?? this.dayId,
      activityBlockId: activityBlockId ?? this.activityBlockId,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      takenAt: takenAt ?? this.takenAt,
      durationMs: durationMs ?? this.durationMs,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (activityBlockId.present) {
      map['activity_block_id'] = Variable<String>(activityBlockId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<int>(takenAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaItemsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('dayId: $dayId, ')
          ..write('activityBlockId: $activityBlockId, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('takenAt: $takenAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, PlaylistRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('spotify'),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deepLinkMeta = const VerificationMeta(
    'deepLink',
  );
  @override
  late final GeneratedColumn<String> deepLink = GeneratedColumn<String>(
    'deep_link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    source,
    externalId,
    name,
    coverUrl,
    country,
    deepLink,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    } else if (isInserting) {
      context.missing(_countryMeta);
    }
    if (data.containsKey('deep_link')) {
      context.handle(
        _deepLinkMeta,
        deepLink.isAcceptableOrUnknown(data['deep_link']!, _deepLinkMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      deepLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deep_link'],
      ),
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class PlaylistRow extends DataClass implements Insertable<PlaylistRow> {
  final String id;
  final String? tripId;
  final String source;
  final String externalId;
  final String name;
  final String? coverUrl;
  final String country;
  final String? deepLink;
  const PlaylistRow({
    required this.id,
    this.tripId,
    required this.source,
    required this.externalId,
    required this.name,
    this.coverUrl,
    required this.country,
    this.deepLink,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || tripId != null) {
      map['trip_id'] = Variable<String>(tripId);
    }
    map['source'] = Variable<String>(source);
    map['external_id'] = Variable<String>(externalId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    map['country'] = Variable<String>(country);
    if (!nullToAbsent || deepLink != null) {
      map['deep_link'] = Variable<String>(deepLink);
    }
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      tripId: tripId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripId),
      source: Value(source),
      externalId: Value(externalId),
      name: Value(name),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      country: Value(country),
      deepLink: deepLink == null && nullToAbsent
          ? const Value.absent()
          : Value(deepLink),
    );
  }

  factory PlaylistRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistRow(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String?>(json['tripId']),
      source: serializer.fromJson<String>(json['source']),
      externalId: serializer.fromJson<String>(json['externalId']),
      name: serializer.fromJson<String>(json['name']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      country: serializer.fromJson<String>(json['country']),
      deepLink: serializer.fromJson<String?>(json['deepLink']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String?>(tripId),
      'source': serializer.toJson<String>(source),
      'externalId': serializer.toJson<String>(externalId),
      'name': serializer.toJson<String>(name),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'country': serializer.toJson<String>(country),
      'deepLink': serializer.toJson<String?>(deepLink),
    };
  }

  PlaylistRow copyWith({
    String? id,
    Value<String?> tripId = const Value.absent(),
    String? source,
    String? externalId,
    String? name,
    Value<String?> coverUrl = const Value.absent(),
    String? country,
    Value<String?> deepLink = const Value.absent(),
  }) => PlaylistRow(
    id: id ?? this.id,
    tripId: tripId.present ? tripId.value : this.tripId,
    source: source ?? this.source,
    externalId: externalId ?? this.externalId,
    name: name ?? this.name,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    country: country ?? this.country,
    deepLink: deepLink.present ? deepLink.value : this.deepLink,
  );
  PlaylistRow copyWithCompanion(PlaylistsCompanion data) {
    return PlaylistRow(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      source: data.source.present ? data.source.value : this.source,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      name: data.name.present ? data.name.value : this.name,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      country: data.country.present ? data.country.value : this.country,
      deepLink: data.deepLink.present ? data.deepLink.value : this.deepLink,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistRow(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('country: $country, ')
          ..write('deepLink: $deepLink')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    source,
    externalId,
    name,
    coverUrl,
    country,
    deepLink,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistRow &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.source == this.source &&
          other.externalId == this.externalId &&
          other.name == this.name &&
          other.coverUrl == this.coverUrl &&
          other.country == this.country &&
          other.deepLink == this.deepLink);
}

class PlaylistsCompanion extends UpdateCompanion<PlaylistRow> {
  final Value<String> id;
  final Value<String?> tripId;
  final Value<String> source;
  final Value<String> externalId;
  final Value<String> name;
  final Value<String?> coverUrl;
  final Value<String> country;
  final Value<String?> deepLink;
  final Value<int> rowid;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.name = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.country = const Value.absent(),
    this.deepLink = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    required String id,
    this.tripId = const Value.absent(),
    this.source = const Value.absent(),
    required String externalId,
    required String name,
    this.coverUrl = const Value.absent(),
    required String country,
    this.deepLink = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       externalId = Value(externalId),
       name = Value(name),
       country = Value(country);
  static Insertable<PlaylistRow> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? source,
    Expression<String>? externalId,
    Expression<String>? name,
    Expression<String>? coverUrl,
    Expression<String>? country,
    Expression<String>? deepLink,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (name != null) 'name': name,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (country != null) 'country': country,
      if (deepLink != null) 'deep_link': deepLink,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistsCompanion copyWith({
    Value<String>? id,
    Value<String?>? tripId,
    Value<String>? source,
    Value<String>? externalId,
    Value<String>? name,
    Value<String?>? coverUrl,
    Value<String>? country,
    Value<String?>? deepLink,
    Value<int>? rowid,
  }) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
      country: country ?? this.country,
      deepLink: deepLink ?? this.deepLink,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (deepLink.present) {
      map['deep_link'] = Variable<String>(deepLink.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('country: $country, ')
          ..write('deepLink: $deepLink, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTracksTable extends PlaylistTracks
    with TableInfo<$PlaylistTracksTable, PlaylistTrackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previewUrlMeta = const VerificationMeta(
    'previewUrl',
  );
  @override
  late final GeneratedColumn<String> previewUrl = GeneratedColumn<String>(
    'preview_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumArtUrlMeta = const VerificationMeta(
    'albumArtUrl',
  );
  @override
  late final GeneratedColumn<String> albumArtUrl = GeneratedColumn<String>(
    'album_art_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    playlistId,
    externalId,
    name,
    artist,
    previewUrl,
    albumArtUrl,
    durationMs,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistTrackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('preview_url')) {
      context.handle(
        _previewUrlMeta,
        previewUrl.isAcceptableOrUnknown(data['preview_url']!, _previewUrlMeta),
      );
    }
    if (data.containsKey('album_art_url')) {
      context.handle(
        _albumArtUrlMeta,
        albumArtUrl.isAcceptableOrUnknown(
          data['album_art_url']!,
          _albumArtUrlMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistTrackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistTrackRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}playlist_id'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      )!,
      previewUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preview_url'],
      ),
      albumArtUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_art_url'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $PlaylistTracksTable createAlias(String alias) {
    return $PlaylistTracksTable(attachedDatabase, alias);
  }
}

class PlaylistTrackRow extends DataClass
    implements Insertable<PlaylistTrackRow> {
  final String id;
  final String playlistId;
  final String externalId;
  final String name;
  final String artist;
  final String? previewUrl;
  final String? albumArtUrl;
  final int? durationMs;
  final int sortOrder;
  const PlaylistTrackRow({
    required this.id,
    required this.playlistId,
    required this.externalId,
    required this.name,
    required this.artist,
    this.previewUrl,
    this.albumArtUrl,
    this.durationMs,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['playlist_id'] = Variable<String>(playlistId);
    map['external_id'] = Variable<String>(externalId);
    map['name'] = Variable<String>(name);
    map['artist'] = Variable<String>(artist);
    if (!nullToAbsent || previewUrl != null) {
      map['preview_url'] = Variable<String>(previewUrl);
    }
    if (!nullToAbsent || albumArtUrl != null) {
      map['album_art_url'] = Variable<String>(albumArtUrl);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  PlaylistTracksCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTracksCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      externalId: Value(externalId),
      name: Value(name),
      artist: Value(artist),
      previewUrl: previewUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(previewUrl),
      albumArtUrl: albumArtUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(albumArtUrl),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      sortOrder: Value(sortOrder),
    );
  }

  factory PlaylistTrackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistTrackRow(
      id: serializer.fromJson<String>(json['id']),
      playlistId: serializer.fromJson<String>(json['playlistId']),
      externalId: serializer.fromJson<String>(json['externalId']),
      name: serializer.fromJson<String>(json['name']),
      artist: serializer.fromJson<String>(json['artist']),
      previewUrl: serializer.fromJson<String?>(json['previewUrl']),
      albumArtUrl: serializer.fromJson<String?>(json['albumArtUrl']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'playlistId': serializer.toJson<String>(playlistId),
      'externalId': serializer.toJson<String>(externalId),
      'name': serializer.toJson<String>(name),
      'artist': serializer.toJson<String>(artist),
      'previewUrl': serializer.toJson<String?>(previewUrl),
      'albumArtUrl': serializer.toJson<String?>(albumArtUrl),
      'durationMs': serializer.toJson<int?>(durationMs),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  PlaylistTrackRow copyWith({
    String? id,
    String? playlistId,
    String? externalId,
    String? name,
    String? artist,
    Value<String?> previewUrl = const Value.absent(),
    Value<String?> albumArtUrl = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    int? sortOrder,
  }) => PlaylistTrackRow(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    externalId: externalId ?? this.externalId,
    name: name ?? this.name,
    artist: artist ?? this.artist,
    previewUrl: previewUrl.present ? previewUrl.value : this.previewUrl,
    albumArtUrl: albumArtUrl.present ? albumArtUrl.value : this.albumArtUrl,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  PlaylistTrackRow copyWithCompanion(PlaylistTracksCompanion data) {
    return PlaylistTrackRow(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      name: data.name.present ? data.name.value : this.name,
      artist: data.artist.present ? data.artist.value : this.artist,
      previewUrl: data.previewUrl.present
          ? data.previewUrl.value
          : this.previewUrl,
      albumArtUrl: data.albumArtUrl.present
          ? data.albumArtUrl.value
          : this.albumArtUrl,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTrackRow(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('artist: $artist, ')
          ..write('previewUrl: $previewUrl, ')
          ..write('albumArtUrl: $albumArtUrl, ')
          ..write('durationMs: $durationMs, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    playlistId,
    externalId,
    name,
    artist,
    previewUrl,
    albumArtUrl,
    durationMs,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistTrackRow &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.externalId == this.externalId &&
          other.name == this.name &&
          other.artist == this.artist &&
          other.previewUrl == this.previewUrl &&
          other.albumArtUrl == this.albumArtUrl &&
          other.durationMs == this.durationMs &&
          other.sortOrder == this.sortOrder);
}

class PlaylistTracksCompanion extends UpdateCompanion<PlaylistTrackRow> {
  final Value<String> id;
  final Value<String> playlistId;
  final Value<String> externalId;
  final Value<String> name;
  final Value<String> artist;
  final Value<String?> previewUrl;
  final Value<String?> albumArtUrl;
  final Value<int?> durationMs;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const PlaylistTracksCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.name = const Value.absent(),
    this.artist = const Value.absent(),
    this.previewUrl = const Value.absent(),
    this.albumArtUrl = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistTracksCompanion.insert({
    required String id,
    required String playlistId,
    required String externalId,
    required String name,
    required String artist,
    this.previewUrl = const Value.absent(),
    this.albumArtUrl = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       playlistId = Value(playlistId),
       externalId = Value(externalId),
       name = Value(name),
       artist = Value(artist);
  static Insertable<PlaylistTrackRow> custom({
    Expression<String>? id,
    Expression<String>? playlistId,
    Expression<String>? externalId,
    Expression<String>? name,
    Expression<String>? artist,
    Expression<String>? previewUrl,
    Expression<String>? albumArtUrl,
    Expression<int>? durationMs,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (externalId != null) 'external_id': externalId,
      if (name != null) 'name': name,
      if (artist != null) 'artist': artist,
      if (previewUrl != null) 'preview_url': previewUrl,
      if (albumArtUrl != null) 'album_art_url': albumArtUrl,
      if (durationMs != null) 'duration_ms': durationMs,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistTracksCompanion copyWith({
    Value<String>? id,
    Value<String>? playlistId,
    Value<String>? externalId,
    Value<String>? name,
    Value<String>? artist,
    Value<String?>? previewUrl,
    Value<String?>? albumArtUrl,
    Value<int?>? durationMs,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return PlaylistTracksCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      previewUrl: previewUrl ?? this.previewUrl,
      albumArtUrl: albumArtUrl ?? this.albumArtUrl,
      durationMs: durationMs ?? this.durationMs,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (previewUrl.present) {
      map['preview_url'] = Variable<String>(previewUrl.value);
    }
    if (albumArtUrl.present) {
      map['album_art_url'] = Variable<String>(albumArtUrl.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTracksCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('artist: $artist, ')
          ..write('previewUrl: $previewUrl, ')
          ..write('albumArtUrl: $albumArtUrl, ')
          ..write('durationMs: $durationMs, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $DaysTable days = $DaysTable(this);
  late final $ActivityBlocksTable activityBlocks = $ActivityBlocksTable(this);
  late final $MediaItemsTable mediaItems = $MediaItemsTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistTracksTable playlistTracks = $PlaylistTracksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trips,
    days,
    activityBlocks,
    mediaItems,
    playlists,
    playlistTracks,
  ];
}

typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      required String id,
      required String name,
      Value<String> countriesJson,
      Value<String> citiesJson,
      required int startDate,
      required int endDate,
      Value<String> status,
      Value<String?> coverMediaId,
      Value<String?> selectedPlaylistId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> countriesJson,
      Value<String> citiesJson,
      Value<int> startDate,
      Value<int> endDate,
      Value<String> status,
      Value<String?> coverMediaId,
      Value<String?> selectedPlaylistId,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countriesJson => $composableBuilder(
    column: $table.countriesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get citiesJson => $composableBuilder(
    column: $table.citiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverMediaId => $composableBuilder(
    column: $table.coverMediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedPlaylistId => $composableBuilder(
    column: $table.selectedPlaylistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countriesJson => $composableBuilder(
    column: $table.countriesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citiesJson => $composableBuilder(
    column: $table.citiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverMediaId => $composableBuilder(
    column: $table.coverMediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedPlaylistId => $composableBuilder(
    column: $table.selectedPlaylistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get countriesJson => $composableBuilder(
    column: $table.countriesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get citiesJson => $composableBuilder(
    column: $table.citiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get coverMediaId => $composableBuilder(
    column: $table.coverMediaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedPlaylistId => $composableBuilder(
    column: $table.selectedPlaylistId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          TripRow,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (TripRow, BaseReferences<_$AppDatabase, $TripsTable, TripRow>),
          TripRow,
          PrefetchHooks Function()
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> countriesJson = const Value.absent(),
                Value<String> citiesJson = const Value.absent(),
                Value<int> startDate = const Value.absent(),
                Value<int> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> coverMediaId = const Value.absent(),
                Value<String?> selectedPlaylistId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                name: name,
                countriesJson: countriesJson,
                citiesJson: citiesJson,
                startDate: startDate,
                endDate: endDate,
                status: status,
                coverMediaId: coverMediaId,
                selectedPlaylistId: selectedPlaylistId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> countriesJson = const Value.absent(),
                Value<String> citiesJson = const Value.absent(),
                required int startDate,
                required int endDate,
                Value<String> status = const Value.absent(),
                Value<String?> coverMediaId = const Value.absent(),
                Value<String?> selectedPlaylistId = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                name: name,
                countriesJson: countriesJson,
                citiesJson: citiesJson,
                startDate: startDate,
                endDate: endDate,
                status: status,
                coverMediaId: coverMediaId,
                selectedPlaylistId: selectedPlaylistId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      TripRow,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (TripRow, BaseReferences<_$AppDatabase, $TripsTable, TripRow>),
      TripRow,
      PrefetchHooks Function()
    >;
typedef $$DaysTableCreateCompanionBuilder =
    DaysCompanion Function({
      required String id,
      required String tripId,
      required int date,
      Value<String?> journalNote,
      Value<String?> audioJournalMediaId,
      Value<int> rowid,
    });
typedef $$DaysTableUpdateCompanionBuilder =
    DaysCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<int> date,
      Value<String?> journalNote,
      Value<String?> audioJournalMediaId,
      Value<int> rowid,
    });

class $$DaysTableFilterComposer extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get journalNote => $composableBuilder(
    column: $table.journalNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioJournalMediaId => $composableBuilder(
    column: $table.audioJournalMediaId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DaysTableOrderingComposer extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journalNote => $composableBuilder(
    column: $table.journalNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioJournalMediaId => $composableBuilder(
    column: $table.audioJournalMediaId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get journalNote => $composableBuilder(
    column: $table.journalNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioJournalMediaId => $composableBuilder(
    column: $table.audioJournalMediaId,
    builder: (column) => column,
  );
}

class $$DaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DaysTable,
          DayRow,
          $$DaysTableFilterComposer,
          $$DaysTableOrderingComposer,
          $$DaysTableAnnotationComposer,
          $$DaysTableCreateCompanionBuilder,
          $$DaysTableUpdateCompanionBuilder,
          (DayRow, BaseReferences<_$AppDatabase, $DaysTable, DayRow>),
          DayRow,
          PrefetchHooks Function()
        > {
  $$DaysTableTableManager(_$AppDatabase db, $DaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String?> journalNote = const Value.absent(),
                Value<String?> audioJournalMediaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DaysCompanion(
                id: id,
                tripId: tripId,
                date: date,
                journalNote: journalNote,
                audioJournalMediaId: audioJournalMediaId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required int date,
                Value<String?> journalNote = const Value.absent(),
                Value<String?> audioJournalMediaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DaysCompanion.insert(
                id: id,
                tripId: tripId,
                date: date,
                journalNote: journalNote,
                audioJournalMediaId: audioJournalMediaId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DaysTable,
      DayRow,
      $$DaysTableFilterComposer,
      $$DaysTableOrderingComposer,
      $$DaysTableAnnotationComposer,
      $$DaysTableCreateCompanionBuilder,
      $$DaysTableUpdateCompanionBuilder,
      (DayRow, BaseReferences<_$AppDatabase, $DaysTable, DayRow>),
      DayRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityBlocksTableCreateCompanionBuilder =
    ActivityBlocksCompanion Function({
      required String id,
      required String dayId,
      required int startMinutes,
      required int endMinutes,
      required String title,
      Value<String?> locationText,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$ActivityBlocksTableUpdateCompanionBuilder =
    ActivityBlocksCompanion Function({
      Value<String> id,
      Value<String> dayId,
      Value<int> startMinutes,
      Value<int> endMinutes,
      Value<String> title,
      Value<String?> locationText,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$ActivityBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityBlocksTable> {
  $$ActivityBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationText => $composableBuilder(
    column: $table.locationText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityBlocksTable> {
  $$ActivityBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationText => $composableBuilder(
    column: $table.locationText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityBlocksTable> {
  $$ActivityBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get locationText => $composableBuilder(
    column: $table.locationText,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ActivityBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityBlocksTable,
          ActivityBlockRow,
          $$ActivityBlocksTableFilterComposer,
          $$ActivityBlocksTableOrderingComposer,
          $$ActivityBlocksTableAnnotationComposer,
          $$ActivityBlocksTableCreateCompanionBuilder,
          $$ActivityBlocksTableUpdateCompanionBuilder,
          (
            ActivityBlockRow,
            BaseReferences<
              _$AppDatabase,
              $ActivityBlocksTable,
              ActivityBlockRow
            >,
          ),
          ActivityBlockRow,
          PrefetchHooks Function()
        > {
  $$ActivityBlocksTableTableManager(
    _$AppDatabase db,
    $ActivityBlocksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> locationText = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityBlocksCompanion(
                id: id,
                dayId: dayId,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                title: title,
                locationText: locationText,
                latitude: latitude,
                longitude: longitude,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dayId,
                required int startMinutes,
                required int endMinutes,
                required String title,
                Value<String?> locationText = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityBlocksCompanion.insert(
                id: id,
                dayId: dayId,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                title: title,
                locationText: locationText,
                latitude: latitude,
                longitude: longitude,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityBlocksTable,
      ActivityBlockRow,
      $$ActivityBlocksTableFilterComposer,
      $$ActivityBlocksTableOrderingComposer,
      $$ActivityBlocksTableAnnotationComposer,
      $$ActivityBlocksTableCreateCompanionBuilder,
      $$ActivityBlocksTableUpdateCompanionBuilder,
      (
        ActivityBlockRow,
        BaseReferences<_$AppDatabase, $ActivityBlocksTable, ActivityBlockRow>,
      ),
      ActivityBlockRow,
      PrefetchHooks Function()
    >;
typedef $$MediaItemsTableCreateCompanionBuilder =
    MediaItemsCompanion Function({
      required String id,
      required String tripId,
      Value<String?> dayId,
      Value<String?> activityBlockId,
      required String type,
      required String filePath,
      required int takenAt,
      Value<int?> durationMs,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$MediaItemsTableUpdateCompanionBuilder =
    MediaItemsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String?> dayId,
      Value<String?> activityBlockId,
      Value<String> type,
      Value<String> filePath,
      Value<int> takenAt,
      Value<int?> durationMs,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$MediaItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaItemsTable> {
  $$MediaItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityBlockId => $composableBuilder(
    column: $table.activityBlockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaItemsTable> {
  $$MediaItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityBlockId => $composableBuilder(
    column: $table.activityBlockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaItemsTable> {
  $$MediaItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<String> get activityBlockId => $composableBuilder(
    column: $table.activityBlockId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$MediaItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaItemsTable,
          MediaRow,
          $$MediaItemsTableFilterComposer,
          $$MediaItemsTableOrderingComposer,
          $$MediaItemsTableAnnotationComposer,
          $$MediaItemsTableCreateCompanionBuilder,
          $$MediaItemsTableUpdateCompanionBuilder,
          (MediaRow, BaseReferences<_$AppDatabase, $MediaItemsTable, MediaRow>),
          MediaRow,
          PrefetchHooks Function()
        > {
  $$MediaItemsTableTableManager(_$AppDatabase db, $MediaItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String?> dayId = const Value.absent(),
                Value<String?> activityBlockId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int> takenAt = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaItemsCompanion(
                id: id,
                tripId: tripId,
                dayId: dayId,
                activityBlockId: activityBlockId,
                type: type,
                filePath: filePath,
                takenAt: takenAt,
                durationMs: durationMs,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                Value<String?> dayId = const Value.absent(),
                Value<String?> activityBlockId = const Value.absent(),
                required String type,
                required String filePath,
                required int takenAt,
                Value<int?> durationMs = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaItemsCompanion.insert(
                id: id,
                tripId: tripId,
                dayId: dayId,
                activityBlockId: activityBlockId,
                type: type,
                filePath: filePath,
                takenAt: takenAt,
                durationMs: durationMs,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaItemsTable,
      MediaRow,
      $$MediaItemsTableFilterComposer,
      $$MediaItemsTableOrderingComposer,
      $$MediaItemsTableAnnotationComposer,
      $$MediaItemsTableCreateCompanionBuilder,
      $$MediaItemsTableUpdateCompanionBuilder,
      (MediaRow, BaseReferences<_$AppDatabase, $MediaItemsTable, MediaRow>),
      MediaRow,
      PrefetchHooks Function()
    >;
typedef $$PlaylistsTableCreateCompanionBuilder =
    PlaylistsCompanion Function({
      required String id,
      Value<String?> tripId,
      Value<String> source,
      required String externalId,
      required String name,
      Value<String?> coverUrl,
      required String country,
      Value<String?> deepLink,
      Value<int> rowid,
    });
typedef $$PlaylistsTableUpdateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<String> id,
      Value<String?> tripId,
      Value<String> source,
      Value<String> externalId,
      Value<String> name,
      Value<String?> coverUrl,
      Value<String> country,
      Value<String?> deepLink,
      Value<int> rowid,
    });

class $$PlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deepLink => $composableBuilder(
    column: $table.deepLink,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deepLink => $composableBuilder(
    column: $table.deepLink,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get deepLink =>
      $composableBuilder(column: $table.deepLink, builder: (column) => column);
}

class $$PlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistsTable,
          PlaylistRow,
          $$PlaylistsTableFilterComposer,
          $$PlaylistsTableOrderingComposer,
          $$PlaylistsTableAnnotationComposer,
          $$PlaylistsTableCreateCompanionBuilder,
          $$PlaylistsTableUpdateCompanionBuilder,
          (
            PlaylistRow,
            BaseReferences<_$AppDatabase, $PlaylistsTable, PlaylistRow>,
          ),
          PlaylistRow,
          PrefetchHooks Function()
        > {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> tripId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String?> deepLink = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistsCompanion(
                id: id,
                tripId: tripId,
                source: source,
                externalId: externalId,
                name: name,
                coverUrl: coverUrl,
                country: country,
                deepLink: deepLink,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> tripId = const Value.absent(),
                Value<String> source = const Value.absent(),
                required String externalId,
                required String name,
                Value<String?> coverUrl = const Value.absent(),
                required String country,
                Value<String?> deepLink = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistsCompanion.insert(
                id: id,
                tripId: tripId,
                source: source,
                externalId: externalId,
                name: name,
                coverUrl: coverUrl,
                country: country,
                deepLink: deepLink,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistsTable,
      PlaylistRow,
      $$PlaylistsTableFilterComposer,
      $$PlaylistsTableOrderingComposer,
      $$PlaylistsTableAnnotationComposer,
      $$PlaylistsTableCreateCompanionBuilder,
      $$PlaylistsTableUpdateCompanionBuilder,
      (
        PlaylistRow,
        BaseReferences<_$AppDatabase, $PlaylistsTable, PlaylistRow>,
      ),
      PlaylistRow,
      PrefetchHooks Function()
    >;
typedef $$PlaylistTracksTableCreateCompanionBuilder =
    PlaylistTracksCompanion Function({
      required String id,
      required String playlistId,
      required String externalId,
      required String name,
      required String artist,
      Value<String?> previewUrl,
      Value<String?> albumArtUrl,
      Value<int?> durationMs,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$PlaylistTracksTableUpdateCompanionBuilder =
    PlaylistTracksCompanion Function({
      Value<String> id,
      Value<String> playlistId,
      Value<String> externalId,
      Value<String> name,
      Value<String> artist,
      Value<String?> previewUrl,
      Value<String?> albumArtUrl,
      Value<int?> durationMs,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$PlaylistTracksTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previewUrl => $composableBuilder(
    column: $table.previewUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumArtUrl => $composableBuilder(
    column: $table.albumArtUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaylistTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previewUrl => $composableBuilder(
    column: $table.previewUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumArtUrl => $composableBuilder(
    column: $table.albumArtUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get previewUrl => $composableBuilder(
    column: $table.previewUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumArtUrl => $composableBuilder(
    column: $table.albumArtUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$PlaylistTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistTracksTable,
          PlaylistTrackRow,
          $$PlaylistTracksTableFilterComposer,
          $$PlaylistTracksTableOrderingComposer,
          $$PlaylistTracksTableAnnotationComposer,
          $$PlaylistTracksTableCreateCompanionBuilder,
          $$PlaylistTracksTableUpdateCompanionBuilder,
          (
            PlaylistTrackRow,
            BaseReferences<
              _$AppDatabase,
              $PlaylistTracksTable,
              PlaylistTrackRow
            >,
          ),
          PlaylistTrackRow,
          PrefetchHooks Function()
        > {
  $$PlaylistTracksTableTableManager(
    _$AppDatabase db,
    $PlaylistTracksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> playlistId = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<String?> previewUrl = const Value.absent(),
                Value<String?> albumArtUrl = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistTracksCompanion(
                id: id,
                playlistId: playlistId,
                externalId: externalId,
                name: name,
                artist: artist,
                previewUrl: previewUrl,
                albumArtUrl: albumArtUrl,
                durationMs: durationMs,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String playlistId,
                required String externalId,
                required String name,
                required String artist,
                Value<String?> previewUrl = const Value.absent(),
                Value<String?> albumArtUrl = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistTracksCompanion.insert(
                id: id,
                playlistId: playlistId,
                externalId: externalId,
                name: name,
                artist: artist,
                previewUrl: previewUrl,
                albumArtUrl: albumArtUrl,
                durationMs: durationMs,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaylistTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistTracksTable,
      PlaylistTrackRow,
      $$PlaylistTracksTableFilterComposer,
      $$PlaylistTracksTableOrderingComposer,
      $$PlaylistTracksTableAnnotationComposer,
      $$PlaylistTracksTableCreateCompanionBuilder,
      $$PlaylistTracksTableUpdateCompanionBuilder,
      (
        PlaylistTrackRow,
        BaseReferences<_$AppDatabase, $PlaylistTracksTable, PlaylistTrackRow>,
      ),
      PlaylistTrackRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$DaysTableTableManager get days => $$DaysTableTableManager(_db, _db.days);
  $$ActivityBlocksTableTableManager get activityBlocks =>
      $$ActivityBlocksTableTableManager(_db, _db.activityBlocks);
  $$MediaItemsTableTableManager get mediaItems =>
      $$MediaItemsTableTableManager(_db, _db.mediaItems);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistTracksTableTableManager get playlistTracks =>
      $$PlaylistTracksTableTableManager(_db, _db.playlistTracks);
}
