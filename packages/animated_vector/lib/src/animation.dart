import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/path.dart';
import 'package:animated_vector/src/utils.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// A sequence of [AnimationProperty] of a specific type.
/// Each entry should have an [AnimationInterval] that doesn't overlap with any
/// other entries in the same sequence as that would throw an assertion.
/// Used in [AnimationProperties] subclasses.
///
/// Maps to `List<AnimationProperty<T>>`.
typedef AnimationPropertySequence<T> = List<AnimationProperty<T>>;

/// Abstract base class for a group of properties that can be animated.
/// Each subclass should be paired to a specific [VectorElement] subclass.
///
/// Usually fields of this class are of type [AnimationPropertySequence].
///
/// The library subclasses are as follows:
/// - [RootVectorAnimationProperties] for [RootVectorElement]
/// - [GroupAnimationProperties] for [GroupElement]
/// - [PathAnimationProperties] for [PathElement]
/// - [ClipPathAnimationProperties] for [ClipPathElement]
abstract class AnimationProperties {
  /// Base const constructor, allows subclasses to define const constructors.
  const AnimationProperties();

  /// Make sure every interval in this properties sequences is valid.
  /// Intervals are valid when they don't overlap with each other in the same sequence.
  void ensureIntervalsAreValid() {
    for (final field in checkedFields) {
      assert(
        checkForIntervalsValidity(field),
        "The animation intervals for this $runtimeType object are not valid. "
        "Usually this means two or more intervals overlap with each other, "
        "causing ambiguites over which value to pick.",
      );
    }
  }

  /// A list of sequences that will be checked in [ensureIntervalsAreValid].
  /// Usually every sequence field will be added to this.
  List<AnimationPropertySequence?> get checkedFields;

  /// Evaluate the various sequences and collapse them to a
  /// single value based on the [progress] passed in.
  /// The return value is a `Record` that contains each field resolved value.
  ///
  /// Usually subclasses will have a list of optional named parameters for this
  /// method that allows to pass in default values for each sequence as they could
  /// potentially collapse to `null` values. If default values are passed in
  /// usually the user expects said field to be non null.
  ///
  /// The parameter [animationDuration] is the duration from the source [AnimatedVectorData].
  ///
  /// It would be useful for implementers to refer to builtin properties subclasses
  /// implementations like [PathAnimationProperties.evaluate] and [EvaluatedPathAnimationProperties].
  Record evaluate(double progress, Duration animationDuration);
}

/// Evaluated data for [RootVectorAnimationProperties].
///
/// An instance of this typedef is returned by [RootVectorAnimationProperties.evaluate].
typedef EvaluatedRootVectorAnimationProperties = ({double? alpha});

/// An [AnimationProperties] subclass for [RootVectorElement].
///
/// It allows to animate the [RootVectorElement.alpha] property.
class RootVectorAnimationProperties extends AnimationProperties {
  /// A sequence of properties to animate [RootVectorElement.alpha].
  final AnimationPropertySequence<double>? alpha;

  /// Build a new instance of [RootVectorAnimationProperties].
  const RootVectorAnimationProperties({this.alpha});

  @override
  List<AnimationPropertySequence?> get checkedFields => [alpha];

  @override
  EvaluatedRootVectorAnimationProperties evaluate(
    double progress,
    Duration animationDuration, {
    double? defaultAlpha,
  }) {
    ensureIntervalsAreValid();
    final evaluator = AnimationPropertyEvaluator(animationDuration, progress);

    return (alpha: evaluator.evaluate(alpha, defaultAlpha),);
  }

  @override
  int get hashCode => Object.hashAll(checkedFields);

  @override
  bool operator ==(Object other) {
    if (other is RootVectorAnimationProperties) {
      return listEquals(alpha, other.alpha);
    }

    return false;
  }
}

/// Evaluated data for [GroupAnimationProperties].
///
/// An instance of this typedef is returned by [GroupAnimationProperties.evaluate].
typedef EvaluatedGroupAnimationProperties = ({
  double? translateX,
  double? translateY,
  double? scaleX,
  double? scaleY,
  double? pivotX,
  double? pivotY,
  double? rotation,
});

/// An [AnimationProperties] subclass for [GroupElement].
///
/// It allows to animate various properties of [GroupElement]:
/// - [GroupElement.translateX]
/// - [GroupElement.translateY]
/// - [GroupElement.scaleX]
/// - [GroupElement.scaleY]
/// - [GroupElement.pivotX]
/// - [GroupElement.pivotY]
/// - [GroupElement.rotation]
class GroupAnimationProperties extends AnimationProperties {
  /// A sequence of properties to animate [GroupElement.translateX].
  final AnimationPropertySequence<double>? translateX;

  /// A sequence of properties to animate [GroupElement.translateY].
  final AnimationPropertySequence<double>? translateY;

  /// A sequence of properties to animate [GroupElement.scaleX].
  final AnimationPropertySequence<double>? scaleX;

  /// A sequence of properties to animate [GroupElement.scaleY].
  final AnimationPropertySequence<double>? scaleY;

  /// A sequence of properties to animate [GroupElement.pivotX].
  final AnimationPropertySequence<double>? pivotX;

  /// A sequence of properties to animate [GroupElement.pivotY].
  final AnimationPropertySequence<double>? pivotY;

  /// A sequence of properties to animate [GroupElement.rotation].
  final AnimationPropertySequence<double>? rotation;

  /// Build a new instance of [GroupAnimationProperties].
  const GroupAnimationProperties({
    this.translateX,
    this.translateY,
    this.scaleX,
    this.scaleY,
    this.pivotX,
    this.pivotY,
    this.rotation,
  });

  @override
  List<AnimationPropertySequence?> get checkedFields => [
        translateX,
        translateY,
        scaleX,
        scaleY,
        pivotX,
        pivotY,
        rotation,
      ];

  @override
  EvaluatedGroupAnimationProperties evaluate(
    double progress,
    Duration animationDuration, {
    double? defaultTranslateX,
    double? defaultTranslateY,
    double? defaultScaleX,
    double? defaultScaleY,
    double? defaultPivotX,
    double? defaultPivotY,
    double? defaultRotation,
  }) {
    ensureIntervalsAreValid();
    final evaluator = AnimationPropertyEvaluator(animationDuration, progress);

    return (
      translateX: evaluator.evaluate(translateX, defaultTranslateX),
      translateY: evaluator.evaluate(translateY, defaultTranslateY),
      scaleX: evaluator.evaluate(scaleX, defaultScaleX),
      scaleY: evaluator.evaluate(scaleY, defaultScaleY),
      pivotX: evaluator.evaluate(pivotX, defaultPivotX),
      pivotY: evaluator.evaluate(pivotY, defaultPivotY),
      rotation: evaluator.evaluate(rotation, defaultRotation),
    );
  }

  @override
  int get hashCode => Object.hashAll(checkedFields);

  @override
  bool operator ==(Object other) {
    if (other is GroupAnimationProperties) {
      return listEquals(translateX, other.translateX) &&
          listEquals(translateY, other.translateY) &&
          listEquals(scaleX, other.scaleX) &&
          listEquals(scaleY, other.scaleY) &&
          listEquals(pivotX, other.pivotX) &&
          listEquals(pivotY, other.pivotY) &&
          listEquals(rotation, other.rotation);
    }

    return false;
  }
}

/// Evaluated data for [PathAnimationProperties].
///
/// An instance of this typedef is returned by [PathAnimationProperties.evaluate].
typedef EvaluatedPathAnimationProperties = ({
  PathData? pathData,
  Color? fillColor,
  double? fillAlpha,
  Color? strokeColor,
  double? strokeAlpha,
  double? strokeWidth,
  double? trimStart,
  double? trimEnd,
  double? trimOffset,
});

/// An [AnimationProperties] subclass for [PathElement].
///
/// It allows to animate various properties of [PathElement]:
/// - [PathElement.pathData]
/// - [PathElement.fillCOlor]
/// - [PathElement.fillAlpha]
/// - [PathElement.strokeColor]
/// - [PathElement.strokeAlpha]
/// - [PathElement.strokeWidth]
/// - [PathElement.trimStart]
/// - [PathElement.trimEnd]
/// - [PathElement.trimOffset]
class PathAnimationProperties extends AnimationProperties {
  /// A sequence of properties to animate [PathElement.pathData].
  final AnimationPropertySequence<PathData>? pathData;

  /// A sequence of properties to animate [PathElement.fillColor].
  final AnimationPropertySequence<Color?>? fillColor;

  /// A sequence of properties to animate [PathElement.fillAlpha].
  final AnimationPropertySequence<double>? fillAlpha;

  /// A sequence of properties to animate [PathElement.strokeColor].
  final AnimationPropertySequence<Color?>? strokeColor;

  /// A sequence of properties to animate [PathElement.strokeAlpha].
  final AnimationPropertySequence<double>? strokeAlpha;

  /// A sequence of properties to animate [PathElement.strokeWidth].
  final AnimationPropertySequence<double>? strokeWidth;

  /// A sequence of properties to animate [PathElement.trimStart].
  final AnimationPropertySequence<double>? trimStart;

  /// A sequence of properties to animate [PathElement.trimEnd].
  final AnimationPropertySequence<double>? trimEnd;

  /// A sequence of properties to animate [PathElement.trimOffset].
  final AnimationPropertySequence<double>? trimOffset;

  /// Build a new instance of [PathAnimationProperties].
  const PathAnimationProperties({
    this.pathData,
    this.fillColor,
    this.fillAlpha,
    this.strokeColor,
    this.strokeAlpha,
    this.strokeWidth,
    this.trimStart,
    this.trimEnd,
    this.trimOffset,
  });

  @override
  List<AnimationPropertySequence?> get checkedFields => [
        pathData,
        fillColor,
        fillAlpha,
        strokeColor,
        strokeAlpha,
        strokeWidth,
        trimStart,
        trimEnd,
        trimOffset,
      ];

  @override
  EvaluatedPathAnimationProperties evaluate(
    double progress,
    Duration animationDuration, {
    PathData? defaultPathData,
    Color? defaultFillColor,
    double? defaultFillAlpha,
    Color? defaultStrokeColor,
    double? defaultStrokeAlpha,
    double? defaultStrokeWidth,
    double? defaultTrimStart,
    double? defaultTrimEnd,
    double? defaultTrimOffset,
  }) {
    ensureIntervalsAreValid();
    final evaluator = AnimationPropertyEvaluator(animationDuration, progress);

    return (
      pathData: evaluator.evaluate(pathData, defaultPathData),
      fillColor: evaluator.evaluate(fillColor, defaultFillColor),
      fillAlpha: evaluator.evaluate(fillAlpha, defaultFillAlpha),
      strokeColor: evaluator.evaluate(strokeColor, defaultStrokeColor),
      strokeAlpha: evaluator.evaluate(strokeAlpha, defaultStrokeAlpha),
      strokeWidth: evaluator.evaluate(strokeWidth, defaultStrokeWidth),
      trimStart: evaluator.evaluate(trimStart, defaultTrimStart),
      trimEnd: evaluator.evaluate(trimEnd, defaultTrimEnd),
      trimOffset: evaluator.evaluate(trimOffset, defaultTrimOffset),
    );
  }

  @override
  int get hashCode => Object.hashAll(checkedFields);

  @override
  bool operator ==(Object other) {
    if (other is PathAnimationProperties) {
      return listEquals(pathData, other.pathData) &&
          listEquals(fillColor, other.fillColor) &&
          listEquals(fillAlpha, other.fillAlpha) &&
          listEquals(strokeColor, other.strokeColor) &&
          listEquals(strokeAlpha, other.strokeAlpha) &&
          listEquals(strokeWidth, other.strokeWidth) &&
          listEquals(trimStart, other.trimStart) &&
          listEquals(trimEnd, other.trimEnd) &&
          listEquals(trimOffset, other.trimOffset);
    }

    return false;
  }
}

/// Evaluated data for [ClipPathAnimationProperties].
///
/// An instance of this typedef is returned by [ClipPathAnimationProperties.evaluate].
typedef EvaluatedClipPathAnimationProperties = ({PathData? pathData});

class ClipPathAnimationProperties extends AnimationProperties {
  /// A sequence of properties to animate [ClipPathElement.pathData].
  final AnimationPropertySequence<PathData>? pathData;

  /// Build a new instance of [ClipPathAnimationProperties].
  const ClipPathAnimationProperties({this.pathData});

  @override
  List<AnimationPropertySequence?> get checkedFields => [pathData];

  @override
  EvaluatedClipPathAnimationProperties evaluate(
    double progress,
    Duration animationDuration, {
    PathData? defaultPathData,
  }) {
    ensureIntervalsAreValid();
    final evaluator = AnimationPropertyEvaluator(animationDuration, progress);

    return (pathData: evaluator.evaluate(pathData, defaultPathData),);
  }

  @override
  int get hashCode => Object.hashAll(checkedFields);

  @override
  bool operator ==(Object other) {
    if (other is ClipPathAnimationProperties) {
      return listEquals(pathData, other.pathData);
    }

    return false;
  }
}

/// An animatable property of an [AnimationPropertySequence].
/// Needs a [tween] with at least one of begin or end to be non null.
/// This property will be animated in the period of time defined by [interval].
///
/// An optional [curve] parameter can be passed in.
class AnimationProperty<T> {
  /// The tween that defines the values that need to be interpolated.
  /// One of the two values can be left null, in that case it will be filled by
  /// looking at the nearest non null value in the sequence.
  final ConstTween<T> tween;

  /// The interval of time which defines the period of time this property will be
  /// animated in.
  final AnimationInterval interval;

  /// The curve to use to interpolate the two values. Some default curves can be
  /// found in this library [ShapeShifterCurves] class or in flutter [Curves] class.
  final Curve curve;

  /// Construct a new [AnimationProperty] instance.
  ///
  /// The [curve] parameter is by default [Curves.linear].
  const AnimationProperty({
    required this.tween,
    required this.interval,
    this.curve = Curves.linear,
  });

  @override
  int get hashCode => Object.hash(tween, interval, curve);

  @override
  bool operator ==(Object other) {
    if (other is AnimationProperty) {
      return tween == other.tween &&
          interval == other.interval &&
          curve == other.curve;
    }

    return false;
  }
}

/// An interval of time that defines when an animation starts and when it end.
/// Very similar to flutter [Interval] but instead of using normalized values
/// it instead uses more human friendly [Duration] values.
/// It is nonetheless possible to get normalized values with [normalizeWithDuration].
class AnimationInterval {
  /// The start duration of this interval
  final Duration start;

  /// The end duration of this interval
  final Duration end;

  /// Constructs a new [AnimationInterval] usin ga [start] and [end] durations defined.
  ///
  /// If [start] is omitted it is assumed to start at a time of zero.
  ///
  /// It is very similar in concept to [Rect.fromLTRB], where you build a rect
  /// by its top point and its bottom point.
  const AnimationInterval({
    this.start = Duration.zero,
    required this.end,
  });

  /// Constructs a new [AnimationInterval] using
  /// a start point defined by [startOffset] and a [duration].
  ///
  /// If [startOffset] is omitted it is assumed to start at a time of zero.
  ///
  /// It is very similar in concept to [Rect.fromLTWH], where you build a rect
  /// by its top point and by lengths starting from that point.
  const AnimationInterval.withDuration({
    Duration startOffset = Duration.zero,
    required Duration duration,
  })  : start = startOffset,
        end = startOffset + duration;

  /// Constructs a new [AnimationInterval] with duration zero which starts at [offset].
  const AnimationInterval.instant({required Duration offset})
      : start = offset,
        end = offset;

  /// Simple getter to get the duration of this interval
  Duration get duration => end - start;

  /// Returns true if the passed in [progress] lies in between the normalized
  /// [start] and [end] values. To do so, [animationDuration] is used to normalize
  /// the bounds.
  ///
  /// For example, for an [animationDuration] that lasts 1 second and an [AnimationInterval]
  /// with [start] 500ms and [end] 1000ms any [progress] between 0.5 and 1.0
  /// inclusive will return true, while any other value will return false.
  ///
  /// ```
  /// progress
  ///       vvvvv     0.5 - 1.0
  /// |-----=====|    1000 ms total
  /// timeline
  /// ```
  bool hasValueInside(double progress, Duration animationDuration) {
    final (start, end) = normalizeWithDuration(animationDuration);

    return progress >= start && progress <= end;
  }

  /// Returns a pair of doubles that represents the [start] and [end] values
  /// normalized to the range 0.0 - 1.0 using [animationDuration].
  (double start, double end) normalizeWithDuration(Duration animationDuration) {
    return (
      start.inMicroseconds.clamp(0, animationDuration.inMicroseconds) /
          animationDuration.inMicroseconds,
      end.inMicroseconds.clamp(0, animationDuration.inMicroseconds) /
          animationDuration.inMicroseconds,
    );
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  bool operator ==(Object other) {
    if (other is AnimationInterval) {
      return start == other.start && end == other.end;
    }

    return false;
  }
}

/// A class that is very similar to flutter's [Tween] but has its fields immutable
/// and the constructor is const.
/// Was mainly created to allow for completely consts [AnimatedVectorData] instances.
///
/// It is recommended to call [transform] only from instances created
/// from [copyWithDefaults] to ensure no null value is mistakenly transformed,
/// which would result in an assertion to be throw,
class ConstTween<T> extends Animatable<T> {
  /// The initial value of this tween.
  final T? begin;

  /// The final vaule of this tween.
  final T? end;

  const ConstTween({this.begin, this.end});

  @override
  int get hashCode => Object.hash(begin, end);

  @override
  bool operator ==(Object other) {
    if (other is ConstTween) {
      return begin == other.begin && end == other.end;
    }
    return false;
  }

  @override
  T transform(double t) {
    return Tween<T>(
      begin: begin,
      end: end,
    ).transform(t);
  }

  /// Create a new [ConstTween] instance based on this but with eventual null values
  /// replaced with the ones provided in the arguments of this method.
  ///
  /// Prefer calling [transform] on an instance of [ConstTween] created by this method.
  ConstTween<T> copyWithDefaults(T begin, T end) {
    return ConstTween<T>(
      begin: this.begin ?? begin,
      end: this.end ?? end,
    );
  }
}

/// Specialized subclass of [ConstTween] for tweening between colors.
/// It calls [Color.lerp] inside its [transform] method.
/// Mirrors [ColorTween] from flutter.
class ConstColorTween extends ConstTween<Color> {
  const ConstColorTween({super.begin, super.end});

  @override
  Color transform(double t) {
    assert(begin != null);
    assert(end != null);

    return Color.lerp(begin, end, t)!;
  }

  @override
  ConstColorTween copyWithDefaults(Color begin, Color end) {
    return ConstColorTween(
      begin: this.begin ?? begin,
      end: this.end ?? end,
    );
  }
}

/// Specialized subclass of [ConstTween] for tweening between path data.
/// It calls [PathData.lerp] inside its [transform] method.
class ConstPathDataTween extends ConstTween<PathData> {
  const ConstPathDataTween({super.begin, super.end});

  @override
  PathData transform(double t) {
    assert(begin != null);
    assert(end != null);

    return PathData.lerp(begin!, end!, t);
  }

  @override
  ConstPathDataTween copyWithDefaults(PathData begin, PathData end) {
    return ConstPathDataTween(
      begin: this.begin ?? begin,
      end: this.end ?? end,
    );
  }
}
