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

/// First day up to today that is unlocked (all prior calendar days rated) and not yet rated.
/// After rating "today" early, this returns null until the next calendar day.
TripDay? unlockedItineraryDay(List<TripDay> days, DateTime now) {
  final today = _calendarKey(now);
  final sorted = _sortedByDate(days);
  for (final d in sorted) {
    final dk = _calendarKey(d.date);
    if (dk.isAfter(today)) break;
    final priorAllRated = sorted.every((x) {
      final xk = _calendarKey(x.date);
      if (!xk.isBefore(dk)) return true;
      return x.dayRating != null;
    });
    if (!priorAllRated) continue;
    if (d.dayRating != null) continue;
    return d;
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
