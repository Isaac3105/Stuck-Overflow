import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/media.dart';
import 'home_providers.dart';

class StoryPlayerPage extends StatefulWidget {
  const StoryPlayerPage({super.key, required this.featured});
  final FeaturedTripData featured;

  @override
  State<StoryPlayerPage> createState() => _StoryPlayerPageState();
}

class _StoryPlayerPageState extends State<StoryPlayerPage> {
  final _page = PageController();
  final _player = AudioPlayer();
  Timer? _timer;
  int _index = 0;
  bool _paused = false;

  List<MediaItem> get _photos => widget.featured.photos;
  List<MediaItem> get _audios => widget.featured.audios;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startAudio();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 4), () {
      if (_paused) {
        _startTimer(); // Check again later
        return;
      }
      _nextPage();
    });
  }

  Future<void> _startAudio() async {
    if (_audios.isEmpty) return;
    final sources = <AudioSource>[];
    for (final a in _audios.take(3)) {
      sources.add(AudioSource.file(a.filePath));
    }
    try {
      await _player.setAudioSource(ConcatenatingAudioSource(children: sources));
      await _player.setLoopMode(LoopMode.off);
      await _player.play();
    } catch (_) {
      // If audio file missing, ignore.
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    _player.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (!mounted) return;
    final next = _index + 1;
    if (next >= _photos.length) {
      Navigator.of(context).pop();
      return;
    }
    _page.animateToPage(
      next,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    setState(() => _index = next);
    _startTimer(); // Restart timer
    if (_player.hasNext) {
      _player.seekToNext();
    }
  }

  void _previousPage() {
    if (!mounted) return;
    if (_index <= 0) return;
    final prev = _index - 1;
    _page.animateToPage(
      prev,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    setState(() => _index = prev);
    _startTimer(); // Restart timer
    if (_player.hasPrevious) {
      _player.seekToPrevious();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _page,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _photos.length,
              itemBuilder: (context, i) {
                final p = _photos[i];
                return Image.file(
                  File(p.filePath),
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, st) => const Center(
                    child: Icon(Icons.broken_image,
                        color: Colors.white, size: 80),
                  ),
                );
              },
            ),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) {
                  final width = MediaQuery.of(context).size.width;
                  final dx = details.localPosition.dx;
                  if (dx < width / 3) {
                    _previousPage();
                  } else {
                    _nextPage();
                  }
                },
                onLongPress: () {
                  setState(() => _paused = true);
                  _player.pause();
                },
                onLongPressUp: () {
                  setState(() => _paused = false);
                  _player.play();
                },
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 12,
              child: _ProgressRow(count: _photos.length, index: _index),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 3,
              decoration: BoxDecoration(
                color: i <= index
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
      ],
    );
  }
}

