import 'dart:ui';

import 'package:animated_vector/animated_vector.dart';
import 'package:flutter/animation.dart';

class AnimatedVectors {
  static const AnimatedVectorData searchToClose = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 850),
    root: RootVectorElement(
      elements: [
        GroupElement(
          properties: GroupAnimationProperties(
            translateX: [
              AnimationStep(
                tween: ConstTween<double>(begin: 0.0, end: -6.7),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            translateY: [
              AnimationStep(
                tween: ConstTween<double>(begin: 0.0, end: -6.7),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 13.389 13.389 C 15.537 11.241 15.537 7.759 13.389 5.611 C 11.241 3.463 7.759 3.463 5.611 5.611 C 3.463 7.759 3.463 11.241 5.611 13.389 C 7.759 15.537 11.241 15.537 13.389 13.389 Z",
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 1.8,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationStep(
                    tween: ConstTween<double>(end: 1),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 134),
                      end: Duration(milliseconds: 550),
                    ),
                    curve: Curves.decelerate,
                  ),
                ],
              ),
            ),
          ],
        ),
        PathElement(
          pathData: PathData.parse("M 18 6 L 6 18"),
          strokeColor: Color(0xFF000000),
          strokeWidth: 1.8,
          trimStart: 1.0,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationStep(
                tween: ConstTween<double>(begin: 1.0, end: 0.0),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 522),
                  end: Duration(milliseconds: 836),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        PathElement(
          pathData: PathData.parse("M 6 6 L 20 20"),
          strokeColor: Color(0xFF000000),
          strokeWidth: 1.8,
          trimStart: 0.48,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationStep(
                tween: ConstTween<double>(begin: 0.48, end: 0.0),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            trimEnd: [
              AnimationStep(
                tween: ConstTween<double>(begin: 1, end: 0.86),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData closeToSearch = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 850),
    root: RootVectorElement(
      elements: [
        GroupElement(
          properties: GroupAnimationProperties(
            translateX: [
              AnimationStep(
                tween: ConstTween<double>(begin: -6.7, end: 0.0),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            translateY: [
              AnimationStep(
                tween: ConstTween<double>(begin: -6.7, end: 0.0),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          translateX: -6.7,
          translateY: -6.7,
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 13.389 13.389 C 15.537 11.241 15.537 7.759 13.389 5.611 C 11.241 3.463 7.759 3.463 5.611 5.611 C 3.463 7.759 3.463 11.241 5.611 13.389 C 7.759 15.537 11.241 15.537 13.389 13.389 Z",
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 1.8,
              trimEnd: 0.0,
              properties: PathAnimationProperties(
                trimEnd: [
                  AnimationStep(
                    tween: ConstTween<double>(begin: 0, end: 1),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 300),
                      end: Duration(milliseconds: 716),
                    ),
                    curve: Curves.decelerate,
                  ),
                ],
              ),
            ),
          ],
        ),
        PathElement(
          pathData: PathData.parse("M 18 6 L 6 18"),
          strokeColor: Color(0xFF000000),
          strokeWidth: 1.8,
          properties: PathAnimationProperties(
            trimEnd: [
              AnimationStep(
                tween: ConstTween<double>(begin: 1.0, end: 0.0),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 134),
                  end: Duration(milliseconds: 448),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        PathElement(
          pathData: PathData.parse("M 6 6 L 20 20"),
          strokeColor: Color(0xFF000000),
          strokeWidth: 1.8,
          trimEnd: 0.86,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationStep(
                tween: ConstTween<double>(begin: 0.0, end: 0.48),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            trimEnd: [
              AnimationStep(
                tween: ConstTween<double>(begin: 0.86, end: 1.0),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData playToPause = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep(
                tween: ConstTween<double>(end: 90.0),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 8 5 L 8 12 L 19 12 L 19 12 L 8 5 M 8 12 L 8 19 L 19 12 L 19 12 L 8 12",
              ),
              fillColor: Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep(
                    tween: ConstPathDataTween(
                      end: PathData.parse(
                        "M 5 6 L 5 10 L 19 10 L 19 6 L 5 6 M 5 14 L 5 18 L 19 18 L 19 14 L 5 14",
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
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
  );

  static const AnimatedVectorData pauseToPlay = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep(
                tween: ConstTween<double>(begin: -90, end: 0.0),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 5 6 L 5 10 L 19 10 L 19 6 L 5 6 M 5 14 L 5 18 L 19 18 L 19 14 L 5 14",
              ),
              fillColor: Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep(
                    tween: ConstPathDataTween(
                      end: PathData.parse(
                        "M 8 5 L 8 12 L 19 12 L 19 12 L 8 5 M 8 12 L 8 19 L 19 12 L 19 12 L 8 12",
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
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
  );

  static const AnimatedVectorData drawerToArrow = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep(
                tween: ConstTween<double>(end: 180.0),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 3,6 L 3,8 L 21,8 L 21,6 L 3,6 z M 3,11 L 3,13 L 21,13 L 21, 12 L 21,11 L 3,11 z M 3,18 L 3,16 L 21,16 L 21,18 L 3,18 z",
              ),
              fillColor: Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep(
                    tween: ConstPathDataTween(
                      end: PathData.parse(
                        "M 12, 4 L 10.59,5.41 L 16.17,11 L 18.99,11 L 12,4 z M 4, 11 L 4, 13 L 18.99, 13 L 20, 12 L 18.99, 11 L 4, 11 z M 12,20 L 10.59, 18.59 L 16.17, 13 L 18.99, 13 L 12, 20z",
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
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
  );

  static const AnimatedVectorData arrowToDrawer = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep(
                tween: ConstTween<double>(begin: -180.0, end: 0),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 12, 4 L 10.59,5.41 L 16.17,11 L 18.99,11 L 12,4 z M 4, 11 L 4, 13 L 18.99, 13 L 20, 12 L 18.99, 11 L 4, 11 z M 12,20 L 10.59, 18.59 L 16.17, 13 L 18.99, 13 L 12, 20z",
              ),
              fillColor: Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep(
                    tween: ConstPathDataTween(
                      end: PathData.parse(
                        "M 3,6 L 3,8 L 21,8 L 21,6 L 3,6 z M 3,11 L 3,13 L 21,13 L 21, 12 L 21,11 L 3,11 z M 3,18 L 3,16 L 21,16 L 21,18 L 3,18 z",
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
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
  );

  static const AnimatedVectorData expandToCollapse = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 250),
    root: RootVectorElement(
      elements: [
        GroupElement(
          translateX: 12,
          translateY: 15,
          properties: GroupAnimationProperties(
            translateY: [
              AnimationStep(
                tween: ConstTween<double>(begin: 15.0, end: 9.0),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 250),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            GroupElement(
              rotation: 135,
              properties: GroupAnimationProperties(
                rotation: [
                  AnimationStep(
                    tween: ConstTween<double>(begin: 135, end: 45.0),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
              elements: [
                GroupElement(
                  translateY: 3,
                  elements: [
                    PathElement(
                      pathData: PathData.parse("M 1,-4 L 1,4 L -1,4 L -1,-4 Z"),
                      fillColor: Color(0xFF000000),
                    ),
                  ],
                ),
              ],
            ),
            GroupElement(
              rotation: 45,
              properties: GroupAnimationProperties(
                rotation: [
                  AnimationStep(
                    tween: ConstTween<double>(begin: 45, end: 135.0),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
              elements: [
                GroupElement(
                  translateY: -3,
                  elements: [
                    PathElement(
                      pathData: PathData.parse("M 1,-4 L 1,4 L -1,4 L -1,-4 Z"),
                      fillColor: Color(0xFF000000),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  static const AnimatedVectorData collapseToExpand = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 250),
    root: RootVectorElement(
      elements: [
        GroupElement(
          translateX: 12,
          translateY: 9,
          properties: GroupAnimationProperties(
            translateY: [
              AnimationStep(
                tween: ConstTween<double>(begin: 9.0, end: 15.0),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 250),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            GroupElement(
              rotation: 45,
              properties: GroupAnimationProperties(
                rotation: [
                  AnimationStep(
                    tween: ConstTween<double>(begin: 45, end: 135.0),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
              elements: [
                GroupElement(
                  translateY: 3,
                  elements: [
                    PathElement(
                      pathData: PathData.parse("M 1,-4 L 1,4 L -1,4 L -1,-4 Z"),
                      fillColor: Color(0xFF000000),
                    ),
                  ],
                ),
              ],
            ),
            GroupElement(
              rotation: 135,
              properties: GroupAnimationProperties(
                rotation: [
                  AnimationStep(
                    tween: ConstTween<double>(begin: 135, end: 45.0),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
              elements: [
                GroupElement(
                  translateY: -3,
                  elements: [
                    PathElement(
                      pathData: PathData.parse("M 1,-4 L 1,4 L -1,4 L -1,-4 Z"),
                      fillColor: Color(0xFF000000),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  static const AnimatedVectorData crossToTick = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep(
                tween: ConstTween<double>(begin: -180),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData:
                  PathData.parse("M6.4,6.4 L17.6,17.6 M6.4,17.6 L17.6,6.4"),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2,
              strokeCap: StrokeCap.square,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep(
                    tween: ConstPathDataTween(
                      end: PathData.parse(
                        "M4.8,13.4 L9,17.6 M10.4,16.2 L19.6,7",
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
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
  );

  static const AnimatedVectorData minusToPlus = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep(
                tween: ConstTween<double>(begin: -180),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 5,11 L 11,11 L 11,5 L 13,5 L 13,11 L 19,11 L 19,13 L 13,13 L 13,19 L 11,19 L 11,13 L 5,13 Z",
              ),
              fillColor: Color(0xFF000000),
              strokeCap: StrokeCap.square,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep(
                    tween: ConstPathDataTween(
                      end: PathData.parse(
                        "M 5,11 L 11,11 L 11,11 L 13,11 L 13,11 L 19,11 L 19,13 L 13,13 L 13,13 L 11,13 L 11,13 L 5,13 Z",
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 250),
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
  );

  static const AnimatedVectorData plusToMinus = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep(
                tween: ConstTween<double>(begin: -180),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 5,11 L 11,11 L 11,11 L 13,11 L 13,11 L 19,11 L 19,13 L 13,13 L 13,13 L 11,13 L 11,13 L 5,13 Z",
              ),
              fillColor: Color(0xFF000000),
              strokeCap: StrokeCap.square,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep(
                    tween: ConstPathDataTween(
                      end: PathData.parse(
                        "M 5,11 L 11,11 L 11,5 L 13,5 L 13,11 L 19,11 L 19,13 L 13,13 L 13,19 L 11,19 L 11,13 L 5,13 Z",
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 250),
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
  );

  static const AnimatedVectorData visibilityToggle = AnimatedVectorData(
    viewportSize: Size.square(24),
    duration: Duration(milliseconds: 320),
    root: RootVectorElement(
      elements: [
        PathElement(
          pathData: PathData.parse("M 2 4.27 L 3.27 3 L 3.27 3 L 2 4.27 Z"),
          fillColor: Color(0xFF000000),
          properties: PathAnimationProperties(
            pathData: [
              AnimationStep(
                tween: ConstPathDataTween(
                  end: PathData.parse(
                    "M 19.73 22 L 21 20.73 L 3.27 3 L 2 4.27 Z",
                  ),
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 320),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        ClipPathElement(
          pathData: PathData.parse(
            "M 0 0 L 24 0 L 24 24 L 0 24 L 0 0 Z M 4.54 1.73 L 3.27 3 L 3.27 3 L 4.54 1.73 Z",
          ),
          properties: ClipPathAnimationProperties(
            pathData: [
              AnimationStep(
                tween: ConstPathDataTween(
                  end: PathData.parse(
                    "M 0 0 L 24 0 L 24 24 L 0 24 L 0 0 Z M 4.54 1.73 L 3.27 3 L 21 20.73 L 22.27 19.46 Z",
                  ),
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 320),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        PathElement(
          pathData: PathData.parse(
            "M 12 4.5 C 7 4.5 2.73 7.61 1 12 C 2.73 16.39 7 19.5 12 19.5 C 17 19.5 21.27 16.39 23 12 C 21.27 7.61 17 4.5 12 4.5 L 12 4.5 Z M 12 17 C 9.24 17 7 14.76 7 12 C 7 9.24 9.24 7 12 7 C 14.76 7 17 9.24 17 12 C 17 14.76 14.76 17 12 17 L 12 17 Z M 12 9 C 10.34 9 9 10.34 9 12 C 9 13.66 10.34 15 12 15 C 13.66 15 15 13.66 15 12 C 15 10.34 13.66 9 12 9 L 12 9 Z",
          ),
          fillColor: Color(0xFF000000),
        ),
      ],
    ),
  );

  static const AnimatedVectorData musicNext = AnimatedVectorData(
    viewportSize: Size.square(200),
    duration: Duration(milliseconds: 333),
    root: RootVectorElement(
      elements: [
        GroupElement(
          scaleX: 3.34,
          scaleY: 3.34,
          translateX: 100.295,
          translateY: 98.94466,
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 9.3330078125,14.0 c 0.0,0.0 4.6669921875,0.0 4.6669921875,0.0 c 0.0,0.0 0.0,-28.0 0.0,-28.0 c 0.0,0.0 -4.6669921875,0.0 -4.6669921875,0.0 c 0.0,0.0 0.0,28.0 0.0,28.0 Z",
              ),
              fillColor: Color(0xFF000000),
            ),
          ],
        ),
        GroupElement(
          scaleX: 3.34,
          scaleY: 3.34,
          translateX: 100.295,
          translateY: 98.94466,
          elements: [
            GroupElement(
              translateX: -14.25,
              translateY: -14.25,
              elements: [
                ClipPathElement(
                  pathData: PathData.parse(
                    "M 24.393951416,-0.677169799805 c 0.0,0.0 -25.1134490967,0.0 -25.1134490967,0.0 c 0.0,0.0 0.0,29.8667297363 0.0,29.8667297363 c 0.0,0.0 25.1134490967,0.0 25.1134490967,0.0 c 0.0,0.0 0.0,-29.8667297363 0.0,-29.8667297363 Z",
                  ),
                ),
                GroupElement(
                  translateX: 14.25,
                  translateY: 14.25,
                  elements: [
                    PathElement(
                      pathData: PathData.parse(
                        "M -14,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                      ),
                      fillColor: Color(0xFF000000),
                      properties: PathAnimationProperties(
                        pathData: [
                          AnimationStep(
                            tween: ConstPathDataTween(
                              end: PathData.parse(
                                "M 10,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                              ),
                            ),
                            interval: AnimationInterval(
                              end: Duration(milliseconds: 333),
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
          ],
        ),
        GroupElement(
          scaleX: 3.34,
          scaleY: 3.34,
          translateX: 53.535,
          translateY: 98.94466,
          elements: [
            GroupElement(
              translateX: -0.25,
              translateY: -14.25,
              elements: [
                ClipPathElement(
                  pathData: PathData.parse(
                    "M 23.8758392334,-0.628646850586 c 0.0,0.0 -24.3848266602,0.0 -24.3848266602,0.0 c 0.0,0.0 0.0,29.631072998 0.0,29.631072998 c 0.0,0.0 24.3848266602,0.0 24.3848266602,0.0 c 0.0,0.0 0.0,-29.631072998 0.0,-29.631072998 Z",
                  ),
                ),
                GroupElement(
                  translateX: 14.25,
                  translateY: 14.25,
                  elements: [
                    PathElement(
                      pathData: PathData.parse(
                        "M -35.5,0.315963745117 c 0,0 19.8330078125,-0.315963745117 19.8330078125,-0.315963745117 c 0,0 -19.8330078125,-0.315963745117 -19.8330078125,-0.315963745117 c 0,0 0,0.631927490234 0,0.631927490234 Z",
                      ),
                      fillColor: Color(0xFF000000),
                      properties: PathAnimationProperties(
                        pathData: [
                          AnimationStep(
                            tween: ConstPathDataTween(
                              end: PathData.parse(
                                "M -14,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                              ),
                            ),
                            interval: AnimationInterval(
                              end: Duration(milliseconds: 333),
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
          ],
        ),
      ],
    ),
  );

  static const AnimatedVectorData musicPrevious = AnimatedVectorData(
    viewportSize: Size.square(200),
    duration: Duration(milliseconds: 333),
    root: RootVectorElement(
      elements: [
        GroupElement(
          rotation: 180,
          scaleX: 3.34,
          scaleY: 3.34,
          translateX: 99.705,
          translateY: 101.05534,
          elements: [
            GroupElement(
              translateX: -14.25,
              translateY: -14.25,
              elements: [
                GroupElement(
                  translateX: 14.25,
                  translateY: 14.25,
                  elements: [
                    PathElement(
                      pathData: PathData.parse(
                        "M 9.3330078125,14.0 c 0.0,0.0 4.6669921875,0.0 4.6669921875,0.0 c 0.0,0.0 0.0,-28.0 0.0,-28.0 c 0.0,0.0 -4.6669921875,0.0 -4.6669921875,0.0 c 0.0,0.0 0.0,28.0 0.0,28.0 Z",
                      ),
                      fillColor: Color(0xFF000000),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GroupElement(
          rotation: 180,
          scaleX: 3.34,
          scaleY: 3.34,
          translateX: 99.705,
          translateY: 101.05534,
          elements: [
            GroupElement(
              translateX: -14.25,
              translateY: -14.25,
              elements: [
                ClipPathElement(
                  pathData: PathData.parse(
                    "M 24.393951416,-0.677169799805 c 0.0,0.0 -25.1134490967,0.0 -25.1134490967,0.0 c 0.0,0.0 0.0,29.8667297363 0.0,29.8667297363 c 0.0,0.0 25.1134490967,0.0 25.1134490967,0.0 c 0.0,0.0 0.0,-29.8667297363 0.0,-29.8667297363 Z",
                  ),
                ),
                GroupElement(
                  translateX: 14.25,
                  translateY: 14.25,
                  elements: [
                    PathElement(
                      pathData: PathData.parse(
                        "M -14,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                      ),
                      fillColor: Color(0xFF000000),
                      properties: PathAnimationProperties(
                        pathData: [
                          AnimationStep(
                            tween: ConstPathDataTween(
                              end: PathData.parse(
                                "M 10,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                              ),
                            ),
                            curve: Curves.fastOutSlowIn,
                            interval: AnimationInterval(
                              end: Duration(milliseconds: 333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GroupElement(
          rotation: 180,
          scaleX: 3.34,
          scaleY: 3.34,
          translateX: 146.465,
          translateY: 101.05534,
          elements: [
            GroupElement(
              translateX: -0.25,
              translateY: -14.25,
              elements: [
                ClipPathElement(
                  pathData: PathData.parse(
                    "M 23.8758392334,-0.628646850586 c 0.0,0.0 -24.3848266602,0.0 -24.3848266602,0.0 c 0.0,0.0 0.0,29.631072998 0.0,29.631072998 c 0.0,0.0 24.3848266602,0.0 24.3848266602,0.0 c 0.0,0.0 0.0,-29.631072998 0.0,-29.631072998 Z",
                  ),
                ),
                GroupElement(
                  translateX: 14.25,
                  translateY: 14.25,
                  elements: [
                    PathElement(
                      pathData: PathData.parse(
                        "M -35.5,0.315963745117 c 0,0 19.8330078125,-0.315963745117 19.8330078125,-0.315963745117 c 0,0 -19.8330078125,-0.315963745117 -19.8330078125,-0.315963745117 c 0,0 0,0.631927490234 0,0.631927490234 Z",
                      ),
                      fillColor: Color(0xFF000000),
                      properties: PathAnimationProperties(
                        pathData: [
                          AnimationStep(
                            tween: ConstPathDataTween(
                              end: PathData.parse(
                                "M -14,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                              ),
                            ),
                            curve: Curves.fastOutSlowIn,
                            interval: AnimationInterval(
                              end: Duration(milliseconds: 333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  static const AnimatedVectorData searchToMore = AnimatedVectorData(
    viewportSize: Size(24, 24),
    duration: Duration(milliseconds: 500),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12.0,
          pivotY: 12.0,
          elements: [
            GroupElement(
              translateX: 12.0,
              translateY: 12.0,
              elements: [
                PathElement(
                  pathData: PathData.parse(
                    'M 0 0 L 0 0',
                  ),
                  strokeColor: Color(0xFF000000),
                  strokeAlpha: 0.0,
                  strokeWidth: 2.0,
                  strokeCap: StrokeCap.round,
                  properties: PathAnimationProperties(
                    strokeAlpha: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 100),
                          end: Duration(milliseconds: 400),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                    strokeWidth: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 2.0,
                          end: 4.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 100),
                          end: Duration(milliseconds: 400),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                  ),
                ),
              ],
              properties: GroupAnimationProperties(
                translateY: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 12.0,
                      end: 6.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 100),
                      end: Duration(milliseconds: 400),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            GroupElement(
              translateX: 12.0,
              translateY: 12.0,
              elements: [
                PathElement(
                  pathData: PathData.parse(
                    'M 0 0 L 0 0',
                  ),
                  strokeColor: Color(0xFF000000),
                  strokeAlpha: 0.0,
                  strokeWidth: 2.0,
                  strokeCap: StrokeCap.round,
                  properties: PathAnimationProperties(
                    strokeAlpha: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 100),
                          end: Duration(milliseconds: 400),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                    strokeWidth: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 2.0,
                          end: 4.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 100),
                          end: Duration(milliseconds: 400),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                  ),
                ),
              ],
              properties: GroupAnimationProperties(
                translateY: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 12.0,
                      end: 18.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 100),
                      end: Duration(milliseconds: 400),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 9.5 4 C 12.54 4 15 6.46 15 9.5 C 15 12.54 12.54 15 9.5 15 C 6.46 15 4 12.54 4 9.5 C 4 6.46 6.46 4 9.5 4 Z',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep<PathData>(
                    tween: ConstPathDataTween(
                      begin: PathData.parse(
                        'M 9.5 4 C 12.54 4 15 6.46 15 9.5 C 15 12.54 12.54 15 9.5 15 C 6.46 15 4 12.54 4 9.5 C 4 6.46 6.46 4 9.5 4 Z',
                      ),
                      end: PathData.parse(
                        'M 12 11 C 12.55 11 13 11.45 13 12 C 13 12.55 12.55 13 12 13 C 11.45 13 11 12.55 11 12 C 11 11.45 11.45 11 12 11 Z',
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 13.2 13.2 L 20.3 20.3',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 1.0,
                      end: 0.0,
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
          ],
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 180.0,
                ),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 100),
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData moreToSearch = AnimatedVectorData(
    viewportSize: Size(24, 24),
    duration: Duration(milliseconds: 500),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12.0,
          pivotY: 12.0,
          rotation: -180.0,
          elements: [
            GroupElement(
              translateX: 12.0,
              translateY: 6.0,
              elements: [
                PathElement(
                  pathData: PathData.parse(
                    'M 0 0 L 0 0',
                  ),
                  strokeColor: Color(0xFF000000),
                  strokeWidth: 4.0,
                  strokeCap: StrokeCap.round,
                  properties: PathAnimationProperties(
                    strokeAlpha: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 1.0,
                          end: 0.0,
                        ),
                        interval: AnimationInterval(
                          end: Duration(milliseconds: 300),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                    strokeWidth: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 4.0,
                          end: 2.0,
                        ),
                        interval: AnimationInterval(
                          end: Duration(milliseconds: 300),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                  ),
                ),
              ],
              properties: GroupAnimationProperties(
                translateY: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 6.0,
                      end: 12.0,
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            GroupElement(
              translateX: 12.0,
              translateY: 18.0,
              elements: [
                PathElement(
                  pathData: PathData.parse(
                    'M 0 0 L 0 0',
                  ),
                  strokeColor: Color(0xFF000000),
                  strokeWidth: 4.0,
                  strokeCap: StrokeCap.round,
                  properties: PathAnimationProperties(
                    strokeAlpha: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 1.0,
                          end: 0.0,
                        ),
                        interval: AnimationInterval(
                          end: Duration(milliseconds: 300),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                    strokeWidth: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 4.0,
                          end: 2.0,
                        ),
                        interval: AnimationInterval(
                          end: Duration(milliseconds: 300),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                  ),
                ),
              ],
              properties: GroupAnimationProperties(
                translateY: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 18.0,
                      end: 12.0,
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 12 11 C 12.55 11 13 11.45 13 12 C 13 12.55 12.55 13 12 13 C 11.45 13 11 12.55 11 12 C 11 11.45 11.45 11 12 11 Z',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep<PathData>(
                    tween: ConstPathDataTween(
                      begin: PathData.parse(
                        'M 12 11 C 12.55 11 13 11.45 13 12 C 13 12.55 12.55 13 12 13 C 11.45 13 11 12.55 11 12 C 11 11.45 11.45 11 12 11 Z',
                      ),
                      end: PathData.parse(
                        'M 9.5 4 C 12.54 4 15 6.46 15 9.5 C 15 12.54 12.54 15 9.5 15 C 6.46 15 4 12.54 4 9.5 C 4 6.46 6.46 4 9.5 4 Z',
                      ),
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 500),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 13.2 13.2 L 20.3 20.3',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              trimEnd: 0.0,
              properties: PathAnimationProperties(
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 300),
                      end: Duration(milliseconds: 500),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
          ],
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: -180.0,
                  end: 0.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 400),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData menuToClose = AnimatedVectorData(
    viewportSize: Size(24, 24),
    duration: Duration(milliseconds: 500),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12.0,
          pivotY: 12.0,
          elements: [
            PathElement(
              pathData: PathData.parse(
                'M 21 7 L 3 7',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep<PathData>(
                    tween: ConstPathDataTween(
                      begin: PathData.parse(
                        'M 21 7 L 3 7',
                      ),
                      end: PathData.parse(
                        'M 18.3 5.7 L 5.7 18.3',
                      ),
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 3 12 L 21 12',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.0,
                      end: 0.5,
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 1.0,
                      end: 0.5,
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 3 17 L 21 17',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep<PathData>(
                    tween: ConstPathDataTween(
                      begin: PathData.parse(
                        'M 21 17 L 3 17',
                      ),
                      end: PathData.parse(
                        'M 18.3 18.3 L 5.7 5.7',
                      ),
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
          ],
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 180.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData closeToMenu = AnimatedVectorData(
    viewportSize: Size(24, 24),
    duration: Duration(milliseconds: 500),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12.0,
          pivotY: 12.0,
          elements: [
            PathElement(
              pathData: PathData.parse(
                'M 18.3 5.7 L 5.7 18.3',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep<PathData>(
                    tween: ConstPathDataTween(
                      begin: PathData.parse(
                        'M 18.3 5.7 L 5.7 18.3',
                      ),
                      end: PathData.parse(
                        'M 21 7 L 3 7',
                      ),
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 3 12 L 21 12',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              trimStart: 0.5,
              trimEnd: 0.5,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.5,
                      end: 0.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.5,
                      end: 1.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 18.3 18.3 L 5.7 5.7',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep<PathData>(
                    tween: ConstPathDataTween(
                      begin: PathData.parse(
                        'M 18.3 18.3 L 5.7 5.7',
                      ),
                      end: PathData.parse(
                        'M 21 17 L 3 17',
                      ),
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
          ],
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 180.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData moreToClose = AnimatedVectorData(
    viewportSize: Size(24, 24),
    duration: Duration(milliseconds: 500),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12.0,
          pivotY: 12.0,
          elements: [
            PathElement(
              pathData: PathData.parse(
                'M 12 10 C 13.1 10 14 10.9 14 12 C 14 13.1 13.1 14 12 14 C 10.9 14 10 13.1 10 12 C 10 10.9 10.9 10 12 10 Z',
              ),
              fillColor: Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep<PathData>(
                    tween: ConstPathDataTween(
                      begin: PathData.parse(
                        'M 12 10 C 13.1 10 14 10.9 14 12 C 14 13.1 13.1 14 12 14 C 10.9 14 10 13.1 10 12 C 10 10.9 10.9 10 12 10 Z',
                      ),
                      end: PathData.parse(
                        'M 12 10.6 C 12 10.6 13.4 12 13.4 12 C 13.4 12 12 13.4 12 13.4 C 12 13.4 10.6 12 10.6 12 C 10.6 12 12 10.6 12 10.6 Z',
                      ),
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 18.3 5.7 L 5.7 18.3',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              trimStart: 0.5,
              trimEnd: 0.5,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.5,
                      end: 0.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 450),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.5,
                      end: 1.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 450),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 18.3 18.3 L 5.7 5.7',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              trimStart: 0.5,
              trimEnd: 0.5,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.5,
                      end: 0.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 450),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.5,
                      end: 1.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 450),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            GroupElement(
              translateX: 12.0,
              translateY: 6.0,
              elements: [
                PathElement(
                  pathData: PathData.parse(
                    'M 0 0 L 0 0',
                  ),
                  strokeColor: Color(0xFF000000),
                  strokeWidth: 4.0,
                  strokeCap: StrokeCap.round,
                  properties: PathAnimationProperties(
                    strokeAlpha: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 1.0,
                          end: 0.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 50),
                          end: Duration(milliseconds: 250),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                    strokeWidth: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 4.0,
                          end: 2.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 50),
                          end: Duration(milliseconds: 250),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                  ),
                ),
              ],
              properties: GroupAnimationProperties(
                translateY: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 6.0,
                      end: 12.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 250),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            GroupElement(
              translateX: 12.0,
              translateY: 18.0,
              elements: [
                PathElement(
                  pathData: PathData.parse(
                    'M 0 0 L 0 0',
                  ),
                  strokeColor: Color(0xFF000000),
                  strokeWidth: 4.0,
                  strokeCap: StrokeCap.round,
                  properties: PathAnimationProperties(
                    strokeAlpha: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 1.0,
                          end: 0.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 50),
                          end: Duration(milliseconds: 250),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                    strokeWidth: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 4.0,
                          end: 2.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 50),
                          end: Duration(milliseconds: 250),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                  ),
                ),
              ],
              properties: GroupAnimationProperties(
                translateY: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 18.0,
                      end: 12.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 250),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
          ],
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 180.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData closeToMore = AnimatedVectorData(
    viewportSize: Size(24, 24),
    duration: Duration(milliseconds: 500),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12.0,
          pivotY: 12.0,
          elements: [
            PathElement(
              pathData: PathData.parse(
                'M 12 10.6 C 12 10.6 13.4 12 13.4 12 C 13.4 12 12 13.4 12 13.4 C 12 13.4 10.6 12 10.6 12 C 10.6 12 12 10.6 12 10.6 Z',
              ),
              fillColor: Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationStep<PathData>(
                    tween: ConstPathDataTween(
                      begin: PathData.parse(
                        'M 12 10.6 C 12 10.6 13.4 12 13.4 12 C 13.4 12 12 13.4 12 13.4 C 12 13.4 10.6 12 10.6 12 C 10.6 12 12 10.6 12 10.6 Z',
                      ),
                      end: PathData.parse(
                        'M 12 10 C 13.1 10 14 10.9 14 12 C 14 13.1 13.1 14 12 14 C 10.9 14 10 13.1 10 12 C 10 10.9 10.9 10 12 10 Z',
                      ),
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 100),
                      end: Duration(milliseconds: 400),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 18.3 5.7 L 5.7 18.3',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.0,
                      end: 0.5,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 1.0,
                      end: 0.5,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            PathElement(
              pathData: PathData.parse(
                'M 18.3 18.3 L 5.7 5.7',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.0,
                      end: 0.5,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 1.0,
                      end: 0.5,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 50),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            GroupElement(
              translateX: 12.0,
              translateY: 12.0,
              elements: [
                PathElement(
                  pathData: PathData.parse(
                    'M 0 0 L 0 0',
                  ),
                  strokeColor: Color(0xFF000000),
                  strokeAlpha: 0.0,
                  strokeWidth: 2.0,
                  strokeCap: StrokeCap.round,
                  properties: PathAnimationProperties(
                    strokeAlpha: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 150),
                          end: Duration(milliseconds: 350),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                    strokeWidth: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 2.0,
                          end: 4.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 150),
                          end: Duration(milliseconds: 350),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                  ),
                ),
              ],
              properties: GroupAnimationProperties(
                translateY: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 12.0,
                      end: 6.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
            GroupElement(
              translateX: 12.0,
              translateY: 12.0,
              elements: [
                PathElement(
                  pathData: PathData.parse(
                    'M 0 0 L 0 0',
                  ),
                  strokeColor: Color(0xFF000000),
                  strokeAlpha: 0.0,
                  strokeWidth: 2.0,
                  strokeCap: StrokeCap.round,
                  properties: PathAnimationProperties(
                    strokeAlpha: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 150),
                          end: Duration(milliseconds: 350),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                    strokeWidth: [
                      AnimationStep<double>(
                        tween: ConstTween<double>(
                          begin: 2.0,
                          end: 4.0,
                        ),
                        interval: AnimationInterval(
                          start: Duration(milliseconds: 150),
                          end: Duration(milliseconds: 350),
                        ),
                        curve: ShapeShifterCurves.fastOutSlowIn,
                      ),
                    ],
                  ),
                ),
              ],
              properties: GroupAnimationProperties(
                translateY: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 12.0,
                      end: 18.0,
                    ),
                    interval: AnimationInterval(
                      start: Duration(milliseconds: 150),
                      end: Duration(milliseconds: 350),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
          ],
          properties: GroupAnimationProperties(
            rotation: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 180.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData searchToBack = AnimatedVectorData(
    viewportSize: Size(24, 24),
    duration: Duration(milliseconds: 500),
    root: RootVectorElement(
      elements: [
        PathElement(
          pathData: PathData.parse(
            'M 20.3 20.3 L 13.2 13.2 L 20.3 6.1',
          ),
          strokeColor: Color(0xFF000000),
          strokeWidth: 2.0,
          trimEnd: 0.5,
          properties: PathAnimationProperties(
            pathData: [
              AnimationStep<PathData>(
                tween: ConstPathDataTween(
                  begin: PathData.parse(
                    'M 20.3 20.3 L 13.2 13.2 L 20.3 6.1',
                  ),
                  end: PathData.parse(
                    'M 12.71 19.3 L 5.41 12 L 12.71 4.7',
                  ),
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 400),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
            trimEnd: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.5,
                  end: 1.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 400),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        GroupElement(
          elements: [
            PathElement(
              pathData: PathData.parse(
                'M 9.5 4 C 12.54 4 15 6.46 15 9.5 C 15 12.54 12.54 15 9.5 15 C 6.46 15 4 12.54 4 9.5 C 4 6.46 6.46 4 9.5 4 Z',
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 2.0,
              trimOffset: 0.875,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 0.0,
                      end: 0.5,
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
                trimEnd: [
                  AnimationStep<double>(
                    tween: ConstTween<double>(
                      begin: 1.0,
                      end: 0.5,
                    ),
                    interval: AnimationInterval(
                      end: Duration(milliseconds: 300),
                    ),
                    curve: ShapeShifterCurves.fastOutSlowIn,
                  ),
                ],
              ),
            ),
          ],
          properties: GroupAnimationProperties(
            translateX: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: -8.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
            translateY: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: -8.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 300),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        PathElement(
          pathData: PathData.parse(
            'M 6.5 12 L 20 12',
          ),
          strokeColor: Color(0xFF000000),
          strokeWidth: 2.0,
          trimEnd: 0.0,
          properties: PathAnimationProperties(
            trimEnd: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 1.0,
                ),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 250),
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const AnimatedVectorData backToSearch = AnimatedVectorData(
    viewportSize: Size(24, 24),
    duration: Duration(milliseconds: 500),
    root: RootVectorElement(
      elements: [
        PathElement(
          pathData: PathData.parse(
            'M 12.71 4.7 C 12.71 4.7 20.01 12 20.01 12 C 20.01 12 12.71 19.3 12.71 19.3 C 12.71 19.3 5.41 12 5.41 12 C 5.41 12 12.71 4.7 12.71 4.7 Z',
          ),
          strokeColor: Color(0xFF000000),
          strokeWidth: 2.0,
          trimStart: 0.5,
          properties: PathAnimationProperties(
            pathData: [
              AnimationStep<PathData>(
                tween: ConstPathDataTween(
                  begin: PathData.parse(
                    'M 12.71 4.7 C 12.71 4.7 20.01 12 20.01 12 C 20.01 12 12.71 19.3 12.71 19.3 C 12.71 19.3 5.41 12 5.41 12 C 5.41 12 12.71 4.7 12.71 4.7 Z',
                  ),
                  end: PathData.parse(
                    'M 9.5 4 C 12.54 4 15 6.46 15 9.5 C 15 12.54 12.54 15 9.5 15 C 6.46 15 4 12.54 4 9.5 C 4 6.46 6.46 4 9.5 4 Z',
                  ),
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
            trimStart: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.5,
                  end: 0.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
            trimOffset: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 0.75,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        PathElement(
          pathData: PathData.parse(
            'M 6.5 12 L 20 12',
          ),
          strokeColor: Color(0xFF000000),
          strokeWidth: 2.0,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 1.0,
                ),
                interval: AnimationInterval(
                  end: Duration(milliseconds: 200),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
        PathElement(
          pathData: PathData.parse(
            'M 13.2 13.2 L 20.3 20.3',
          ),
          strokeColor: Color(0xFF000000),
          strokeWidth: 2.0,
          trimEnd: 0.0,
          properties: PathAnimationProperties(
            trimEnd: [
              AnimationStep<double>(
                tween: ConstTween<double>(
                  begin: 0.0,
                  end: 1.0,
                ),
                interval: AnimationInterval(
                  start: Duration(milliseconds: 250),
                  end: Duration(milliseconds: 500),
                ),
                curve: ShapeShifterCurves.fastOutSlowIn,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
