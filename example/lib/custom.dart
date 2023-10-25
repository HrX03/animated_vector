import 'dart:ui';

import 'package:animated_vector/animated_vector.dart';
import 'package:animated_vector_annotations/animated_vector_annotations.dart';

part 'custom.g.dart';

abstract final class CustomVectors {
  @ShapeshifterAsset("assets/apps_to_close_composite.shapeshifter")
  static const AnimatedVectorData appsToClose = _$appsToClose;

  @ShapeshifterAsset("assets/add_transition.shapeshifter")
  static const AnimatedVectorData addTransition = _$addTransition;

  @ShapeshifterAsset("assets/download_start.shapeshifter")
  static const AnimatedVectorData downloadStart = _$downloadStart;

  @ShapeshifterAsset("assets/download_loop.shapeshifter")
  static const AnimatedVectorData downloadLoop = _$downloadLoop;

  @ShapeshifterAsset("assets/download_end.shapeshifter")
  static const AnimatedVectorData downloadEnd = _$downloadEnd;
}

class CustomSequences {
  static const List<SequenceEntry> download = [
    SequenceItem(CustomVectors.downloadStart, skipMidAnimation: false),
    SequenceItem(
      CustomVectors.downloadLoop,
      repeatCount: null,
      skipMidAnimation: false,
      nextOnComplete: true,
    ),
    SequenceItem(
      CustomVectors.downloadEnd,
      skipMidAnimation: false,
      nextOnComplete: true,
    ),
  ];
}
