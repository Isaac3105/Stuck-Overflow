import 'package:flutter/foundation.dart';

enum MediaType { photo, audio }

@immutable
class MediaItem {
  const MediaItem({
    required this.id,
    required this.tripId,
    this.dayId,
    this.activityBlockId,
    required this.type,
    required this.filePath,
    required this.takenAt,
    this.durationMs,
    this.sortOrder = 0,
  });

  final String id;
  final String tripId;
  final String? dayId;
  final String? activityBlockId;
  final MediaType type;
  final String filePath;
  final DateTime takenAt;
  final int? durationMs;
  final int sortOrder;
}
