import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/db/database.dart';

class TripPlaylistCard extends StatelessWidget {
  const TripPlaylistCard({super.key, required this.playlist});
  final PlaylistRow playlist;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      child: ListTile(
        leading: const Icon(Icons.queue_music),
        title: Text(
          playlist.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: const Text('Playlist da viagem'),
        trailing: const Icon(Icons.open_in_new),
        onTap: playlist.deepLink == null
            ? null
            : () => launchUrl(
                  Uri.parse(playlist.deepLink!),
                  mode: LaunchMode.externalApplication,
                ),
      ),
    );
  }
}

