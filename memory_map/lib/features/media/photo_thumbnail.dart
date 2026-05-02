import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:video_player/video_player.dart';
import '../trips/data/trip_providers.dart';
import '../trips/domain/media.dart';

class MediaThumbnail extends StatelessWidget {
  const MediaThumbnail({
    super.key,
    required this.type,
    required this.filePath,
    this.borderRadius = 12,
    this.onTap,
  });

  final MediaType type;
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
        child: switch (type) {
          MediaType.photo => Image.file(
              File(filePath),
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Center(
                child: Icon(
                  Icons.image_outlined,
                  color: scheme.onSurfaceVariant,
                  size: 32,
                ),
              ),
            ),
          MediaType.video => _VideoThumb(
              filePath: filePath,
            ),
          MediaType.audio => Center(
              child: Icon(Icons.mic_none,
                  color: scheme.onSurfaceVariant, size: 32),
            ),
        },
      ),
    );
  }
}

class _VideoThumb extends StatefulWidget {
  const _VideoThumb({required this.filePath});
  final String filePath;

  @override
  State<_VideoThumb> createState() => _VideoThumbState();
}

class _VideoThumbState extends State<_VideoThumb> {
  VideoPlayerController? _c;
  bool _initOk = false;

  @override
  void initState() {
    super.initState();
    final c = VideoPlayerController.file(File(widget.filePath));
    _c = c;
    c.setLooping(false);
    c.setVolume(0);
    c.initialize().then((_) {
      if (!mounted) return;
      setState(() => _initOk = true);
    }).catchError((_) {/* ignore */});
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!_initOk || _c == null) {
      return Center(
        child:
            Icon(Icons.videocam_outlined, color: scheme.onSurfaceVariant, size: 34),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _c!.value.size.width,
            height: _c!.value.size.height,
            child: VideoPlayer(_c!),
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }
}

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
    return MediaThumbnail(
      type: MediaType.photo,
      filePath: filePath,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }
}

class MediaViewerPage extends ConsumerWidget {
  const MediaViewerPage({
    super.key,
    required this.type,
    required this.filePath,
    this.dayId,
    this.mediaId,
  });

  final MediaType type;
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
              ? 'Destaque removido.'
              : 'Definido como destaque do dia.'),
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
              tooltip: isCover ? 'Destaque do dia' : 'Definir como destaque do dia',
              onPressed: () => _setAsDayCover(context, ref),
            ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: type == MediaType.video ? 'Download do vídeo' : 'Download da foto',
            onPressed: () async {
              try {
                final hasAccess = await Gal.hasAccess(toAlbum: true);
                if (!hasAccess) {
                  await Gal.requestAccess(toAlbum: true);
                }
                if (type == MediaType.video) {
                  await Gal.putVideo(filePath);
                } else {
                  await Gal.putImage(filePath);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(type == MediaType.video
                          ? 'Vídeo salvo na galeria!'
                          : 'Foto salva na galeria!'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao salvar mídia: $e')),
                  );
                }
              }
            },
          ),
          if (mediaId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete media',
              onPressed: () => _confirmDelete(context, ref),
            ),
        ],
      ),
      body: Center(child: _ViewerBody(type: type, filePath: filePath)),
    );
  }
}

class _ViewerBody extends StatefulWidget {
  const _ViewerBody({required this.type, required this.filePath});
  final MediaType type;
  final String filePath;

  @override
  State<_ViewerBody> createState() => _ViewerBodyState();
}

class _ViewerBodyState extends State<_ViewerBody> {
  VideoPlayerController? _c;
  bool _initOk = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    if (widget.type != MediaType.video) return;
    final c = VideoPlayerController.file(File(widget.filePath));
    _c = c;
    c.setLooping(true);
    c.initialize().then((_) {
      if (!mounted) return;
      // Autoplay on open (expected behavior when tapping a video).
      c.play();
      setState(() => _initOk = true);
    }).catchError((e) {
      if (!mounted) return;
      setState(() => _initError = e.toString());
    });
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == MediaType.photo) {
      return InteractiveViewer(
        child: Image.file(
          File(widget.filePath),
          errorBuilder: (ctx, err, stack) =>
              const Icon(Icons.broken_image, color: Colors.white, size: 80),
        ),
      );
    }

    if (widget.type != MediaType.video) {
      return const Icon(Icons.broken_image, color: Colors.white, size: 80);
    }

    if (_initError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            const Text(
              'Não foi possível reproduzir este vídeo.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _initError!,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (!_initOk || _c == null) {
      return const CircularProgressIndicator.adaptive();
    }

    final isPlaying = _c!.value.isPlaying;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Keep the video centered and sized to fit within the screen,
        // avoiding Column overflow on short viewports / landscape.
        Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _c!.value.size.width,
              height: _c!.value.size.height,
              child: VideoPlayer(_c!),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 34,
                    color: Colors.white,
                    onPressed: () async {
                      if (isPlaying) {
                        await _c!.pause();
                      } else {
                        await _c!.play();
                      }
                      if (mounted) setState(() {});
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PhotoViewerPage extends StatelessWidget {
  const PhotoViewerPage({
    super.key,
    required this.filePath,
    this.dayId,
    this.mediaId,
  });

  final String filePath;
  final String? dayId;
  final String? mediaId;

  @override
  Widget build(BuildContext context) {
    return MediaViewerPage(
      type: MediaType.photo,
      filePath: filePath,
      dayId: dayId,
      mediaId: mediaId,
    );
  }
}
