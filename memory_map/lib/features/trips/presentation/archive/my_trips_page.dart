// ignore_for_file: deprecated_member_use, sort_child_properties_last
import 'dart:async';
import 'dart:io';

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/countries.dart';
import '../../data/trip_providers.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';
import '../home/home_providers.dart';
import '../home/story_player_page.dart';
import '../widgets/trip_card.dart';

class MyTrips extends ConsumerWidget {
  const MyTrips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(allTripsProvider);

    return tripsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (trips) {
        final now = DateTime.now();
        final completed = trips
            .where((t) => t.resolvedStatus(now) == TripStatus.completed)
            .toList(growable: false);

        return SafeArea(
          child: Column(
            children: [
              // Search Bar + Sort & Filter Buttons
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
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      context,
                      icon: Icons.sort,
                      onPressed: () => _showSortSheet(context),
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
                child: completed.isEmpty
                    ? const Center(child: Text('No completed trips.'))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        physics: const ClampingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 240,
                          mainAxisExtent: 220,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: completed.length,
                        itemBuilder: (context, index) =>
                            _TripCard(trip: completed[index]),
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

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Country Name'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Rating'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    RangeValues ratingRange = const RangeValues(0.0, 5.0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                        'Filter Configuration',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter country or city',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rating Range',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${ratingRange.start.toStringAsFixed(1)} ★ - ${ratingRange.end.toStringAsFixed(1)} ★',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: ratingRange,
                    min: 0.0,
                    max: 5.0,
                    divisions: 5,
                    labels: RangeLabels(
                      ratingRange.start.toStringAsFixed(1),
                      ratingRange.end.toStringAsFixed(1),
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        ratingRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Date Range',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Select Dates'),
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Reset All'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _TripCard extends ConsumerWidget {
  const _TripCard({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverPath = ref.watch(_coverImagePathProvider(trip));

    return TripCard(
      trip: trip,
      coverImagePath: coverPath,
      onTap: () => showDialog(
        context: context,
        builder: (_) => _TripPreviewDialog(trip: trip),
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
    
    final locationParts = <String>[];
    if (trip.countries.isNotEmpty) {
      locationParts.add(countryNameEn(trip.countries.first));
    }
    if (trip.cities.isNotEmpty) {
      locationParts.add(trip.cities.first);
    }
    final place = locationParts.join(', ');

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
              Positioned(
                top: 16,
                left: 16,
                child: Wrap(
                  spacing: 4,
                  children: trip.countries
                      .take(4)
                      .map(
                        (c) => ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: SizedBox(
                            width: 32,
                            height: 22,
                            child: Flag.fromString(c, fit: BoxFit.cover),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
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
                    const SizedBox(height: 16),
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
  if (trip.coverMediaId == null) {
    final mediaAsync = ref.watch(tripMediaProvider(trip.id));
    return mediaAsync.maybeWhen(
      data: (list) {
        for (final m in list) {
          if (m.type.name == 'photo') return m.filePath;
        }
        return null;
      },
      orElse: () => null,
    );
  }
  final mediaAsync = ref.watch(tripMediaProvider(trip.id));
  return mediaAsync.maybeWhen(
    data: (list) {
      for (final m in list) {
        if (m.id == trip.coverMediaId) return m.filePath;
      }
      for (final m in list) {
        if (m.type.name == 'photo') return m.filePath;
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
