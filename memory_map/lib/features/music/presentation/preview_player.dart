import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PreviewPlayer extends StatefulWidget {
  const PreviewPlayer({
    super.key,
    required this.title,
    required this.previewUrls,
  });

  final String title;
  final List<String> previewUrls;

  @override
  State<PreviewPlayer> createState() => _PreviewPlayerState();
}

class _PreviewPlayerState extends State<PreviewPlayer> {
  final _player = AudioPlayer();
  int _idx = 0;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (widget.previewUrls.isEmpty) return;
    final sources = widget.previewUrls
        .map((u) => AudioSource.uri(Uri.parse(u)))
        .toList();
    await _player.setAudioSource(ConcatenatingAudioSource(children: sources));
    _player.currentIndexStream.listen((i) {
      if (!mounted) return;
      setState(() => _idx = i ?? 0);
    });
    if (!mounted) return;
    setState(() => _ready = true);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton.filled(
                  onPressed: !_ready
                      ? null
                  : () => _player.playing ? _player.pause() : _player.play(),
              icon: Icon(_player.playing ? Icons.pause : Icons.play_arrow),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    widget.previewUrls.isEmpty
                        ? 'No previews available'
                        : 'Preview ${_idx + 1}/${widget.previewUrls.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Próximo',
              onPressed: !_ready ? null : _player.seekToNext,
              icon: const Icon(Icons.skip_next),
            ),
          ],
        ),
      ),
    );
  }
}

