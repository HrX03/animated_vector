import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/sequence.dart';
import 'package:flutter/material.dart';

class AnimatedVector extends StatelessWidget {
  final AnimatedVectorData vector;
  final Animation<double> progress;
  final Size? size;
  final Color? color;
  final bool applyColor;

  const AnimatedVector({
    required this.vector,
    required this.progress,
    this.color,
    this.applyColor = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        return CustomPaint(
          painter: _AnimatedVectorPainter(
            vector: vector,
            progress: progress.value,
            colorOverride: applyColor
                ? color ?? Theme.of(context).iconTheme.color ?? Colors.black
                : null,
          ),
          isComplex: true,
          child: SizedBox.fromSize(size: size ?? vector.viewportSize),
        );
      },
    );
  }
}

class _AnimatedVectorPainter extends CustomPainter {
  final AnimatedVectorData vector;
  final double progress;
  final Color? colorOverride;

  const _AnimatedVectorPainter({
    required this.vector,
    required this.progress,
    this.colorOverride,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(
      size.width / vector.viewportSize.width,
      size.height / vector.viewportSize.height,
    );

    if (colorOverride != null) {
      canvas.saveLayer(
        null,
        Paint()
          ..colorFilter = ColorFilter.mode(
            colorOverride!,
            BlendMode.srcIn,
          ),
      );
    }
    vector.root.paint(canvas, vector.viewportSize, progress, vector.duration);
    if (colorOverride != null) canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AnimatedVectorPainter old) {
    return vector != old.vector ||
        progress != old.progress ||
        colorOverride != old.colorOverride;
  }
}

class AnimatedSequenceController {
  _AnimatedSequenceState? _state;

  void skip() {
    _state?.skip();
  }

  void stop() {
    _state?._stopSignaled = true;
  }
}

class AnimatedSequence extends StatefulWidget {
  final List<BaseSequenceItem> items;
  final AnimatedSequenceController controller;
  final bool autostart;

  const AnimatedSequence({
    required this.items,
    required this.controller,
    this.autostart = true,
    super.key,
  });

  @override
  State<AnimatedSequence> createState() => _AnimatedSequenceState();
}

class _AnimatedSequenceState extends State<AnimatedSequence>
    with SingleTickerProviderStateMixin {
  late final _machine = SequenceMachine(widget.items);
  late final AnimationController _animationController =
      AnimationController(vsync: this);

  bool _stopSignaled = false;
  bool _waitingForSkip = false;

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    _animationController.addStatusListener(_animationStatusListener);
    if (widget.autostart) tick();
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_animationStatusListener);
    _animationController.removeStatusListener(_waitForSkip);
    super.dispose();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    if (!_stopSignaled) tick();

    _stopSignaled = false;
  }

  void tick() {
    final shouldAnimate = _machine.tick();
    if (!shouldAnimate) return;

    _animationController.value = 0;
    _animationController.duration = _machine.currentItem.data.duration;
    setState(() {});
    _animationController.forward();
  }

  void skip([bool forceSkip = false]) {
    if (!_machine.currentItem.skipMidAnimation &&
        !forceSkip &&
        _animationController.isAnimating) {
      if (_waitingForSkip) return;
      _waitingForSkip = true;
      _animationController.addStatusListener(_waitForSkip);
      return;
    }

    _machine.skip();
    _animationController.value = 0;
    _animationController.duration = _machine.currentItem.data.duration;
    setState(() {});
    _animationController.forward();
  }

  void _waitForSkip(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    skip(true);
    _animationController.removeStatusListener(_waitForSkip);
    _waitingForSkip = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedVector(
      vector: _machine.currentItem.data,
      progress: _animationController,
    );
  }
}
