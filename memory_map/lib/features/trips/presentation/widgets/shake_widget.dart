import 'dart:math';
import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    super.key,
    required this.child,
    this.shakeOffset = 6.0,
    this.shakeCount = 3,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration duration;

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Starts the shake animation.
  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = _controller.value;
        if (progress == 0.0) return child!;
        
        // Sine wave for shaking effect
        // We multiply by (1.0 - progress) to decay the shake towards the end
        final double sineValue = sin(progress * widget.shakeCount * 2 * pi);
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset * (1.0 - progress), 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
