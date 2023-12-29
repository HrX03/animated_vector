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

  @ShapeshifterAsset("assets/search_to_more.shapeshifter")
  static const AnimatedVectorData searchToMore = _$searchToMore;

  @ShapeshifterAsset("assets/more_to_search.shapeshifter")
  static const AnimatedVectorData moreToSearch = _$moreToSearch;

  @ShapeshifterAsset("assets/menu_to_close.shapeshifter")
  static const AnimatedVectorData menuToClose = _$menuToClose;

  @ShapeshifterAsset("assets/close_to_menu.shapeshifter")
  static const AnimatedVectorData closeToMenu = _$closeToMenu;

  @ShapeshifterAsset("assets/more_to_close.shapeshifter")
  static const AnimatedVectorData moreToClose = _$moreToClose;

  @ShapeshifterAsset("assets/close_to_more.shapeshifter")
  static const AnimatedVectorData closeToMore = _$closeToMore;

  @ShapeshifterAsset("assets/search_to_back.shapeshifter")
  static const AnimatedVectorData searchToBack = _$searchToBack;

  @ShapeshifterAsset("assets/search_to_back_alt.shapeshifter")
  static const AnimatedVectorData searchToBackAlt = _$searchToBackAlt;

  @ShapeshifterAsset("assets/back_to_search.shapeshifter")
  static const AnimatedVectorData backToSearch = _$backToSearch;

  @ShapeshifterAsset("assets/isocube.shapeshifter")
  static const AnimatedVectorData isocube = _$isocube;
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
