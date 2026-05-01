import 'package:flutter/foundation.dart';

enum TripStatus { planning, active, completed }

@immutable
class Trip {
  const Trip({
    required this.id,
    required this.name,
    required this.countries,
    required this.cities,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.coverMediaId,
    this.selectedPlaylistId,
    this.averageDayRating,
    required this.createdAt,
  });

  final String id;
  final String name;
  final List<String> countries;
  final List<String> cities;
  final DateTime startDate;
  final DateTime endDate;
  final TripStatus status;
  final String? coverMediaId;
  final String? selectedPlaylistId;
  /// Mean of [1..5] day ratings when every trip day has been rated; otherwise null.
  final double? averageDayRating;
  final DateTime createdAt;

  Trip copyWith({
    String? name,
    List<String>? countries,
    List<String>? cities,
    DateTime? startDate,
    DateTime? endDate,
    TripStatus? status,
    String? coverMediaId,
    String? selectedPlaylistId,
    bool clearSelectedPlaylist = false,
    double? averageDayRating,
    bool clearAverageDayRating = false,
  }) {
    return Trip(
      id: id,
      name: name ?? this.name,
      countries: countries ?? this.countries,
      cities: cities ?? this.cities,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      coverMediaId: coverMediaId ?? this.coverMediaId,
      selectedPlaylistId: clearSelectedPlaylist
          ? null
          : (selectedPlaylistId ?? this.selectedPlaylistId),
      averageDayRating: clearAverageDayRating
          ? null
          : (averageDayRating ?? this.averageDayRating),
      createdAt: createdAt,
    );
  }

  /// Resolved status considering current date.
  TripStatus resolvedStatus(DateTime now) {
    if (status == TripStatus.completed) return TripStatus.completed;
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    if (today.isBefore(start)) return TripStatus.planning;
    if (today.isAfter(end)) return TripStatus.completed;
    return TripStatus.active;
  }

  int get totalDays => endDate.difference(startDate).inDays + 1;
}
