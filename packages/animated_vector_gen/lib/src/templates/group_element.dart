import 'package:animated_vector_gen/src/templates/animation_property.dart';
import 'package:animated_vector_gen/src/templates/template.dart';
import 'package:animated_vector_gen/src/templates/utils.dart';

class GroupElementTemplate extends ElementTemplate {
  final num? translateX;
  final num? translateY;
  final num? scaleX;
  final num? scaleY;
  final num? pivotX;
  final num? pivotY;
  final num? rotation;
  final List<ElementTemplate> elements;
  final GroupAnimationPropertiesTemplate? properties;

  const GroupElementTemplate({
    required this.translateX,
    required this.translateY,
    required this.scaleX,
    required this.scaleY,
    required this.pivotX,
    required this.pivotY,
    required this.rotation,
    required this.elements,
    required this.properties,
  });

  @override
  String? build() {
    return buildConstructorCall("GroupElement", {
      "translateX": handleDefault(translateX, 0.0),
      "translateY": handleDefault(translateY, 0.0),
      "scaleX": handleDefault(scaleX, 1.0),
      "scaleY": handleDefault(scaleY, 1.0),
      "pivotX": handleDefault(pivotX, 0.0),
      "pivotY": handleDefault(pivotY, 0.0),
      "rotation": handleDefault(rotation, 0.0),
      "elements": elements,
      "properties": properties?.build(),
    });
  }
}

class GroupAnimationPropertiesTemplate extends Template {
  final List<AnimationStepTemplate> translateX;
  final List<AnimationStepTemplate> translateY;
  final List<AnimationStepTemplate> scaleX;
  final List<AnimationStepTemplate> scaleY;
  final List<AnimationStepTemplate> pivotX;
  final List<AnimationStepTemplate> pivotY;
  final List<AnimationStepTemplate> rotation;

  const GroupAnimationPropertiesTemplate({
    required this.translateX,
    required this.translateY,
    required this.scaleX,
    required this.scaleY,
    required this.pivotX,
    required this.pivotY,
    required this.rotation,
  });

  @override
  String? build() {
    if (everythingEmpty([
      translateX,
      translateY,
      scaleX,
      scaleY,
      pivotX,
      pivotY,
      rotation,
    ])) return null;

    return buildConstructorCall("GroupAnimationProperties", {
      "translateX": translateX,
      "translateY": translateY,
      "scaleX": scaleX,
      "scaleY": scaleY,
      "pivotX": pivotX,
      "pivotY": pivotY,
      "rotation": rotation,
    });
  }
}
