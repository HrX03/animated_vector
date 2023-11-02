import 'package:animated_vector_gen/src/templates/animation_property.dart';
import 'package:animated_vector_gen/src/templates/template.dart';
import 'package:animated_vector_gen/src/templates/utils.dart';

class RootElementTemplate extends Template {
  final num? alpha;
  final List<ElementTemplate> elements;
  final RootAnimationPropertiesTemplate? properties;

  const RootElementTemplate({
    required this.alpha,
    required this.elements,
    required this.properties,
  });

  @override
  String? build() {
    return buildConstructorCall("RootVectorElement", {
      "alpha": handleDefault(alpha, 1.0),
      "elements": elements,
      "properties": properties?.build(),
    });
  }
}

class RootAnimationPropertiesTemplate extends Template {
  final List<AnimationStepTemplate> alpha;

  const RootAnimationPropertiesTemplate({
    required this.alpha,
  });

  @override
  String? build() {
    if (everythingEmpty([alpha])) return null;

    return buildConstructorCall("RootVectorAnimationProperties", {
      "alpha": alpha,
    });
  }
}
