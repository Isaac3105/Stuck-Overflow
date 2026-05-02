import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    if (mediaId == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete photo?'),
        content: const Text('This photo will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await ref.read(tripRepositoryProvider).deleteMedia(mediaId!);
    if (context.mounted) Navigator.of(context).pop();
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
          if (mediaId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete photo',
              onPressed: () => _confirmDelete(context, ref),
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
