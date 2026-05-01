import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../widgets/empty_state.dart';
import 'home_providers.dart';
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
            tooltip: 'Sortear outra',
            icon: const Icon(Icons.shuffle_rounded),
            onPressed: () => rollNewFeatured(ref),
          ),
        ],
      ),
      body: featured.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (data) {
          if (data == null || data.photos.isEmpty) {
            return const EmptyState(
              icon: Icons.auto_stories_outlined,
              title: 'Sem memórias ainda',
              message:
                  'Termina uma viagem com fotos e áudios e ela vai aparecer aqui como uma memória pronta a reviver.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Hoje, recordamos…',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _FeaturedCard(data: data),
              const SizedBox(height: 16),
              Text(
                'Dica: podes gravar um áudio diário durante a viagem e ele pode servir de “som de fundo” para as memórias.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  @override
  Widget build(BuildContext context) {
    final cover = data.coverImagePath;
    final df = DateFormat('d MMM yyyy', 'pt_PT');
    final period = '${df.format(data.trip.startDate)} → ${df.format(data.trip.endDate)}';

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StoryPlayerPage(featured: data),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 9 / 14,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (cover != null)
                Image.file(
                  File(cover),
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, st) => ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: const Center(
                      child: Icon(Icons.image_outlined, size: 56),
                    ),
                  ),
                )
              else
                ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: const Center(
                    child: Icon(Icons.image_outlined, size: 56),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.68),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.trip.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      period,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(Icons.play_circle_fill,
                            color: Colors.white, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Toca para reviver',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

