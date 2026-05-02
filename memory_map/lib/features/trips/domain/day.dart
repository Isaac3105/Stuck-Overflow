import 'package:flutter/foundation.dart';

@immutable
class TripDay {
  const TripDay({
    required this.id,
    required this.tripId,
    required this.date,
    this.journalNote,
    this.audioJournalMediaId,
    this.coverMediaId,
    this.dayRating,
  });

  final String id;
  final String tripId;
  final DateTime date;
  final String? journalNote;
  final String? audioJournalMediaId;
  final String? coverMediaId;
  /// 1–5 after the day is closed (midnight rule or user ends day early).
  final int? dayRating;

  TripDay copyWith({
    String? journalNote,
    String? audioJournalMediaId,
    String? coverMediaId,
    bool clearAudioJournal = false,
    bool clearCoverMedia = false,
    int? dayRating,
    bool clearDayRating = false,
  }) {
    return TripDay(
      id: id,
      tripId: tripId,
      date: date,
      journalNote: journalNote ?? this.journalNote,
      audioJournalMediaId: clearAudioJournal
          ? null
          : (audioJournalMediaId ?? this.audioJournalMediaId),
      coverMediaId: clearCoverMedia
          ? null
          : (coverMediaId ?? this.coverMediaId),
      dayRating: clearDayRating ? null : (dayRating ?? this.dayRating),
    );
  }
}
