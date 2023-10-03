import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/sequence.dart';
import 'package:collection/collection.dart';
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

  void jumpTo(String tag) {
    _state?.skip(tag: tag);
  }
}

class AnimatedSequence extends StatefulWidget {
  final List<SequenceEntry> items;
  final AnimatedSequenceController controller;
  final bool autostart;
  final Size? size;
  final Color? colorOverride;
  final bool applyColor;

  const AnimatedSequence({
    required this.items,
    required this.controller,
    this.autostart = true,
    this.size,
    this.colorOverride,
    this.applyColor = false,
    super.key,
  });

  @override
  State<AnimatedSequence> createState() => _AnimatedSequenceState();
}

class _AnimatedSequenceState extends State<AnimatedSequence>
    with SingleTickerProviderStateMixin {
  late List<SequenceEntry> _items = List.of(widget.items);
  late SequenceMachine _machine = SequenceMachine(_items);
  late final AnimationController _animationController =
      AnimationController(vsync: this);

  bool _stopSignaled = false;
  bool _waitingForSkip = false;
  String? _requestedTag;

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

  @override
  void didUpdateWidget(covariant AnimatedSequence old) {
    const equality = ListEquality();
    if (!equality.equals(_items, old.items)) {
      _items = List.of(widget.items);
      _machine = SequenceMachine(_items);

      _stopSignaled = false;
      _waitingForSkip = false;
      _requestedTag = null;

      if (widget.autostart) tick();
    }
    super.didUpdateWidget(old);
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

  void skip({String? tag, bool forceSkip = false}) {
    if (tag != null && !_machine.hasTag(tag)) {
      throw Exception("Tag not found in sequence: $tag");
    }

    if (!_machine.currentItem.skipMidAnimation &&
        !forceSkip &&
        _animationController.isAnimating) {
      if (_waitingForSkip) return;
      _waitingForSkip = true;
      _requestedTag = tag;
      _animationController.addStatusListener(_waitForSkip);
      return;
    }

    if (tag != null) {
      _machine.jumpTo(tag);
    } else {
      _machine.skip();
    }

    _animationController.value = 0;
    _animationController.duration = _machine.currentItem.data.duration;
    setState(() {});
    _animationController.forward();
  }

  void _waitForSkip(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    skip(tag: _requestedTag, forceSkip: true);
    _requestedTag = null;

    _animationController.removeStatusListener(_waitForSkip);
    _waitingForSkip = false;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.colorOverride ?? _machine.currentItem.colorOverride;
    return AnimatedVector(
      vector: _machine.currentItem.data,
      progress: _animationController,
      size: widget.size,
      color: color,
      applyColor: widget.applyColor || color != null,
    );
  }
}
