import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../media/audio_player_tile.dart';
import '../../../media/photo_thumbnail.dart';
import '../../data/trip_providers.dart';
import '../../domain/day.dart';
import '../../domain/media.dart';
import '../widgets/activity_block_tile.dart';

class TripArchivePage extends ConsumerWidget {
  const TripArchivePage({super.key, required this.tripId});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripProvider(tripId));
    final daysAsync = ref.watch(tripDaysProvider(tripId));

    return Scaffold(
      body: tripAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (trip) {
          if (trip == null) return const SizedBox.shrink();
          return daysAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erro: $e')),
            data: (days) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    title: Text(trip.name),
                    expandedHeight: 160,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _Header(countries: trip.countries),
                      title: null,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        '${DateFormat('d MMM yyyy', 'pt_PT').format(trip.startDate)} → '
                        '${DateFormat('d MMM yyyy', 'pt_PT').format(trip.endDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: days.length,
                    itemBuilder: (context, i) =>
                        _DaySection(day: days[i], dayIndex: i + 1),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.countries});
  final List<String> countries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.tertiaryContainer],
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
      child: Wrap(
        spacing: 6,
        children: countries
            .take(8)
            .map(
              (c) => ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SizedBox(
                  width: 28,
                  height: 18,
                  child: Flag.fromString(c, fit: BoxFit.cover),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DaySection extends ConsumerWidget {
  const _DaySection({required this.day, required this.dayIndex});
  final TripDay day;
  final int dayIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(dayBlocksProvider(day.id));
    final mediaAsync = ref.watch(dayMediaProvider(day.id));
    final dateLabel =
        DateFormat("EEEE, d 'de' MMMM", 'pt_PT').format(day.date);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text('$dayIndex'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          blocksAsync.maybeWhen(
            data: (blocks) {
              if (blocks.isEmpty) return const SizedBox.shrink();
              return Column(
                children: blocks
                    .map((b) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ActivityBlockTile(block: b, dense: true),
                        ))
                    .toList(),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          mediaAsync.maybeWhen(
            data: (media) {
              final photos =
                  media.where((m) => m.type == MediaType.photo).toList();
              final audios =
                  media.where((m) => m.type == MediaType.audio).toList();
              if (photos.isEmpty && audios.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (photos.isNotEmpty)
                      SizedBox(
                        height: 96,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: photos.length,
                          separatorBuilder: (context, i) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) => SizedBox(
                            width: 96,
                            child: PhotoThumbnail(
                              filePath: photos[i].filePath,
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => PhotoViewerPage(
                                  filePath: photos[i].filePath,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    if (audios.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...audios.map((a) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: AudioPlayerTile(
                              filePath: a.filePath,
                              label:
                                  'Áudio às ${DateFormat('HH:mm').format(a.takenAt)}',
                            ),
                          )),
                    ],
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }
}
