import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/trip_providers.dart';
import '../../domain/trip.dart';
import '../widgets/empty_state.dart';
import '../widgets/trip_card.dart';

class ArchivePage extends ConsumerWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(allTripsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (trips) {
          final now = DateTime.now();
          final completed = trips
              .where((t) => t.resolvedStatus(now) == TripStatus.completed)
              .toList();
          if (completed.isEmpty) {
            return const EmptyState(
              icon: Icons.luggage_outlined,
              title: 'No completed trips',
              message: 'Trips whose period has passed will appear here.',
            );
          }
          return _ArchiveGrid(trips: completed);
        },
      ),
    );
  }
}

class _ArchiveGrid extends ConsumerWidget {
  const _ArchiveGrid({required this.trips});
  final List<Trip> trips;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: 220,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: trips.length,
      itemBuilder: (context, i) {
        final t = trips[i];
        final coverPath = ref.watch(tripCoverImagePathProvider(t));
        return TripCard(
          trip: t,
          coverImagePath: coverPath,
          onTap: () => context.push('/archive/${t.id}'),
        );
      },
    );
  }
}

