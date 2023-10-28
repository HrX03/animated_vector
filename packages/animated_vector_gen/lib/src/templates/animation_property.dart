import 'package:animated_vector_gen/src/templates/template.dart';
import 'package:animated_vector_gen/src/templates/utils.dart';

class AnimationPropertyTemplate<T> extends Template {
  final TweenTemplate<T> tween;
  final ValueType type;
  final int? start;
  final int end;
  final String? curve;

  const AnimationPropertyTemplate({
    required this.tween,
    required this.type,
    required this.start,
    required this.end,
    required this.curve,
  });

  @override
  String? build() {
    return buildConstructorCall("AnimationProperty<${type.typeName}>", {
      "tween": tween,
      "interval": buildConstructorCall("AnimationInterval", {
        "start": start != null && start! > 0
            ? "Duration(milliseconds: $start)"
            : null,
        "end": "Duration(milliseconds: $end)",
      }),
      "curve": curve,
    });
  }
}

class TweenTemplate<T> extends Template {
  final ValueType type;
  final T? begin;
  final T? end;

  const TweenTemplate({
    required this.type,
    required this.begin,
    required this.end,
  });

  @override
  String? build() {
    return buildConstructorCall(type.className, {
      "begin": wrapWithConstructor(begin, type),
      "end": wrapWithConstructor(end, type),
    });
  }
}
