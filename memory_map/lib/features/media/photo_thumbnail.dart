import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import '../trips/data/trip_providers.dart';

class PhotoThumbnail extends StatelessWidget {
  const PhotoThumbnail({
    super.key,
    required this.filePath,
    this.borderRadius = 12,
    this.onTap,
  });

  final String filePath;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Image.file(
          File(filePath),
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => Center(
            child: Icon(Icons.image_outlined,
                color: scheme.onSurfaceVariant, size: 32),
          ),
        ),
      ),
    );
  }
}

class PhotoViewerPage extends ConsumerWidget {
  const PhotoViewerPage({
    super.key,
    required this.filePath,
    this.dayId,
    this.mediaId,
  });

  final String filePath;
  final String? dayId;
  final String? mediaId;

  Future<void> _setAsDayCover(BuildContext context, WidgetRef ref) async {
    if (dayId == null || mediaId == null) return;

    final currentDay = await ref.read(dayProvider(dayId!).future);
    final isAlreadyCover = currentDay?.coverMediaId == mediaId;

    await ref.read(tripRepositoryProvider).setDayCover(
          dayId!,
          isAlreadyCover ? null : mediaId,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAlreadyCover
              ? 'Imagem de destaque removida.'
              : 'Definida como imagem de destaque do dia.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayAsync = dayId == null ? null : ref.watch(dayProvider(dayId!));
    final isCover = dayAsync?.maybeWhen(
          data: (day) => day?.coverMediaId == mediaId,
          orElse: () => false,
        ) ??
        false;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (dayId != null && mediaId != null)
            IconButton(
              icon: Icon(isCover ? Icons.star : Icons.star_border_outlined),
              color: isCover ? Colors.amber : null,
              tooltip: isCover ? 'Imagem de destaque' : 'Definir como capa do dia',
              onPressed: () => _setAsDayCover(context, ref),
            ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download da foto',
            onPressed: () async {
              try {
                final hasAccess = await Gal.hasAccess(toAlbum: true);
                if (!hasAccess) {
                  await Gal.requestAccess(toAlbum: true);
                }
                await Gal.putImage(filePath);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Foto salva na galeria!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao salvar foto: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(
            File(filePath),
            errorBuilder: (ctx, err, stack) =>
                const Icon(Icons.broken_image, color: Colors.white, size: 80),
          ),
        ),
      ),
    );
  }
}
