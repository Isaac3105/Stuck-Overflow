import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/env.dart';
import '../../../../core/services/gemini_service.dart';
import '../plan/activity_block_form.dart';

class GeminiSuggestions extends ConsumerWidget {
  const GeminiSuggestions({
    super.key,
    required this.country,
    required this.city,
    required this.dayId,
  });

  final String country;
  final String city;
  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!Env.hasGemini) return const SizedBox.shrink();
    final async = ref.watch(_geminiPlacesProvider((country: country, city: city)));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cultural suggestions (AI)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(_geminiPlacesProvider((country: country, city: city))),
                    child: const Text('Generate'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (items) {
                  if (items.isEmpty) {
                    return Text(
                      'No suggestions. Try "Generate" again.',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final p = items[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(p.name),
                          subtitle: Text(p.whyTypical),
                          trailing: const Icon(Icons.add),
                          onTap: () {
                            showModalBottomSheet<bool>(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => ActivityBlockForm(
                                dayId: dayId,
                                prefillTitle: p.name,
                                prefillNotes: p.whyTypical,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _geminiPlacesProvider = FutureProvider.autoDispose
    .family<List<PlaceSuggestion>, ({String country, String city})>((ref, args) {
  return ref.watch(geminiServiceProvider).suggestPlaces(
        country: args.country,
        city: args.city,
      );
});
