import 'package:animated_vector/src/animation.dart';
import 'package:animated_vector/src/extensions.dart';
import 'package:collection/collection.dart';

bool checkForIntervalsValidity(AnimationPropertySequence? properties) {
  if (properties == null) return true;

  Duration lastValidEndDuration = Duration.zero;

  for (final AnimationProperty property in properties) {
    if (property.interval.start < lastValidEndDuration) return false;

    lastValidEndDuration = property.interval.end;
  }

  return true;
}

T getNearestDefaultForTween<T>(
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
    value ??=
        goDown ? tweens.getOrNull(i - 1)?.end : tweens.getOrNull(i + 1)?.begin;
  }

  return value ?? defaultValue;
}

T? timelineEvaluate<T>({
  required AnimationPropertySequence<T?> propertySequence,
  required Duration animationDuration,
  required double progress,
  T? defaultValue,
}) {
  final AnimationProperty<T?>? matchingProperty =
      propertySequence.firstWhereOrNull(
    (e) => e.interval.hasValueInside(progress, animationDuration),
  );
  T? beginDefaultValue;
  T? endDefaultValue;

  if (matchingProperty == null) {
    for (int i = propertySequence.length - 1; i >= 0; i--) {
      final AnimationProperty<T?> property = propertySequence[i];

      final (_, end) =
          property.interval.normalizeWithDuration(animationDuration);
      final interval = progress - end;
      if (!interval.isNegative) {
        return property.tween.end ??
            getNearestDefaultForTween(
              propertySequence,
              i,
              defaultValue,
              goDown: true,
            ) ??
            defaultValue;
      }
    }

    return defaultValue;
  } else {
    final int indexOf = propertySequence.indexOf(matchingProperty);
    if (indexOf != 0) {
      beginDefaultValue = getNearestDefaultForTween(
        propertySequence,
        indexOf,
        defaultValue,
        goDown: true,
      );
      endDefaultValue = getNearestDefaultForTween(
        propertySequence,
        indexOf,
        defaultValue,
      );
    }
  }

  beginDefaultValue ??= defaultValue;
  endDefaultValue ??= defaultValue;

  final (begin, end) =
      matchingProperty.interval.normalizeWithDuration(animationDuration);
  final newT = ((progress - begin) / (end - begin)).clamp(0.0, 1.0);
  final resolvedTween = matchingProperty.tween
      .copyWithDefaults(beginDefaultValue, endDefaultValue);

  return resolvedTween.transform(matchingProperty.curve.transform(newT));
}

class AnimationPropertyEvaluator {
  final Duration animationDuration;
  final double progress;

  const AnimationPropertyEvaluator(this.animationDuration, this.progress);

  T? evaluate<T>(
    AnimationPropertySequence<T?>? properties,
    T? defaultValue,
  ) {
    if (properties == null || properties.isEmpty) return defaultValue;

    return timelineEvaluate(
      propertySequence: properties,
      animationDuration: animationDuration,
      progress: progress,
      defaultValue: defaultValue,
    );
  }
}
