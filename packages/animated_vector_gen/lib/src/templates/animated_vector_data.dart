import 'package:animated_vector_gen/src/templates/root_element.dart';
import 'package:animated_vector_gen/src/templates/template.dart';
import 'package:animated_vector_gen/src/templates/utils.dart';

class AnimatedVectorDataTemplate extends Template {
  final (num, num) viewportSize;
  final num duration;
  final RootElementTemplate root;

  const AnimatedVectorDataTemplate({
    required this.viewportSize,
    required this.duration,
    required this.root,
  });

  @override
  String? build() {
    return buildConstructorCall("AnimatedVectorData", {
      "viewportSize": "Size(${viewportSize.$1}, ${viewportSize.$2})",
      "duration": "Duration(milliseconds: $duration)",
      "root": root,
    });
  }
}
