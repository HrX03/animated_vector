import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/sequence.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A widget that displays and animates an [AnimatedVectorData] instance.
/// It's an approximate parallel to flutter's built-in [AnimatedIcon].
///
/// For more complex usecases (like looping animations or sequences) look into
/// [AnimatedSequence] as it allows for far more powerful setup of animations.
class AnimatedVector extends StatelessWidget {
  /// The [AnimatedVectorData] to animate.
  /// Some bundled-in vectors can be found in [AnimatedVectors].
  final AnimatedVectorData vector;

  /// The animation progress, ranges from 0.0 to 1.0.
  /// Usually just the value from an [AnimationController].
  ///
  /// It's recommended to pass in linearly changing animations as the animations
  /// can apply curves to specific parts of themselves and having curved animation
  /// values can distort the output of the animation.
  final Animation<double> progress;

  /// The size at which to render the animation to.
  /// This overrides the value specified in the data [AnimatedVectorData.viewportSize].
  ///
  /// It's recommended to use multiples of the viewport size.
  final Size? size;

  /// Whether to apply a custom color over the [vector].
  /// It's recommended to use this on vectors that have flat colors.
  ///
  /// By default the color from the context's [IconThemeData] is used,
  /// refer to [color] to set a custom one.
  final bool applyTheme;

  /// A color to use to color the entire vector, discarding any color variation
  /// present in the animation itself.
  ///
  /// [applyTheme] needs to be true for this to work properly.
  final Color? color;

  /// The blend mode to use when applying a color when [applyTheme] is set to true.
  /// Defaults to [BlendMode.srcIn]
  final BlendMode blendMode;

  /// Creates a new instance of [AnimatedVector].
  const AnimatedVector({
    required this.vector,
    required this.progress,
    this.applyTheme = false,
    this.color,
    this.blendMode = BlendMode.srcIn,
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
            blendMode: blendMode,
            colorOverride: applyTheme
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
  final BlendMode blendMode;
  final Color? colorOverride;

  const _AnimatedVectorPainter({
    required this.vector,
    required this.progress,
    required this.blendMode,
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
            blendMode,
          ),
      );
    }

    vector.paint(
      canvas,
      vector.viewportSize,
      progress,
      vector.duration,
      Matrix4.identity(),
    );

    if (colorOverride != null) canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AnimatedVectorPainter old) {
    return vector != old.vector ||
        progress != old.progress ||
        colorOverride != old.colorOverride ||
        blendMode != old.blendMode;
  }
}

/// A controller passed to [AnimatedSequence] to control the execution flow of
/// its sequence.
///
/// A controller can be attached to a single sequence at a time.
class AnimatedSequenceController {
  /// Create a new instance of [AnimatedSequenceController].
  AnimatedSequenceController();

  _AnimatedSequenceState? _state;

  void _attach(_AnimatedSequenceState state) {
    assert(
      _state == null,
      "The controller is already attached to an AnimatedSequence",
    );

    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Skips to the next item in the sequence, discarding any repetitions left for
  /// the current playing item.
  /// Should be used when the sequence is stopped as in that case it's synonymous
  /// with 'play'.
  ///
  /// Group repetitions are respected, and as such to get out of a group use
  /// [jumpTo] with a tag that points to an item outside of said group.
  void skip() {
    _state?.skip();
  }

  /// Stops the currently playing animation if any, else makes sure the sequence
  /// doesn't play additional items.
  /// The current animation will play until it completes the current iteration.
  void stop() {
    _state?._stopSignaled = true;
  }

  /// Jump to the sequence item in the sequence with the specified [tag].
  ///
  /// It throws [UnknownSequenceTagException] if the specified tag is not found
  /// in any item inside the sequence.
  /// When a tag is not found the animation will continue to play normally, ignoring the call.
  void jumpTo(String tag) {
    _state?.skip(tag: tag);
  }
}

/// A widget to play a sequence of [AnimatedVectorData] in a controlled manner.
/// The widget uses a [SequenceMachine] under the hood.
///
/// Requires a list of [SequenceEntry]s to animate and an
/// [AnimatedSequenceController] to control the overall animation flow.
class AnimatedSequence extends StatefulWidget {
  /// A list of [SequenceEntry]s to animate, usually an instance of either
  /// [SequenceItem] or [SequenceGroup].
  ///
  /// It's recommended to use [AnimatedVectorData]s in this sequence that have
  /// the same viewport aspect ratio to avoid stretched animations.
  final List<SequenceEntry> items;

  /// The [AnimatedSequenceController] to use to control the sequence flow.
  /// The instance passed must not change once it has been attached.
  final AnimatedSequenceController controller;

  /// Whether the sequence should start once the widget is built.
  /// If set to false, the animation will start at time 0 of the first sequence item
  /// that can be resolved.
  ///
  /// To manually start the animation call [AnimatedSequenceController.skip] or
  /// [AnimatedSequenceController.jumpTo] on this widget's [controller].
  ///
  /// Defaults to true.
  final bool autostart;

  /// The size at which to render the animation to.
  /// This overrides the value specified in the data [AnimatedVectorData.viewportSize].
  ///
  /// It's recommended to use multiples of the viewport size.
  final Size? size;

  /// Whether to apply a custom color over the [items].
  /// It's recommended to use this on vectors that have flat colors.
  ///
  /// If [colorOverride] is null and the current item has no color override
  /// then the color from the context's [IconThemeData] is used.
  ///
  /// Defaults to false.
  final bool applyTheme;

  /// A color to use to color the entire vector, discarding any color variation
  /// present in the animation itself.
  ///
  /// Applies to every item in the sequence, discarding any color specified
  /// in [SequenceItem.colorOverride].
  ///
  /// Unlike [AnimatedVector], this property will apply even if [applyTheme]
  /// is set to false.
  final Color? colorOverride;

  /// The blend mode to use when applying a color override.
  ///
  /// Applies to every item in the sequence, discarding any blend mode specified
  /// in [SequenceItem.blendMode].
  ///
  /// Defaults to [BlendMode.srcIn]
  final BlendMode? blendMode;

  /// Create a new instance of [AnimatedSequence].
  const AnimatedSequence({
    required this.items,
    required this.controller,
    this.autostart = true,
    this.size,
    this.applyTheme = false,
    this.colorOverride,
    this.blendMode,
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
    widget.controller._attach(this);
    _animationController.addStatusListener(_animationStatusListener);
    if (widget.autostart) tick();
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_animationStatusListener);
    _animationController.removeStatusListener(_waitForSkip);
    widget.controller._detach();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedSequence old) {
    assert(
      widget.controller == old.controller,
      "Can't change the controller instance at runtime",
    );

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
      throw UnknownSequenceTagException(tag);
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
      blendMode:
          widget.blendMode ?? _machine.currentItem.blendMode ?? BlendMode.srcIn,
      applyTheme: widget.applyTheme || color != null,
    );
  }
}

/// An exception thrown by [AnimatedSequenceController.jumpTo] when the specified
/// tag can't be found inside the sequence referenced by its [AnimatedSequence] widget.
class UnknownSequenceTagException implements Exception {
  /// The tag that couldn't be found.
  final String tag;

  /// Build a new instance of [UnknownSequenceTagException] with the specified [tag].
  const UnknownSequenceTagException(this.tag);

  @override
  String toString() {
    return "Tag not found in sequence: $tag";
  }
}
