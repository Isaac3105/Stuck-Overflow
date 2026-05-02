import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/media_capture_service.dart';

class AudioRecorderButton extends ConsumerStatefulWidget {
  const AudioRecorderButton({
    super.key,
    required this.tripId,
    this.dayId,
    this.activityBlockId,
    this.label = 'Record audio',
    this.onRecorded,
    this.enabled = true,
  });

  final String tripId;
  final String? dayId;
  final String? activityBlockId;
  final String label;
  final ValueChanged<String /* mediaId */>? onRecorded;
  final bool enabled;

  @override
  ConsumerState<AudioRecorderButton> createState() =>
      _AudioRecorderButtonState();
}

class _AudioRecorderButtonState extends ConsumerState<AudioRecorderButton> {
  bool _recording = false;
  bool _busy = false;
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_busy) return;
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(audioRecorderControllerProvider);
    setState(() => _busy = true);
    try {
      if (!_recording) {
        final ok = await controller.start(widget.tripId);
        if (!ok) {
          messenger.showSnackBar(
            const SnackBar(content: Text('No microphone permission.')),
          );
          return;
        }
        setState(() {
          _recording = true;
          _elapsed = Duration.zero;
        });
        _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            setState(() => _elapsed += const Duration(seconds: 1));
          }
        });
      } else {
        _ticker?.cancel();
        final media = await controller.stop(
          tripId: widget.tripId,
          dayId: widget.dayId,
          activityBlockId: widget.activityBlockId,
        );
        if (!mounted) return;
        setState(() {
          _recording = false;
          _elapsed = Duration.zero;
        });
        if (media != null) {
          widget.onRecorded?.call(media.id);
          messenger.showSnackBar(
            const SnackBar(content: Text('Audio saved.')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton.icon(
      onPressed: widget.enabled ? _toggle : null,
      style: FilledButton.styleFrom(
        backgroundColor: _recording ? scheme.error : scheme.primary,
        foregroundColor:
            _recording ? scheme.onError : scheme.onPrimary,
      ),
      icon: Icon(_recording ? Icons.stop : Icons.mic),
      label: Text(_recording ? 'Recording… ${_fmt(_elapsed)}' : widget.label),
    );
  }
}
