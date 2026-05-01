import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/trip_providers.dart';
import '../../domain/trip.dart';
import '../widgets/empty_state.dart';
import '../widgets/trip_card.dart';

class PlanPage extends ConsumerWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(allTripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planear'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/plan/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nova viagem'),
      ),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (trips) {
          final now = DateTime.now();
          final upcoming = trips
              .where((t) => t.resolvedStatus(now) != TripStatus.completed)
              .toList();
          if (upcoming.isEmpty) {
            return EmptyState(
              icon: Icons.map_outlined,
              title: 'Sem viagens planeadas',
              message:
                  'Adiciona a tua primeira viagem para começar a construir o itinerário.',
              action: FilledButton.icon(
                onPressed: () => context.push('/plan/new'),
                icon: const Icon(Icons.add),
                label: const Text('Criar viagem'),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: 220,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: upcoming.length,
            itemBuilder: (_, i) {
              final t = upcoming[i];
              return TripCard(
                trip: t,
                onTap: () => context.push('/plan/${t.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
