import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/trip_providers.dart';
import '../../domain/media.dart';
import '../../../media/photo_thumbnail.dart';

class TripGalleryPage extends ConsumerWidget {
  const TripGalleryPage({super.key, required this.tripId});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(tripMediaProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Gallery'),
      ),
      body: mediaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (media) {
          final photos = media.where((m) => m.type == MediaType.photo).toList();
          if (photos.isEmpty) {
            return const Center(
              child: Text('No photos captured during this trip.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: photos.length,
            itemBuilder: (context, i) {
              final photo = photos[i];
              return PhotoThumbnail(
                filePath: photo.filePath,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PhotoViewerPage(
                      filePath: photo.filePath,
                      dayId: photo.dayId,
                      mediaId: photo.id,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
