import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../widgets/empty_state.dart';
import 'home_providers.dart';
import 'memory_preview_map.dart';
import 'story_player_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredCompletedTripProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Map'),
        actions: [
          IconButton(
            tooltip: 'Shuffle',
            icon: const Icon(Icons.shuffle_rounded),
            onPressed: () => rollNewFeatured(ref),
          ),
        ],
      ),
      body: featured.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data == null || data.photos.isEmpty) {
            return const EmptyState(
              icon: Icons.auto_stories_outlined,
              title: 'No memories yet',
              message:
                  'Finish a trip with photos and audios and it will appear here as a memory ready to relive.',
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                'Today, we remember...',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'A photo and the place it belongs to.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              _FeaturedCard(data: data),
              const SizedBox(height: 20),
              Text(
                'Tip: you can record audios during the trip and they can serve as a "background sound" for the memories.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.data});
  final FeaturedTripData data;

  /// Lower panel: map & context (photo hero uses the rest).
  static const _mapFlex = 32;
  static const _photoFlex = 68;

  @override
  Widget build(BuildContext context) {
    final cover = data.coverImagePath;
    final df = DateFormat('d MMM yyyy', 'en');
    final period =
        '${df.format(data.trip.startDate)} → ${df.format(data.trip.endDate)}';
    final scheme = Theme.of(context).colorScheme;
    const outerRadius = 20.0;
    const mapTopRadius = 18.0;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StoryPlayerPage(featured: data),
        ),
      ),
      child: Material(
        color: scheme.surfaceContainerHigh,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.18),
        surfaceTintColor: scheme.surfaceTint,
        borderRadius: BorderRadius.circular(outerRadius),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 9 / 14,
          child: Column(
            children: [
              Expanded(
                flex: _photoFlex,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (cover != null)
                      Image.file(
                        File(cover),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (ctx, err, st) => ColoredBox(
                          color: scheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_outlined,
                            size: 56,
                            color: scheme.onSurfaceVariant
                                .withValues(alpha: 0.45),
                          ),
                        ),
                      )
                    else
                      ColoredBox(
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_outlined,
                          size: 56,
                          color: scheme.onSurfaceVariant
                              .withValues(alpha: 0.45),
                        ),
                      ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.04),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.52),
                            Colors.black.withValues(alpha: 0.78),
                          ],
                          stops: const [0, 0.22, 0.5, 0.78, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data.trip.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                              shadows: [
                                Shadow(
                                  color: Color(0x66000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            period,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontSize: 14,
                              shadows: const [
                                Shadow(
                                  color: Color(0x66000000),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Icon(
                                Icons.play_circle_filled_rounded,
                                color: Colors.white.withValues(alpha: 0.95),
                                size: 30,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tap to relive',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  shadows: const [
                                    Shadow(
                                      color: Color(0x66000000),
                                      blurRadius: 6,
                                    ),
                                  ],
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
              Expanded(
                flex: _mapFlex,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(mapTopRadius),
                  ),
                  child: ColoredBox(
                    color: scheme.surfaceContainerLow,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (data.hasMap)
                          MemoryPreviewMap(
                            latitude: data.mapLatitude!,
                            longitude: data.mapLongitude!,
                            fallbackZoom: data.mapZoom!,
                            tripCountryNames: data.trip.countries,
                          )
                        else
                          Center(
                            child: Icon(
                              Icons.map_outlined,
                              size: 36,
                              color: scheme.onSurfaceVariant
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  scheme.outline.withValues(alpha: 0),
                                  scheme.outline.withValues(alpha: 0.35),
                                  scheme.outline.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (data.hasMap)
                          Positioned(
                            left: 10,
                            top: 8,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.surface.withValues(alpha: 0.88),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 6,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.place_outlined,
                                      size: 15,
                                      color: scheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'On the map',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: scheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.1,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          right: 8,
                          bottom: 5,
                          child: Text(
                            'Natural Earth',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  color: Color(0xB3000000),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
