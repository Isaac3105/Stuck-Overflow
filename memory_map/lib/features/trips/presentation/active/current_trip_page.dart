import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/media_capture_service.dart';
import '../../../media/audio_player_tile.dart';
import '../../../media/audio_recorder_button.dart';
import '../../../media/photo_thumbnail.dart';
import '../../../music/data/spotify_repository.dart';
import '../../../music/presentation/trip_playlist_card.dart';
import '../../data/trip_providers.dart';
import '../../domain/media.dart';
import '../../domain/trip.dart';
import '../widgets/empty_state.dart';
import '../widgets/weather_card.dart';

class CurrentTripPage extends ConsumerWidget {
  const CurrentTripPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrip = ref.watch(currentTripProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Viagem atual')),
      body: currentTrip.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (trip) {
          if (trip == null) {
            return EmptyState(
              icon: Icons.flight_takeoff_outlined,
              title: 'Nenhuma viagem em curso',
              message:
                  'Quando uma viagem planeada incluir o dia de hoje, ela aparecerá aqui automaticamente.',
              action: FilledButton.icon(
                onPressed: () => context.go('/plan'),
                icon: const Icon(Icons.map_outlined),
                label: const Text('Ir ao planeamento'),
              ),
            );
          }
          return _CurrentTripBody(trip: trip);
        },
      ),
    );
  }
}

class _CurrentTripBody extends ConsumerWidget {
  const _CurrentTripBody({required this.trip});
  final Trip trip;

  Future<void> _capturePhoto(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final day = await ref.read(_todayTripDayProvider(trip.id).future);
    if (day == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Sem dia configurado para hoje.')),
      );
      return;
    }
    final media = await ref.read(mediaCaptureServiceProvider).capturePhoto(
          tripId: trip.id,
          dayId: day.id,
        );
    if (media == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Captura cancelada ou sem permissão.')),
      );
    }
  }

  Future<void> _confirmTerminateDay(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terminar viagem'),
        content: const Text(
          'Isto marca a viagem como concluída. Podes continuar a ver as memórias no arquivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Concluir'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(tripRepositoryProvider).setStatus(trip.id, TripStatus.completed);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Viagem concluída.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAsync = ref.watch(_todayTripDayProvider(trip.id));
    final playlistAsync = ref.watch(_selectedPlaylistProviderForTrip(trip.id));

    return todayAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (day) {
        if (day == null) {
          return const EmptyState(
            icon: Icons.event_busy_outlined,
            title: 'Sem dia configurado',
            message: 'A viagem está activa mas não há um dia para hoje.',
          );
        }

        final blocksAsync = ref.watch(dayBlocksProvider(day.id));
        final mediaAsync = ref.watch(dayMediaProvider(day.id));
        final dateLabel = DateFormat("EEEE, d 'de' MMMM", 'pt_PT').format(day.date);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _HeaderCard(trip: trip, dateLabel: dateLabel, dayId: day.id),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _capturePhoto(context, ref),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Tirar foto'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Itinerário',
                        style: Theme.of(context).textTheme.titleMedium),
                    const Divider(height: 16),
                    blocksAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Erro: $e'),
                      data: (blocks) {
                        if (blocks.isEmpty) {
                          return Text(
                            'Sem blocos para hoje. Adiciona-os no planeador.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        }
                        final shown = blocks.take(3).toList(growable: false);
                        return Column(
                          children: [
                            for (final b in shown)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text(
                                  b.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text('${b.startLabel} – ${b.endLabel}'),
                                onTap: () => context.go('/plan/${trip.id}'),
                              ),
                            if (blocks.length > shown.length)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () => context.go('/plan/${trip.id}'),
                                  child: const Text('Ver tudo no planeador'),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            WeatherCard(countries: trip.countries),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AudioRecorderButton(
                        tripId: trip.id,
                        dayId: day.id,
                        onRecorded: (mediaId) => ref
                            .read(tripRepositoryProvider)
                            .setDayAudio(day.id, mediaId),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.go('/plan/${trip.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.music_note_outlined),
                            const SizedBox(height: 6),
                            Text(
                              'Playlist',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            playlistAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, st) => const SizedBox.shrink(),
              data: (p) => p == null
                  ? const SizedBox.shrink()
                  : TripPlaylistCard(playlist: p),
            ),
            const SizedBox(height: 16),
            _CapturesSection(dayId: day.id, mediaAsync: mediaAsync),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => _confirmTerminateDay(context, ref),
              child: const Text('TERMINAR VIAGEM'),
            ),
          ],
        );
      },
    );
  }

  void _scrollToCaptures(BuildContext context) {
    // Keeping it simple: the captures section is already on this page.
    // If you want true scroll-to-anchor, we can convert to ScrollController + GlobalKey.
  }
}

class _HeaderCard extends ConsumerWidget {
  const _HeaderCard({
    required this.trip,
    required this.dateLabel,
    required this.dayId,
  });

  final Trip trip;
  final String dateLabel;
  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(dayMediaProvider(dayId));
    final cover = mediaAsync.maybeWhen(
      data: (media) => media.where((m) => m.type == MediaType.photo).cast<MediaItem?>().firstWhere(
            (_) => true,
            orElse: () => null,
          ),
      orElse: () => null,
    );

    final cityLine = trip.cities.isEmpty ? null : trip.cities.join(' · ');
    final countryLine = trip.countries.isEmpty ? null : trip.countries.join(' · ');

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (cover != null)
              Image.file(
                File(cover.filePath),
                fit: BoxFit.cover,
              )
            else
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: const Center(
                  child: Icon(Icons.image_outlined, size: 48),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                  ),
                  const Spacer(),
                  if (cityLine != null)
                    Text(
                      cityLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  if (countryLine != null)
                    Text(
                      countryLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CapturesSection extends StatelessWidget {
  const _CapturesSection({required this.dayId, required this.mediaAsync});

  final String dayId;
  final AsyncValue<List<MediaItem>> mediaAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Capturas de hoje', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        mediaAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Erro: $e'),
          data: (media) {
            if (media.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Ainda sem fotos ou áudios para hoje.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }
            final photos = media.where((m) => m.type == MediaType.photo).toList();
            final audios = media.where((m) => m.type == MediaType.audio).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (photos.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (_, i) => PhotoThumbnail(
                      filePath: photos[i].filePath,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PhotoViewerPage(filePath: photos[i].filePath),
                        ),
                      ),
                    ),
                  ),
                if (audios.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...audios.map(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: AudioPlayerTile(
                        filePath: a.filePath,
                        label: 'Áudio às ${DateFormat('HH:mm').format(a.takenAt)}',
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

final _todayTripDayProvider = FutureProvider.autoDispose.family((ref, String tripId) async {
  final days = await ref.watch(tripRepositoryProvider).getDays(tripId);
  final today = DateTime.now();
  final todayKey = DateTime(today.year, today.month, today.day);
  for (final d in days) {
    final key = DateTime(d.date.year, d.date.month, d.date.day);
    if (key == todayKey) return d;
  }
  return null;
});

final _selectedPlaylistProviderForTrip =
    StreamProvider.autoDispose.family((ref, String tripId) {
  return ref.watch(spotifyRepositoryProvider).watchSelectedPlaylistForTrip(tripId);
});

