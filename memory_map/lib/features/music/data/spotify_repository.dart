import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/services/spotify_service.dart';

class SpotifyRepository {
  SpotifyRepository(this._db, this._service);
  final AppDatabase _db;
  final SpotifyService _service;
  static const _uuid = Uuid();

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

