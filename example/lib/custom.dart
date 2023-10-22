import 'dart:ui';

import 'package:animated_vector/animated_vector.dart';
import 'package:animated_vector_annotations/animated_vector_annotations.dart';

part 'custom.g.dart';

abstract final class CustomVectors {
  @ShapeshifterAsset("assets/apps_to_close_composite.shapeshifter")
  static const AnimatedVectorData appsToClose = _$appsToClose;

  @ShapeshifterAsset("assets/add_transition.shapeshifter")
  static const AnimatedVectorData addTransition = _$addTransition;
}
