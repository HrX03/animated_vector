// ignore_for_file: constant_identifier_names

import 'package:animated_vector/animated_vector.dart';
import 'package:animated_vector_annotations/animated_vector_annotations.dart';
import 'package:flutter/widgets.dart';

part 'custom.g.dart';

abstract final class CustomVectors {
  @ShapeshifterAsset("assets/apps_to_close_composite.shapeshifter")
  static const AnimatedVectorData apps_to_close = _$apps_to_close;

  @ShapeshifterAsset("assets/add_transition.shapeshifter")
  static const AnimatedVectorData add_transition = _$add_transition;

  @ShapeshifterAsset("assets/download_start.shapeshifter")
  static const AnimatedVectorData download_start = _$download_start;

  @ShapeshifterAsset("assets/download_loop.shapeshifter")
  static const AnimatedVectorData download_loop = _$download_loop;

  @ShapeshifterAsset("assets/download_end.shapeshifter")
  static const AnimatedVectorData download_end = _$download_end;

  @ShapeshifterAsset("assets/isocube.shapeshifter")
  static const AnimatedVectorData isocube = _$isocube;

  static const AnimatedVectorData search_to_back = AnimatedVectorData(
    root: RootVectorElement(
      elements: [
        PathElement(
          pathData: PathData.parse(
            "M24.7,12.7 C24.70,12.7 31.8173374,19.9066081 31.8173371,19.9066082 C32.7867437,20.7006357 34.4599991,23 37.5,23 C40.54,23 43,20.54 43,17.5 C43,14.46 40.54,12 37.5,12 C34.46,12 33.2173088,12 31.8173371,12 C31.8173374,12 18.8477173,12 18.8477173,12",
          ),
          strokeColor: Color(0xFF000000),
          strokeWidth: 2,
          trimEnd: 0.185,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationStep(
                tween: ConstTween<double>(end: 0.75),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 600),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            trimEnd: [
              AnimationStep(
                tween: ConstTween<double>(end: 1),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 450),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        PathElement(
          pathData: PathData.parse(
            "M25.39,13.39 A 5.5 5.5 0 1 1 17.61 5.61 A 5.5 5.5 0 1 1 25.39 13.39",
          ),
          strokeColor: Color(0xFF000000),
          strokeWidth: 2,
          properties: PathAnimationProperties(
            trimEnd: [
              AnimationStep(
                tween: ConstTween<double>(end: 0),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 250),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        GroupElement(
          properties: GroupAnimationProperties(
            translateX: [
              AnimationStep(
                tween: ConstTween<double>(begin: 8, end: 8),
                interval: AnimationInterval(end: Duration.zero),
              ),
              AnimationStep(
                tween: ConstTween<double>(end: 0),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 350),
                  end: Duration(milliseconds: 600),
                ),
                curve: Curves.fastLinearToSlowEaseIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M16.7017297,12.6957157 L24.7043962,4.69304955",
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2,
              trimEnd: 0,
              properties: PathAnimationProperties(
                trimEnd: [
                  AnimationStep(
                    tween: ConstTween<double>(end: 0),
                    interval: AnimationInterval(end: Duration.zero),
                  ),
                  AnimationStep(
                    tween: ConstTween<double>(end: 1),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 350),
                      end: Duration(milliseconds: 600),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                "M16.7107986,11.2764828 L24.7221527,19.2878361",
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2,
              trimEnd: 0,
              properties: PathAnimationProperties(
                trimEnd: [
                  AnimationStep(
                    tween: ConstTween<double>(end: 0),
                    interval: AnimationInterval(end: Duration.zero),
                  ),
                  AnimationStep(
                    tween: ConstTween<double>(end: 1),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 350),
                      end: Duration(milliseconds: 600),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
    duration: Duration(milliseconds: 600),
    viewportSize: Size(48, 24),
  );
}

class CustomSequences {
  static const List<SequenceEntry> download = [
    SequenceItem(CustomVectors.download_start, skipMidAnimation: false),
    SequenceItem(
      CustomVectors.download_loop,
      repeatCount: null,
      skipMidAnimation: false,
      nextOnComplete: true,
    ),
    SequenceItem(
      CustomVectors.download_end,
      skipMidAnimation: false,
      nextOnComplete: true,
    ),
  ];
}
