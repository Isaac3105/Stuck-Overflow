import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import 'weather_service.dart' show dioProvider;

class SpotifyPlaylist {
  const SpotifyPlaylist({
    required this.id,
    required this.name,
    this.imageUrl,
  });
  final String id;
  final String name;
  final String? imageUrl;

  String get deepLink => 'spotify:playlist:$id';
}

class SpotifyTrackPreview {
  const SpotifyTrackPreview({
    required this.id,
    required this.name,
    required this.artist,
    required this.previewUrl,
    this.albumArtUrl,
    this.durationMs,
  });

  final String id;
  final String name;
  final String artist;
  final String previewUrl;
  final String? albumArtUrl;
  final int? durationMs;
}

class SpotifyService {
  SpotifyService(this._dio);
  final Dio _dio;

  String? _token;
  DateTime? _tokenExpiry;

  Future<String> _getToken() async {
    final now = DateTime.now();
    if (_token != null && _tokenExpiry != null && now.isBefore(_tokenExpiry!)) {
      return _token!;
    }
    final credentials =
        base64Encode(utf8.encode('${Env.spotifyClientId}:${Env.spotifyClientSecret}'));
    final r = await _dio.post<Map<String, dynamic>>(
      'https://accounts.spotify.com/api/token',
      data: 'grant_type=client_credentials',
      options: Options(
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    final data = r.data ?? const <String, dynamic>{};
    _token = data['access_token'] as String?;
    final expiresIn = (data['expires_in'] as num?)?.toInt() ?? 3600;
    // refresh a bit earlier than expiry
    _tokenExpiry = now.add(Duration(seconds: expiresIn - 60));
    return _token!;
  }

  Future<List<SpotifyPlaylist>> searchPlaylists({
    required String query,
    int limit = 10,
  }) async {
    if (!Env.hasSpotify) return const [];
    final token = await _getToken();
    final r = await _dio.get<Map<String, dynamic>>(
      'https://api.spotify.com/v1/search',
      queryParameters: {
        'q': query,
        'type': 'playlist',
        'limit': limit,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final root = r.data ?? const <String, dynamic>{};
    final playlistsNode = root['playlists'];
    final items = playlistsNode is Map<String, dynamic>
        ? (playlistsNode['items'] as List<dynamic>? ?? const [])
        : const <dynamic>[];

    // Spotify may return null items; be defensive.
    return items
        .whereType<Map<String, dynamic>>()
        .map((m) {
          final images = (m['images'] as List<dynamic>? ?? const []);
          final imageUrl = images.isEmpty
              ? null
              : (images.first is Map<String, dynamic>)
                  ? (images.first as Map<String, dynamic>)['url'] as String?
                  : null;
          final id = m['id'] as String?;
          if (id == null) return null;
          return SpotifyPlaylist(
            id: id,
            name: m['name'] as String? ?? 'Playlist',
            imageUrl: imageUrl,
          );
        })
        .whereType<SpotifyPlaylist>()
        .toList();
  }

  Future<List<SpotifyTrackPreview>> getPlaylistTrackPreviews({
    required String playlistId,
    int limit = 50,
  }) async {
    if (!Env.hasSpotify) return const [];
    final token = await _getToken();
    final r = await _dio.get<Map<String, dynamic>>(
      'https://api.spotify.com/v1/playlists/$playlistId/tracks',
      queryParameters: {'limit': limit},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final items = r.data?['items'] as List<dynamic>? ?? const [];
    final previews = <SpotifyTrackPreview>[];
    for (final it in items) {
      final track = (it as Map<String, dynamic>)['track'] as Map<String, dynamic>?;
      if (track == null) continue;
      final previewUrl = track['preview_url'] as String?;
      if (previewUrl == null) continue;
      final artists = (track['artists'] as List<dynamic>? ?? const []);
      final artist = artists.isEmpty
          ? '—'
          : (artists.first as Map<String, dynamic>)['name'] as String? ?? '—';
      final album = track['album'] as Map<String, dynamic>?;
      final images = (album?['images'] as List<dynamic>? ?? const []);
      final art = images.isEmpty
          ? null
          : (images.last as Map<String, dynamic>)['url'] as String?;
      previews.add(
        SpotifyTrackPreview(
          id: track['id'] as String? ?? '${track['uri']}',
          name: track['name'] as String? ?? 'Faixa',
          artist: artist,
          previewUrl: previewUrl,
          albumArtUrl: art,
          durationMs: (track['duration_ms'] as num?)?.toInt(),
        ),
      );
    }
    return previews;
  }
}

final spotifyServiceProvider = Provider<SpotifyService>((ref) {
  return SpotifyService(ref.watch(dioProvider));
});

