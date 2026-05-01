import 'package:flutter/foundation.dart';

@immutable
class ActivityBlock {
  const ActivityBlock({
    required this.id,
    required this.dayId,
    required this.startMinutes,
    required this.endMinutes,
    required this.title,
    this.locationText,
    this.latitude,
    this.longitude,
    this.notes,
    this.sortOrder = 0,
  });

  final String id;
  final String dayId;

  /// Minutes from midnight.
  final int startMinutes;
  final int endMinutes;
  final String title;
  final String? locationText;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final int sortOrder;

  String get startLabel => _fmt(startMinutes);
  String get endLabel => _fmt(endMinutes);

  static String _fmt(int total) {
    final h = (total ~/ 60).toString().padLeft(2, '0');
    final m = (total % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  ActivityBlock copyWith({
    int? startMinutes,
    int? endMinutes,
    String? title,
    String? locationText,
    double? latitude,
    double? longitude,
    String? notes,
    int? sortOrder,
  }) {
    return ActivityBlock(
      id: id,
      dayId: dayId,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      title: title ?? this.title,
      locationText: locationText ?? this.locationText,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
