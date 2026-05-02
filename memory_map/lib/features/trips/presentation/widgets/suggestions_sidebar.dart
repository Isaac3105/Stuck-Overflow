import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/env.dart';
import '../../../music/data/spotify_repository.dart';
import '../../../../core/services/spotify_service.dart';
import '../../domain/trip.dart';
import 'gemini_suggestions.dart';

class SuggestionsSidebar extends StatelessWidget {
  const SuggestionsSidebar({
    super.key,
    required this.trip,
    required this.dayId,
  });

  final Trip trip;
  final String dayId;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.88,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome),
                  const SizedBox(width: 8),
                  Text(
                    'Suggestions',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            if (Env.hasSpotify && trip.countries.isNotEmpty)
              _SpotifySuggestions(
                tripId: trip.id,
                country: trip.countries.first,
              ),
            if (Env.hasGemini &&
                trip.countries.isNotEmpty &&
                trip.cities.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GeminiSuggestions(
                  country: trip.countries.first,
                  city: trip.cities.first,
                  dayId: dayId,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SpotifySuggestions extends ConsumerWidget {
  const _SpotifySuggestions({required this.tripId, required this.country});
  final String tripId;
  final String country;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAsync = ref.watch(_selectedPlaylistProvider(tripId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.music_note_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Local playlists',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (selectedAsync.hasValue && selectedAsync.valueOrNull != null)
                    IconButton(
                      tooltip: 'Open playlist',
                      onPressed: () {
                        final p = selectedAsync.value!;
                        if (p.deepLink == null) return;
                        launchUrl(
                          Uri.parse(p.deepLink!),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: const Icon(Icons.open_in_new),
                    ),
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => _SpotifyPlaylistPickerSheet(
                          tripId: tripId,
                          countryCode: country,
                        ),
                      );
                    },
                    child: const Text('Choose'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              selectedAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => Text('Error: $e'),
                data: (p) {
                  if (p == null) {
                    return Text(
                      'No playlist chosen for this trip.',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Playlist set for the trip',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: p.deepLink == null
                        ? null
                        : () => launchUrl(
                              Uri.parse(p.deepLink!),
                              mode: LaunchMode.externalApplication,
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

class _SpotifyPlaylistPickerSheet extends ConsumerWidget {
  const _SpotifyPlaylistPickerSheet({
    required this.tripId,
    required this.countryCode,
  });

  final String tripId;
  final String countryCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(spotifyRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final async = ref.watch(
      _spotifySuggestionsProvider((tripId: tripId, countryCode: countryCode)),
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Choose playlist',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(
                    _spotifySuggestionsProvider(
                      (tripId: tripId, countryCode: countryCode),
                    ),
                  ),
                  child: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            async.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Spotify error: $e'),
              ),
              data: (options) {
                if (options.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No suggestions. Try "Refresh".',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }

                return Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final p = options[i];
                      return Card(
                        child: ListTile(
                          title: Text(
                            p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: const Icon(Icons.queue_music),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                tooltip: 'Open in Spotify',
                                onPressed: () => launchUrl(
                                  Uri.parse(p.deepLink),
                                  mode: LaunchMode.externalApplication,
                                ),
                                icon: const Icon(Icons.open_in_new),
                              ),
                              FilledButton(
                                onPressed: () async {
                                  try {
                                    await repo.selectPlaylistForTrip(
                                      tripId: tripId,
                                      countryName: countryCode,
                                      playlist: p,
                                    );
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text('Playlist chosen.'),
                                      ),
                                    );
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  } catch (e) {
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text('Spotify error: $e'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Choose'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

final _selectedPlaylistProvider =
    StreamProvider.autoDispose.family((ref, String tripId) {
  return ref
      .watch(spotifyRepositoryProvider)
      .watchSelectedPlaylistForTrip(tripId);
});

final _spotifySuggestionsProvider = FutureProvider.autoDispose.family
    <List<SpotifyPlaylist>, ({String tripId, String countryCode})>((ref, args) {
  return ref.watch(spotifyRepositoryProvider).suggestPlaylists(
        countryName: args.countryCode,
        limit: 3,
      );
});
