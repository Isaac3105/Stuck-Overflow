import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/day.dart';
import '../../domain/trip.dart';
import '../../data/trip_providers.dart';
import '../plan/activity_block_form.dart';
import '../widgets/suggestions_sidebar.dart';
import '../widgets/activity_block_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/weather_card.dart';

class FullItineraryPage extends ConsumerWidget {
  const FullItineraryPage({
    super.key,
    required this.trip,
    required this.day,
  });

  final Trip trip;
  final TripDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(dayBlocksProvider(day.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Itinerary'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: 'Suggestions',
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: SuggestionsSidebar(
        trip: trip,
        dayId: day.id,
      ),
      body: blocksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (blocks) {
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                children: [
                  WeatherCard(countries: trip.countries),
                  const SizedBox(height: 16),
                  if (blocks.isEmpty)
                    EmptyState(
                      icon: Icons.add_chart,
                      title: 'No activities',
                      message: 'Create the first block for this day.',
                      action: FilledButton.icon(
                        onPressed: () => _openBlockSheet(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add activity'),
                      ),
                    )
                  else
                    ...blocks.map(
                      (b) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ActivityBlockTile(
                          block: b,
                          onTap: () => _openBlockSheet(context, existing: b),
                        ),
                      ),
                    ),
                ],
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.extended(
                  onPressed: () => _openBlockSheet(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Block'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openBlockSheet(BuildContext context, {dynamic existing}) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ActivityBlockForm(
        dayId: day.id,
        existing: existing,
      ),
    );
  }
}
