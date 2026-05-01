import 'package:flutter/foundation.dart';

@immutable
class TripDay {
  const TripDay({
    required this.id,
    required this.tripId,
    required this.date,
    this.journalNote,
    this.audioJournalMediaId,
  });

  final String id;
  final String tripId;
  final DateTime date;
  final String? journalNote;
  final String? audioJournalMediaId;

  TripDay copyWith({
    String? journalNote,
    String? audioJournalMediaId,
    bool clearAudioJournal = false,
  }) {
    return TripDay(
      id: id,
      tripId: tripId,
      date: date,
      journalNote: journalNote ?? this.journalNote,
      audioJournalMediaId: clearAudioJournal
          ? null
          : (audioJournalMediaId ?? this.audioJournalMediaId),
    );
  }
}
