import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/path.dart';
import 'package:animated_vector/src/utils.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

typedef AnimationPropertySequence<T> = List<AnimationProperty<T>>;

abstract class AnimationProperties<T extends VectorElement> {
  const AnimationProperties();

  void ensureIntervalAreValid() {
    for (final field in checkedFields) {
      assert(
        checkForIntervalsValidity(field),
        "The animation intervals for this $runtimeType object are not valid. "
        "Usually this means two or more intervals overlap with each other, "
        "causing ambiguites over which value to pick.",
      );
    }
  }

  List<AnimationPropertySequence?> get checkedFields;
  Record evaluate(double progress, Duration animationDuration);
}

typedef EvaluatedRootVectorAnimationProperties = ({double? alpha});

class RootVectorAnimationProperties
    extends AnimationProperties<RootVectorElement> {
  final AnimationPropertySequence<double>? alpha;

  const RootVectorAnimationProperties({this.alpha});

  @override
  List<AnimationPropertySequence?> get checkedFields => [alpha];

  @override
  EvaluatedRootVectorAnimationProperties evaluate(
    double progress,
    Duration animationDuration, {
    double? defaultAlpha,
  }) {
    ensureIntervalAreValid();
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

typedef EvaluatedGroupAnimationProperties = ({
  double? translateX,
  double? translateY,
  double? scaleX,
  double? scaleY,
  double? pivotX,
  double? pivotY,
  double? rotation,
});

class GroupAnimationProperties extends AnimationProperties<GroupElement> {
  final AnimationPropertySequence<double>? translateX;
  final AnimationPropertySequence<double>? translateY;
  final AnimationPropertySequence<double>? scaleX;
  final AnimationPropertySequence<double>? scaleY;
  final AnimationPropertySequence<double>? pivotX;
  final AnimationPropertySequence<double>? pivotY;
  final AnimationPropertySequence<double>? rotation;

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
    ensureIntervalAreValid();
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

class PathAnimationProperties extends AnimationProperties<PathElement> {
  final AnimationPropertySequence<PathData>? pathData;
  final AnimationPropertySequence<Color?>? fillColor;
  final AnimationPropertySequence<double>? fillAlpha;
  final AnimationPropertySequence<Color?>? strokeColor;
  final AnimationPropertySequence<double>? strokeAlpha;
  final AnimationPropertySequence<double>? strokeWidth;
  final AnimationPropertySequence<double>? trimStart;
  final AnimationPropertySequence<double>? trimEnd;
  final AnimationPropertySequence<double>? trimOffset;

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
    ensureIntervalAreValid();
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

typedef EvaluatedClipPathAnimationProperties = ({PathData? pathData});

class ClipPathAnimationProperties extends AnimationProperties<ClipPathElement> {
  final AnimationPropertySequence<PathData>? pathData;

  const ClipPathAnimationProperties({this.pathData});

  @override
  List<AnimationPropertySequence?> get checkedFields => [pathData];

  @override
  EvaluatedClipPathAnimationProperties evaluate(
    double progress,
    Duration animationDuration, {
    PathData? defaultPathData,
  }) {
    ensureIntervalAreValid();
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

class AnimationProperty<T> {
  final ConstTween<T> tween;
  final AnimationInterval interval;
  final Curve curve;

  const AnimationProperty({
    required this.tween,
    required this.interval,
    this.curve = Curves.linear,
  });

  T evaluate(T defaultValue, Duration animationDuration, double progress) {
    final Curve c =
        animationIntervalToFlutterInterval(interval, animationDuration, curve);

    final double curvedT = c.transform(progress);
    final resolvedTween = tween.copyWithDefaults(defaultValue, defaultValue);
    return resolvedTween.transform(curvedT);
  }

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

class AnimationInterval {
  final Duration start;
  final Duration end;

  const AnimationInterval({
    this.start = Duration.zero,
    required this.end,
  });

  AnimationInterval.withDuration({
    Duration startOffset = Duration.zero,
    required Duration duration,
  })  : start = startOffset,
        end = Duration(
          microseconds: startOffset.inMicroseconds + duration.inMicroseconds,
        );

  bool hasValueInside(double progress, Duration animationDuration) {
    final (start, end) = normalizeWithDuration(animationDuration);

    return progress >= start && progress <= end;
  }

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

class ConstTween<T> extends Animatable<T> {
  final T? begin;
  final T? end;

  const ConstTween({
    this.begin,
    this.end,
  });

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

  ConstTween<T> copyWithDefaults(T begin, T end) {
    return ConstTween<T>(
      begin: this.begin ?? begin,
      end: this.end ?? end,
    );
  }
}

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
