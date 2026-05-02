// ignore_for_file: deprecated_member_use, sort_child_properties_last
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/geography.dart';
import '../../data/trip_providers.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';
import '../home/home_providers.dart';
import '../home/story_player_page.dart';
import '../widgets/trip_card.dart';

enum _MyTripsViewMode { chronological, groupCountry, groupRating }

const _kMultiCountryGroupKey = '__multi__';

class _TripGroup {
  const _TripGroup({required this.title, required this.trips});
  final String title;
  final List<Trip> trips;
}

class _MyTripsFilterState {
  const _MyTripsFilterState({
    this.ratingRange = const RangeValues(0, 5),
    this.destinationQuery = '',
    this.dateRange,
  });

  final RangeValues ratingRange;
  final String destinationQuery;
  final DateTimeRange? dateRange;
}

class MyTrips extends ConsumerStatefulWidget {
  const MyTrips({super.key});

  @override
  ConsumerState<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends ConsumerState<MyTrips> {
  String _searchQuery = '';
  _MyTripsViewMode _viewMode = _MyTripsViewMode.chronological;
  bool _chronologicalAscending = false;
  _MyTripsFilterState _filters = const _MyTripsFilterState();

  List<Trip> _filteredTrips(List<Trip> all, DateTime now) {
    return all
        .where((t) => t.resolvedStatus(now) == TripStatus.completed)
        .where((t) => _matchesSearch(t, _searchQuery))
        .where((t) => _matchesRating(t, _filters.ratingRange))
        .where((t) => _matchesDestination(t, _filters.destinationQuery))
        .where((t) => _matchesDateRange(t, _filters.dateRange))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(allTripsProvider);

    return tripsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (trips) {
        final now = DateTime.now();
        final filtered = _filteredTrips(trips, now);
        final chronologicalOrdered = _viewMode == _MyTripsViewMode.chronological
            ? _sortTripsChronological(filtered, _chronologicalAscending)
            : const <Trip>[];

        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        hintText: 'Search trips...',
                        leading: const Icon(Icons.search),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onChanged: (value) => setState(() => _searchQuery = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      context,
                      icon: Icons.view_list,
                      onPressed: () => _showViewModeSheet(context),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      context,
                      icon: Icons.filter_list,
                      onPressed: () => _showFilterSheet(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No completed trips.'))
                    : _viewMode == _MyTripsViewMode.chronological
                        ? GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const ClampingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: chronologicalOrdered.length,
                            itemBuilder: (context, index) {
                              final t = chronologicalOrdered[index];
                              final coverPath =
                                  ref.watch(_coverImagePathProvider(t));
                              return TripCard(
                                trip: t,
                                coverImagePath: coverPath,
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) =>
                                      _TripPreviewDialog(trip: t),
                                ),
                              );
                            },
                          )
                        : CustomScrollView(
                            physics: const ClampingScrollPhysics(),
                            slivers: _buildGroupedTripSlivers(
                              context,
                              ref,
                              _viewMode == _MyTripsViewMode.groupCountry
                                  ? _groupTripsByCountry(filtered)
                                  : _groupTripsByRating(filtered),
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _showViewModeSheet(BuildContext context) async {
    final chosen = await showModalBottomSheet<_MyTripsViewMode>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'View',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Inside each group, trips are ordered by end date (newest first).',
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Timeline'),
                subtitle: const Text('Flat grid by end date'),
                trailing: _viewMode == _MyTripsViewMode.chronological
                    ? Icon(
                        _chronologicalAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      )
                    : null,
                onTap: () => Navigator.pop(ctx, _MyTripsViewMode.chronological),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Group by country'),
                onTap: () => Navigator.pop(ctx, _MyTripsViewMode.groupCountry),
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Group by rating'),
                onTap: () => Navigator.pop(ctx, _MyTripsViewMode.groupRating),
              ),
            ],
          ),
        );
      },
    );
    if (chosen != null && mounted) {
      setState(() {
        if (_viewMode == chosen &&
            chosen == _MyTripsViewMode.chronological) {
          _chronologicalAscending = !_chronologicalAscending;
        } else {
          _viewMode = chosen;
        }
      });
    }
  }

  List<Widget> _buildGroupedTripSlivers(
    BuildContext context,
    WidgetRef ref,
    List<_TripGroup> groups,
  ) {
    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
    );
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    final slivers = <Widget>[];
    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, i == 0 ? 0 : 20, 16, 8),
            child: Text(g.title, style: titleStyle),
          ),
        ),
      );
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (ctx, j) {
                final t = g.trips[j];
                final coverPath = ref.watch(_coverImagePathProvider(t));
                return TripCard(
                  trip: t,
                  coverImagePath: coverPath,
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => _TripPreviewDialog(trip: t),
                  ),
                );
              },
              childCount: g.trips.length,
            ),
          ),
        ),
      );
    }
    slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 16)));
    return slivers;
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final applied = await showModalBottomSheet<_MyTripsFilterState>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return _FilterSheetBody(initial: _filters);
      },
    );
    if (applied != null && mounted) setState(() => _filters = applied);
  }
}

List<Trip> _sortTripsChronological(List<Trip> trips, bool ascending) {
  final out = [...trips];
  out.sort((a, b) {
    final cmp = a.endDate.compareTo(b.endDate);
    return ascending ? cmp : -cmp;
  });
  return out;
}

String _countryGroupTitle(String key) {
  if (key.isEmpty) return 'No country';
  if (key == _kMultiCountryGroupKey) return 'Multiple countries';
  return resolveGeography(key)?.name ?? key;
}

int _countryGroupTier(String key) {
  if (key.isEmpty) return 2;
  if (key == _kMultiCountryGroupKey) return 1;
  return 0;
}

List<_TripGroup> _groupTripsByCountry(List<Trip> trips) {
  final map = <String, List<Trip>>{};
  for (final t in trips) {
    final String key;
    if (t.countries.isEmpty) {
      key = '';
    } else if (t.countries.length > 1) {
      key = _kMultiCountryGroupKey;
    } else {
      key = t.countries.first;
    }
    map.putIfAbsent(key, () => []).add(t);
  }
  for (final list in map.values) {
    list.sort((a, b) => b.endDate.compareTo(a.endDate));
  }
  final keys = map.keys.toList()
    ..sort((a, b) {
      final ta = _countryGroupTier(a);
      final tb = _countryGroupTier(b);
      if (ta != tb) return ta.compareTo(tb);
      return _countryGroupTitle(a).compareTo(_countryGroupTitle(b));
    });
  return [
    for (final k in keys)
      if (map[k]!.isNotEmpty)
        _TripGroup(title: _countryGroupTitle(k), trips: map[k]!),
  ];
}

int? _ratingBucket(Trip t) {
  final v = t.averageDayRating;
  if (v == null) return null;
  return v.round().clamp(1, 5);
}

List<_TripGroup> _groupTripsByRating(List<Trip> trips) {
  final buckets = <int?, List<Trip>>{};
  for (final t in trips) {
    final b = _ratingBucket(t);
    buckets.putIfAbsent(b, () => []).add(t);
  }
  for (final list in buckets.values) {
    list.sort((a, b) => b.endDate.compareTo(a.endDate));
  }
  const order = <int?>[5, 4, 3, 2, 1, null];
  return [
    for (final stars in order)
      if (buckets[stars] != null && buckets[stars]!.isNotEmpty)
        _TripGroup(
          title: stars == null ? 'Unrated' : '$stars ★',
          trips: buckets[stars]!,
        ),
  ];
}

bool _matchesSearch(Trip t, String q) {
  final s = q.trim().toLowerCase();
  if (s.isEmpty) return true;
  return t.name.toLowerCase().contains(s) ||
      t.countries.any((c) => c.toLowerCase().contains(s)) ||
      t.cities.any((c) => c.toLowerCase().contains(s));
}

bool _matchesRating(Trip t, RangeValues r) {
  final v = t.averageDayRating;
  if (v == null) return r.start <= 0.01;
  return v + 1e-9 >= r.start && v - 1e-9 <= r.end;
}

bool _matchesDestination(Trip t, String q) {
  final s = q.trim().toLowerCase();
  if (s.isEmpty) return true;
  return t.name.toLowerCase().contains(s) ||
      t.countries.any((c) => c.toLowerCase().contains(s)) ||
      t.cities.any((c) => c.toLowerCase().contains(s));
}

bool _matchesDateRange(Trip t, DateTimeRange? dr) {
  if (dr == null) return true;
  final tripStart = DateTime(t.startDate.year, t.startDate.month, t.startDate.day);
  final tripEnd = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);
  final r0 = DateTime(dr.start.year, dr.start.month, dr.start.day);
  final r1 = DateTime(dr.end.year, dr.end.month, dr.end.day);
  return !(tripEnd.isBefore(r0) || tripStart.isAfter(r1));
}

class _FilterSheetBody extends StatefulWidget {
  const _FilterSheetBody({required this.initial});
  final _MyTripsFilterState initial;

  @override
  State<_FilterSheetBody> createState() => _FilterSheetBodyState();
}

class _FilterSheetBodyState extends State<_FilterSheetBody> {
  late RangeValues _ratingRange;
  late final TextEditingController _destination;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _ratingRange = widget.initial.ratingRange;
    _destination =
        TextEditingController(text: widget.initial.destinationQuery);
    _dateRange = widget.initial.dateRange;
  }

  @override
  void dispose() {
    _destination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Destination',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _destination,
            decoration: const InputDecoration(
              hintText: 'Country, city, or trip name',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rating (daily average)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${_ratingRange.start.toStringAsFixed(1)} ★ – ${_ratingRange.end.toStringAsFixed(1)} ★',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _ratingRange,
            min: 0,
            max: 5,
            divisions: 50,
            labels: RangeLabels(
              _ratingRange.start.toStringAsFixed(1),
              _ratingRange.end.toStringAsFixed(1),
            ),
            onChanged: (values) => setState(() => _ratingRange = values),
          ),
          const Text(
            'Trips missing some day ratings only appear when the minimum is 0.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          const Text(
            'Date range',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDateRange: _dateRange,
              );
              if (picked != null) setState(() => _dateRange = picked);
            },
            icon: const Icon(Icons.calendar_month),
            label: Text(
              _dateRange == null
                  ? 'Pick dates'
                  : '${DateFormat('dd/MM/yy', 'en').format(_dateRange!.start)} – ${DateFormat('dd/MM/yy', 'en').format(_dateRange!.end)}',
            ),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      const _MyTripsFilterState(),
                    );
                  },
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      _MyTripsFilterState(
                        ratingRange: _ratingRange,
                        destinationQuery: _destination.text,
                        dateRange: _dateRange,
                      ),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}



class _TripPreviewDialog extends ConsumerWidget {
  const _TripPreviewDialog({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(tripFeaturedDataProvider(trip.id));
    final range =
        '${DateFormat('d MMM yyyy', 'en').format(trip.startDate)} → ${DateFormat('d MMM yyyy', 'en').format(trip.endDate)}';
    final place = [
      if (trip.countries.isNotEmpty) resolveGeography(trip.countries.first)?.name ?? trip.countries.first,
      if (trip.cities.isNotEmpty) trip.cities.first,
    ].join(', ');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              featuredAsync.when(
                loading: () => Container(color: Colors.black12),
                error: (e, _) => Container(color: Colors.black12),
                data: (data) {
                  if (data == null || data.photos.isEmpty) {
                    return Container(color: Colors.black12);
                  }
                  return _TripBackgroundSlideshow(photos: data.photos);
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent,
                      Colors.black.withOpacity(0.92),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (trip.averageDayRating != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  trip.averageDayRating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  ' / 5 (daily average)',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                place,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                range,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        featuredAsync.when(
                          data: (data) => data == null || data.photos.isEmpty
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              StoryPlayerPage(featured: data),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.play_circle_fill),
                                    label: const Text('WATCH STORY'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                          loading: () => const SizedBox.shrink(),
                          error: (e, _) => const SizedBox.shrink(),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.push('/archive/${trip.id}');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white70),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'SEE DETAILS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _coverImagePathProvider =
    Provider.autoDispose.family<String?, Trip>((ref, trip) {
  final mediaAsync = ref.watch(tripMediaProvider(trip.id));
  final daysAsync = ref.watch(tripDaysProvider(trip.id));

  return mediaAsync.maybeWhen(
    data: (list) {
      // 1. Specific trip cover
      if (trip.coverMediaId != null) {
        for (final m in list) {
          if (m.id == trip.coverMediaId) return m.filePath;
        }
      }

      // 2. Try to find the first "main image" of any day
      final mainImageIds = daysAsync.maybeWhen(
        data: (days) => days.map((d) => d.coverMediaId).whereType<String>().toSet(),
        orElse: () => <String>{},
      );

      if (mainImageIds.isNotEmpty) {
        for (final m in list) {
          if (mainImageIds.contains(m.id)) return m.filePath;
        }
      }

      // 3. Fallback to first photo
      for (final m in list) {
        if (m.type == MediaType.photo) return m.filePath;
      }
      return null;
    },
    orElse: () => null,
  );
});

class _TripBackgroundSlideshow extends StatefulWidget {
  const _TripBackgroundSlideshow({required this.photos});
  final List<MediaItem> photos;

  @override
  State<_TripBackgroundSlideshow> createState() =>
      _TripBackgroundSlideshowState();
}

class _TripBackgroundSlideshowState extends State<_TripBackgroundSlideshow> {
  int _index = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && widget.photos.isNotEmpty) {
        setState(() {
          _index = (_index + 1) % widget.photos.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: Image.file(
        key: ValueKey(widget.photos[_index].id),
        File(widget.photos[_index].filePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

