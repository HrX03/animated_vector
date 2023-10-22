import 'package:animated_vector_gen/src/templates/animation_property.dart';
import 'package:animated_vector_gen/src/templates/template.dart';
import 'package:animated_vector_gen/src/templates/utils.dart';

class PathElementTemplate extends ElementTemplate {
  final String pathData;
  final int? fillColor;
  final num? fillAlpha;
  final int? strokeColor;
  final num? strokeAlpha;
  final num? strokeWidth;
  final String? strokeCap;
  final String? strokeJoin;
  final num? strokeMiterLimit;
  final num? trimStart;
  final num? trimEnd;
  final num? trimOffset;
  final PathAnimationPropertiesTemplate? properties;

  const PathElementTemplate({
    required this.pathData,
    required this.fillColor,
    required this.fillAlpha,
    required this.strokeColor,
    required this.strokeAlpha,
    required this.strokeWidth,
    required this.strokeCap,
    required this.strokeJoin,
    required this.strokeMiterLimit,
    required this.trimStart,
    required this.trimEnd,
    required this.trimOffset,
    required this.properties,
  });

  @override
  String? build() {
    return buildConstructorCall("PathElement", {
      "pathData": wrapWithConstructor(pathData, ValueType.pathData),
      "fillColor":
          fillColor != null ? "Color(${colorFormat(fillColor!)})" : null,
      "fillAlpha": handleDefault(fillAlpha, 1.0),
      "strokeColor":
          strokeColor != null ? "Color(${colorFormat(strokeColor!)})" : null,
      "strokeAlpha": handleDefault(strokeAlpha, 1.0),
      "strokeWidth": handleDefault(strokeWidth, 1.0),
      "strokeCap": strokeCap != null ? "StrokeCap.$strokeCap" : null,
      "strokeJoin": strokeJoin != null ? "StrokeJoin.$strokeJoin" : null,
      "strokeMiterLimit": handleDefault(strokeMiterLimit, 4.0),
      "trimStart": handleDefault(trimStart, 0.0),
      "trimEnd": handleDefault(trimEnd, 1.0),
      "trimOffset": handleDefault(trimOffset, 0.0),
      "properties": properties?.build(),
    });
  }
}

class PathAnimationPropertiesTemplate extends Template {
  final List<AnimationPropertyTemplate> pathData;
  final List<AnimationPropertyTemplate> fillColor;
  final List<AnimationPropertyTemplate> fillAlpha;
  final List<AnimationPropertyTemplate> strokeColor;
  final List<AnimationPropertyTemplate> strokeAlpha;
  final List<AnimationPropertyTemplate> strokeWidth;
  final List<AnimationPropertyTemplate> trimStart;
  final List<AnimationPropertyTemplate> trimEnd;
  final List<AnimationPropertyTemplate> trimOffset;

  const PathAnimationPropertiesTemplate({
    required this.pathData,
    required this.fillColor,
    required this.fillAlpha,
    required this.strokeColor,
    required this.strokeAlpha,
    required this.strokeWidth,
    required this.trimStart,
    required this.trimEnd,
    required this.trimOffset,
  });

  @override
  String? build() {
    if (everythingEmpty([
      pathData,
      fillColor,
      fillAlpha,
      strokeColor,
      strokeAlpha,
      strokeWidth,
      trimStart,
      trimEnd,
      trimOffset,
    ])) return null;

    return buildConstructorCall("PathAnimationProperties", {
      "pathData": pathData,
      "fillColor": fillColor,
      "fillAlpha": fillAlpha,
      "strokeColor": strokeColor,
      "strokeAlpha": strokeAlpha,
      "strokeWidth": strokeWidth,
      "trimStart": trimStart,
      "trimEnd": trimEnd,
      "trimOffset": trimOffset,
    });
  }
}
