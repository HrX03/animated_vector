import 'package:animated_vector_gen/src/templates/animation_property.dart';
import 'package:animated_vector_gen/src/templates/template.dart';
import 'package:animated_vector_gen/src/templates/utils.dart';

class ClipElementTemplate extends ElementTemplate {
  final String pathData;
  final ClipAnimationPropertiesTemplate? properties;

  const ClipElementTemplate({
    required this.pathData,
    required this.properties,
  });

  @override
  String? build() {
    return buildConstructorCall("ClipPathElement", {
      "pathData": wrapWithConstructor(pathData, ValueType.pathData),
      "properties": properties?.build(),
    });
  }
}

class ClipAnimationPropertiesTemplate extends Template {
  final List<AnimationStepTemplate> pathData;

  const ClipAnimationPropertiesTemplate({
    required this.pathData,
  });

  @override
  String? build() {
    if (everythingEmpty([pathData])) return null;

    return buildConstructorCall("ClipPathAnimationProperties", {
      "pathData": pathData,
    });
  }
}
