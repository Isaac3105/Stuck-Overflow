import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../widgets/empty_state.dart';
import 'home_providers.dart';
import 'memory_preview_map.dart';
import 'story_player_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final PageController _pageController;
  static const _initialPage = 5000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(allFeaturedTripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Map'),
      ),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data.isEmpty) {
            return const EmptyState(
              icon: Icons.auto_stories_outlined,
              title: 'No memories yet',
              message:
                  'Finish a trip with photos and audios and it will appear here as a memory ready to relive.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Swipe left or right to see more',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    final item = data[index % data.length];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: _FeaturedCard(data: item),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Text(
                  'Tip: you can record audios during the trip and they can serve as a "background sound" for the memories.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
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
                        ),
                      )
                    else
                      ColoredBox(
                        color: scheme.surfaceContainerHighest,
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
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
                          if (data.trip.averageDayRating != null) ...[
                            const SizedBox(width: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  data.trip.averageDayRating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        blurRadius: 8,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 26,
                                ),
                              ],
                            ),
                          ],
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
