import 'day.dart';

DateTime _calendarKey(DateTime d) => DateTime(d.year, d.month, d.day);

List<TripDay> _sortedByDate(List<TripDay> days) {
  final sorted = [...days];
  sorted.sort(
    (a, b) => _calendarKey(a.date).compareTo(_calendarKey(b.date)),
  );
  return sorted;
}

/// Calendar day strictly before [now] that still has no rating (user must rate before continuing).
TripDay? pendingPastDayNeedingRating(List<TripDay> days, DateTime now) {
  final today = _calendarKey(now);
  for (final d in _sortedByDate(days)) {
    final dk = _calendarKey(d.date);
    if (!dk.isBefore(today)) break;
    if (d.dayRating == null) return d;
  }
  return null;
}

/// First unrated day in the trip.
/// After rating a day, it returns the next unrated day immediately.
TripDay? unlockedItineraryDay(List<TripDay> days, DateTime now) {
  final sorted = _sortedByDate(days);
  for (final d in sorted) {
    if (d.dayRating == null) return d;
  }
  return null;
}

/// Dia de calendário de hoje nesta viagem, se já tiver rating (ex.: terminaste o dia cedo).
TripDay? todayRatedDay(List<TripDay> days, DateTime now) {
  final t0 = _calendarKey(now);
  for (final d in days) {
    final dk = _calendarKey(d.date);
    if (dk == t0 && d.dayRating != null) return d;
  }
  return null;
}
