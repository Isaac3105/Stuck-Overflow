import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../features/trips/data/trip_providers.dart';
import '../../features/trips/domain/media.dart';
import '../storage/file_storage.dart';

class MediaCaptureService {
  MediaCaptureService(this._ref);
  final Ref _ref;
  final ImagePicker _picker = ImagePicker();

  Future<bool> ensureCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> ensureMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Takes a photo, copies it to the app's storage, and inserts a media row.
  Future<MediaItem?> capturePhoto({
    required String tripId,
    String? dayId,
    String? activityBlockId,
  }) async {
    if (!await ensureCameraPermission()) return null;
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
      maxWidth: 2400,
    );
    if (picked == null) return null;
    final stored =
        await _ref.read(fileStorageProvider).savePhoto(tripId, File(picked.path));
    return _ref.read(tripRepositoryProvider).addMedia(
          tripId: tripId,
          dayId: dayId,
          activityBlockId: activityBlockId,
          type: MediaType.photo,
          filePath: stored.path,
        );
  }

  /// Picks a photo from the gallery (no camera permission required on modern Android).
  Future<MediaItem?> pickPhotoFromGallery({
    required String tripId,
    String? dayId,
    String? activityBlockId,
  }) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 2400,
    );
    if (picked == null) return null;
    final stored =
        await _ref.read(fileStorageProvider).savePhoto(tripId, File(picked.path));
    return _ref.read(tripRepositoryProvider).addMedia(
          tripId: tripId,
          dayId: dayId,
          activityBlockId: activityBlockId,
          type: MediaType.photo,
          filePath: stored.path,
        );
  }
}

final mediaCaptureServiceProvider = Provider<MediaCaptureService>((ref) {
  return MediaCaptureService(ref);
});

/// Stateful audio recorder shared across the app.
class AudioRecorderController {
  AudioRecorderController(this._ref);
  final Ref _ref;
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;
  DateTime? _startedAt;

  Future<bool> isRecording() => _recorder.isRecording();

  Future<bool> start(String tripId) async {
    if (!await _ref.read(mediaCaptureServiceProvider).ensureMicrophonePermission()) {
      return false;
    }
    final path =
        await _ref.read(fileStorageProvider).reserveAudioPath(tripId);
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 96000),
      path: path,
    );
    _currentPath = path;
    _startedAt = DateTime.now();
    return true;
  }

  Future<MediaItem?> stop({
    required String tripId,
    String? dayId,
    String? activityBlockId,
  }) async {
    final path = await _recorder.stop();
    final usePath = path ?? _currentPath;
    final start = _startedAt;
    _currentPath = null;
    _startedAt = null;
    if (usePath == null) return null;
    final durationMs =
        start == null ? null : DateTime.now().difference(start).inMilliseconds;
    return _ref.read(tripRepositoryProvider).addMedia(
          tripId: tripId,
          dayId: dayId,
          activityBlockId: activityBlockId,
          type: MediaType.audio,
          filePath: usePath,
          durationMs: durationMs,
        );
  }

  Future<void> cancel() async {
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
    if (_currentPath != null) {
      await _ref.read(fileStorageProvider).deleteFile(_currentPath!);
    }
    _currentPath = null;
    _startedAt = null;
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}

final audioRecorderControllerProvider =
    Provider<AudioRecorderController>((ref) {
  final c = AudioRecorderController(ref);
  ref.onDispose(c.dispose);
  return c;
});
