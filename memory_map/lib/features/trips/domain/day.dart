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
  });

  final String id;
  final String tripId;
  final DateTime date;
  final String? journalNote;
  final String? audioJournalMediaId;
  final String? coverMediaId;

  TripDay copyWith({
    String? journalNote,
    String? audioJournalMediaId,
    String? coverMediaId,
    bool clearAudioJournal = false,
    bool clearCoverMedia = false,
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
    );
  }
}
