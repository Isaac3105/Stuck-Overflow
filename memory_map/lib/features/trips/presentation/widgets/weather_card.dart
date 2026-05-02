import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/weather_service.dart';

final _weatherProvider = FutureProvider.autoDispose
    .family<WeatherSnapshot?, ({double lat, double lng})>((ref, c) async {
  return ref.watch(weatherServiceProvider).fetch(
        latitude: c.lat,
        longitude: c.lng,
      );
});

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key, required this.countries});
  final List<String> countries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coords = coordsForCountries(countries);
    if (coords == null) return const SizedBox.shrink();
    final async = ref.watch(_weatherProvider(coords));
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: async.when(
          loading: () => const SizedBox(
            height: 56,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => const Text('No weather available'),
          data: (w) {
            if (w == null) {
              return const Text('No weather available');
            }
            return Row(
              children: [
                Text(w.emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${w.temperatureC.toStringAsFixed(0)}°C',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      w.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
