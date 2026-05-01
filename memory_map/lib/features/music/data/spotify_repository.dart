import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/data/countries.dart';
import '../../../core/services/spotify_service.dart';

class SpotifyRepository {
  SpotifyRepository(this._db, this._service);
  final AppDatabase _db;
  final SpotifyService _service;
  static const _uuid = Uuid();

  List<String> _buildSuggestionQueries({
    required String countryCode,
  }) {
    final c = countryByCode(countryCode);
    final namePt = c?.namePt ?? countryCode;
    final nameEn = c?.nameEn ?? countryCode;

    // Mix PT + EN terms; keep queries short for better Spotify search relevance.
    // Intentionally biased toward "local" / region-specific playlists.
    final seeds = <String>[
      namePt,
      if (nameEn != namePt) nameEn,
    ];

    final suffixes = <String>[
      'músicas locais',
      'música local',
      'música tradicional',
      'música popular',
      'hits',
      'top hits',
      'local music',
      'traditional music',
      'folk',
      'hits playlist',
      'top hits playlist',
    ];

    final queries = <String>[];
    for (final s in seeds) {
      for (final suf in suffixes) {
        queries.add('$s $suf');
      }
    }
    // Backward compatible fallback for short lists / unknown codes.
    queries.add('$countryCode local playlist');

    // De-dupe while preserving order.
    final seen = <String>{};
    return queries.where(seen.add).toList(growable: false);
  }

  Future<List<SpotifyPlaylist>> suggestPlaylists({
    required String countryCode,
    int limit = 3,
  }) async {
    // Run multiple queries, then de-dup by Spotify playlist id.
    final queries = _buildSuggestionQueries(countryCode: countryCode);
    final byId = <String, SpotifyPlaylist>{};

    for (final q in queries) {
      final results = await _service.searchPlaylists(query: q, limit: 8);
      for (final p in results) {
        byId.putIfAbsent(p.id, () => p);
      }
      if (byId.length >= limit) break;
    }

    return byId.values.take(limit).toList(growable: false);
  }

  /// Stores the selected playlist and associates it with the trip.
  Future<PlaylistRow> selectPlaylistForTrip({
    required String tripId,
    required String countryCode,
    required SpotifyPlaylist playlist,
  }) async {
    return _db.transaction(() async {
      final existing = await (_db.select(_db.playlists)
            ..where((t) => t.externalId.equals(playlist.id)))
          .getSingleOrNull();
      final row = existing ??
          await (() async {
            final id = _uuid.v4();
            await _db.into(_db.playlists).insert(PlaylistsCompanion.insert(
                  id: id,
                  tripId: Value(tripId),
                  externalId: playlist.id,
                  name: playlist.name,
                  coverUrl: Value(playlist.imageUrl),
                  country: countryCode,
                  deepLink: Value(playlist.deepLink),
                ));
            return (_db.select(_db.playlists)..where((t) => t.id.equals(id)))
                .getSingle();
          })();

      await (_db.update(_db.trips)..where((t) => t.id.equals(tripId))).write(
        TripsCompanion(selectedPlaylistId: Value(row.id)),
      );
      return row;
    });
  }

  /// Searches playlists and persists results (dedup by externalId).
  Future<List<PlaylistRow>> searchAndStorePlaylists({
    required String country,
    String? tripId,
  }) async {
    final q = '$country local music';
    final results = await _service.searchPlaylists(query: q, limit: 10);
    final stored = <PlaylistRow>[];
    await _db.transaction(() async {
      for (final p in results) {
        final existing = await (_db.select(_db.playlists)
              ..where((t) => t.externalId.equals(p.id)))
            .getSingleOrNull();
        if (existing != null) {
          stored.add(existing);
          continue;
        }
        final id = _uuid.v4();
        await _db.into(_db.playlists).insert(PlaylistsCompanion.insert(
              id: id,
              tripId: Value(tripId),
              externalId: p.id,
              name: p.name,
              coverUrl: Value(p.imageUrl),
              country: country,
              deepLink: Value(p.deepLink),
            ));
        final row = await (_db.select(_db.playlists)..where((t) => t.id.equals(id)))
            .getSingle();
        stored.add(row);
      }
    });
    return stored;
  }

  /// Fetches previews and stores tracks for a playlist (replaces old tracks).
  Future<List<PlaylistTrackRow>> refreshPlaylistTracks(String playlistId) async {
    final playlist = await (_db.select(_db.playlists)
          ..where((p) => p.id.equals(playlistId)))
        .getSingle();
    final previews =
        await _service.getPlaylistTrackPreviews(playlistId: playlist.externalId);
    await _db.transaction(() async {
      await (_db.delete(_db.playlistTracks)
            ..where((t) => t.playlistId.equals(playlistId)))
          .go();
      var sort = 0;
      for (final t in previews) {
        await _db.into(_db.playlistTracks).insert(PlaylistTracksCompanion.insert(
              id: _uuid.v4(),
              playlistId: playlistId,
              externalId: t.id,
              name: t.name,
              artist: t.artist,
              previewUrl: Value(t.previewUrl),
              albumArtUrl: Value(t.albumArtUrl),
              durationMs: Value(t.durationMs),
              sortOrder: Value(sort++),
            ));
      }
    });
    return (_db.select(_db.playlistTracks)
          ..where((t) => t.playlistId.equals(playlistId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  Stream<List<PlaylistRow>> watchPlaylistsForTrip(String tripId) {
    return (_db.select(_db.playlists)
          ..where((p) => p.tripId.equals(tripId))
          ..orderBy([(p) => OrderingTerm(expression: p.name)]))
        .watch();
  }

  Stream<PlaylistRow?> watchSelectedPlaylistForTrip(String tripId) {
    final tripQ = _db.select(_db.trips)..where((t) => t.id.equals(tripId));
    return tripQ.watchSingleOrNull().switchMap((trip) {
      final pid = trip?.selectedPlaylistId;
      if (pid == null) return Stream.value(null);
      final q = _db.select(_db.playlists)..where((p) => p.id.equals(pid));
      return q.watchSingleOrNull();
    });
  }

  Stream<List<PlaylistTrackRow>> watchTracks(String playlistId) {
    return (_db.select(_db.playlistTracks)
          ..where((t) => t.playlistId.equals(playlistId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }
}

final spotifyRepositoryProvider = Provider<SpotifyRepository>((ref) {
  return SpotifyRepository(
    ref.watch(databaseProvider),
    ref.watch(spotifyServiceProvider),
  );
});

