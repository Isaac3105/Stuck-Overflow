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
      appBar: AppBar(title: const Text('Minhas viagens')),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (trips) {
          final now = DateTime.now();
          final completed = trips
              .where((t) => t.resolvedStatus(now) == TripStatus.completed)
              .toList();
          if (completed.isEmpty) {
            return const EmptyState(
              icon: Icons.luggage_outlined,
              title: 'Sem viagens concluídas',
              message: 'As viagens cujo período passou aparecem aqui.',
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
        final coverPath = ref.watch(_coverImagePathProvider(t));
        return TripCard(
          trip: t,
          coverImagePath: coverPath,
          onTap: () => context.push('/archive/${t.id}'),
        );
      },
    );
  }
}

final _coverImagePathProvider = Provider.autoDispose.family<String?, Trip>((ref, trip) {
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
