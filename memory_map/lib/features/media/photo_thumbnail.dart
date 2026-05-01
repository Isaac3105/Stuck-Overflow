import 'dart:io';

import 'package:flutter/material.dart';

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

class PhotoViewerPage extends StatelessWidget {
  const PhotoViewerPage({super.key, required this.filePath});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
