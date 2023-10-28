import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/extensions.dart';
import 'package:animated_vector/src/path.dart';
import 'package:collection/collection.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

typedef AnimationPropertySequence<T> = List<AnimationProperty<T>>;

abstract class AnimationProperties<T extends VectorElement> {
  const AnimationProperties();

  void checkForValidity() {
    if (checkedFields.every(checkForIntervalsValidity)) return;

    throw Exception("Intervals are invalid for these properties");
  }

  List<AnimationPropertySequence?> get checkedFields;

  static bool checkForIntervalsValidity(AnimationPropertySequence? properties) {
    if (properties == null) return true;

    Duration lastValidEndDuration = Duration.zero;

    for (final AnimationProperty property in properties) {
      if (property.interval.start < lastValidEndDuration) return false;

      lastValidEndDuration = property.interval.end;
    }

    return true;
  }

  static T getNearestDefaultForTween<T>(
    AnimationPropertySequence<T> properties,
    int startIndex,
    T defaultValue, {
    bool goDown = false,
  }) {
    final List<ConstTween<T>> tweens = properties.map((p) => p.tween).toList();
    T? value;

    for (int i = startIndex;
        goDown ? i > 0 : i < properties.length;
        goDown ? i-- : i++) {
      if (value != null) break;
      value ??= goDown
          ? tweens.getOrNull(i - 1)?.end
          : tweens.getOrNull(i + 1)?.begin;
    }

    return value ?? defaultValue;
  }
}

class RootVectorAnimationProperties
    extends AnimationProperties<RootVectorElement> {
  final AnimationPropertySequence<double>? alpha;

  const RootVectorAnimationProperties({this.alpha});

  @override
  List<AnimationPropertySequence?> get checkedFields => [alpha];

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

class ClipPathAnimationProperties extends AnimationProperties<ClipPathElement> {
  final AnimationPropertySequence<PathData>? pathData;

  const ClipPathAnimationProperties({this.pathData});

  @override
  List<AnimationPropertySequence?> get checkedFields => [pathData];

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

  T evaluate(T defaultValue, Duration baseDuration, double t) {
    final Curve c = calculateIntervalCurve(baseDuration);

    final double curvedT = c.transform(t);
    final resolvedTween = tween.copyWithDefaults(defaultValue, defaultValue);
    return resolvedTween.transform(curvedT);
  }

  Interval calculateIntervalCurve(Duration baseDuration) {
    final int start =
        interval.start.inMilliseconds.clamp(0, baseDuration.inMilliseconds);
    final int end =
        interval.end.inMilliseconds.clamp(0, baseDuration.inMilliseconds);

    return Interval(
      start / baseDuration.inMilliseconds,
      end / baseDuration.inMilliseconds,
      curve: curve,
    );
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

  bool isBetween(double value, Duration baseDuration) {
    final List<double> resolved = resolve(baseDuration);
    final double start = resolved.first;
    final double end = resolved.last;

    return value >= start && value <= end;
  }

  List<double> resolve(Duration baseDuration) {
    return [
      start.inMilliseconds.clamp(0, baseDuration.inMilliseconds) /
          baseDuration.inMilliseconds,
      end.inMilliseconds.clamp(0, baseDuration.inMilliseconds) /
          baseDuration.inMilliseconds,
    ];
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

class AnimationTimeline<T> {
  final AnimationPropertySequence<T?> timeline;
  final Duration baseDuration;
  final T? defaultValue;

  const AnimationTimeline(
    this.timeline,
    this.baseDuration,
    this.defaultValue,
  );

  T? evaluate(double t) {
    final AnimationProperty<T?>? matchingProperty = timeline.firstWhereOrNull(
      (element) => element.interval.isBetween(t, baseDuration),
    );
    T? beginDefaultValue;
    T? endDefaultValue;

    if (matchingProperty == null) {
      for (int i = timeline.length - 1; i >= 0; i--) {
        final AnimationProperty<T?> property = timeline[i];

        final List<double> resolved = property.interval.resolve(baseDuration);
        final double end = resolved.last;
        final interval = t - end;
        if (!interval.isNegative) {
          return property.tween.end ??
              AnimationProperties.getNearestDefaultForTween(
                timeline,
                i,
                defaultValue,
                goDown: true,
              ) ??
              defaultValue;
        }
      }

      return defaultValue;
    } else {
      final int indexOf = timeline.indexOf(matchingProperty);
      if (indexOf != 0) {
        beginDefaultValue = AnimationProperties.getNearestDefaultForTween(
          timeline,
          indexOf,
          defaultValue,
          goDown: true,
        );
        endDefaultValue = AnimationProperties.getNearestDefaultForTween(
          timeline,
          indexOf,
          defaultValue,
        );
      }
    }

    beginDefaultValue ??= defaultValue;
    endDefaultValue ??= defaultValue;

    final List<double> resolved =
        matchingProperty.interval.resolve(baseDuration);
    final double begin = resolved.first;
    final double end = resolved.last;
    final newT = ((t - begin) / (end - begin)).clamp(0.0, 1.0);
    final resolvedTween = matchingProperty.tween
        .copyWithDefaults(beginDefaultValue, endDefaultValue);

    return resolvedTween.transform(matchingProperty.curve.transform(newT))!;
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

class ConsteColorTween extends ConstTween<Color> {
  const ConsteColorTween({super.begin, super.end});

  @override
  Color transform(double t) {
    assert(begin != null);
    assert(end != null);

    return Color.lerp(begin, end, t)!;
  }

  @override
  ConsteColorTween copyWithDefaults(Color begin, Color end) {
    return ConsteColorTween(
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
