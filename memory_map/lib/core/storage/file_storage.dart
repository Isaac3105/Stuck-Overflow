import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileStorage {
  FileStorage();
  static const _uuid = Uuid();

  Future<Directory> _tripDir(String tripId, String kind) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'trips', tripId, kind));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> savePhoto(String tripId, File source) async {
    final dir = await _tripDir(tripId, 'photos');
    final ext = p.extension(source.path).isEmpty
        ? '.jpg'
        : p.extension(source.path);
    final dest = File(p.join(dir.path, '${_uuid.v4()}$ext'));
    return source.copy(dest.path);
  }

  Future<File> saveVideo(String tripId, File source) async {
    final dir = await _tripDir(tripId, 'videos');
    final ext = p.extension(source.path).isEmpty ? '.mp4' : p.extension(source.path);
    final dest = File(p.join(dir.path, '${_uuid.v4()}$ext'));
    return source.copy(dest.path);
  }

  Future<String> reserveAudioPath(String tripId, {String ext = '.m4a'}) async {
    final dir = await _tripDir(tripId, 'audio');
    return p.join(dir.path, '${_uuid.v4()}$ext');
  }

  Future<void> deleteFile(String path) async {
    final f = File(path);
    if (await f.exists()) {
      try {
        await f.delete();
      } catch (_) {/* ignore */}
    }
  }
}

final fileStorageProvider = Provider<FileStorage>((_) => FileStorage());
