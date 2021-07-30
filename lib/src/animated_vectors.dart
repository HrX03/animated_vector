import 'dart:ui';

import 'package:animated_vector/src/animated_vector.dart';
import 'package:flutter/animation.dart';

class AnimatedVectors {
  static final AnimatedVectorData searchToClose = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 850),
    root: RootVectorElement(
      elements: [
        GroupElement(
          properties: GroupAnimationProperties(
            translateX: [
              AnimationProperty(
                tween: Tween<double>(begin: 0.0, end: -6.7),
                interval: const AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            translateY: [
              AnimationProperty(
                tween: Tween<double>(begin: 0.0, end: -6.7),
                interval: const AnimationInterval(
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
              strokeColor: const Color(0xFF000000),
              strokeWidth: 1.8,
              properties: PathAnimationProperties(
                trimStart: [
                  AnimationProperty(
                    tween: Tween<double>(end: 1),
                    interval: const AnimationInterval(
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
          strokeColor: const Color(0xFF000000),
          strokeWidth: 1.8,
          trimStart: 1.0,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationProperty(
                tween: Tween<double>(begin: 1.0, end: 0.0),
                interval: const AnimationInterval(
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
          strokeColor: const Color(0xFF000000),
          strokeWidth: 1.8,
          trimStart: 0.48,
          trimEnd: 1.0,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationProperty(
                tween: Tween<double>(begin: 0.48, end: 0.0),
                interval: const AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            trimEnd: [
              AnimationProperty(
                tween: Tween<double>(begin: 1, end: 0.86),
                interval: const AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        )
      ],
    ),
  );

  static final AnimatedVectorData closeToSearch = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 850),
    root: RootVectorElement(
      elements: [
        GroupElement(
          properties: GroupAnimationProperties(
            translateX: [
              AnimationProperty(
                tween: Tween<double>(begin: -6.7, end: 0.0),
                interval: const AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            translateY: [
              AnimationProperty(
                tween: Tween<double>(begin: -6.7, end: 0.0),
                interval: const AnimationInterval(
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
              strokeColor: const Color(0xFF000000),
              strokeWidth: 1.8,
              trimEnd: 0.0,
              properties: PathAnimationProperties(
                trimEnd: [
                  AnimationProperty(
                    tween: Tween<double>(begin: 0, end: 1),
                    interval: const AnimationInterval(
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
          strokeColor: const Color(0xFF000000),
          strokeWidth: 1.8,
          trimEnd: 1.0,
          properties: PathAnimationProperties(
            trimEnd: [
              AnimationProperty(
                tween: Tween<double>(begin: 1.0, end: 0.0),
                interval: const AnimationInterval(
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
          strokeColor: const Color(0xFF000000),
          strokeWidth: 1.8,
          trimEnd: 0.86,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationProperty(
                tween: Tween<double>(begin: 0.0, end: 0.48),
                interval: const AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            trimEnd: [
              AnimationProperty(
                tween: Tween<double>(begin: 0.86, end: 1.0),
                interval: const AnimationInterval(
                  start: Duration(milliseconds: 300),
                  end: Duration(milliseconds: 800),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
        )
      ],
    ),
  );

  static final AnimatedVectorData playToPause = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationProperty(
                tween: Tween<double>(end: 90.0),
                interval: const AnimationInterval(
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
              fillColor: const Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationProperty(
                    tween: PathDataTween(
                      end: PathData.parse(
                        "M 5 6 L 5 10 L 19 10 L 19 6 L 5 6 M 5 14 L 5 18 L 19 18 L 19 14 L 5 14",
                      ),
                    ),
                    interval: const AnimationInterval(
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

  static final AnimatedVectorData pauseToPlay = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationProperty(
                tween: Tween<double>(begin: -90, end: 0.0),
                interval: const AnimationInterval(
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
              fillColor: const Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationProperty(
                    tween: PathDataTween(
                      end: PathData.parse(
                        "M 8 5 L 8 12 L 19 12 L 19 12 L 8 5 M 8 12 L 8 19 L 19 12 L 19 12 L 8 12",
                      ),
                    ),
                    interval: const AnimationInterval(
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

  static final AnimatedVectorData drawerToArrow = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationProperty(
                tween: Tween<double>(end: 180.0),
                interval: const AnimationInterval(
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
              fillColor: const Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationProperty(
                    tween: PathDataTween(
                      end: PathData.parse(
                        "M 12, 4 L 10.59,5.41 L 16.17,11 L 18.99,11 L 12,4 z M 4, 11 L 4, 13 L 18.99, 13 L 20, 12 L 18.99, 11 L 4, 11 z M 12,20 L 10.59, 18.59 L 16.17, 13 L 18.99, 13 L 12, 20z",
                      ),
                    ),
                    interval: const AnimationInterval(
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

  static final AnimatedVectorData arrowToDrawer = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationProperty(
                tween: Tween<double>(begin: -180.0, end: 0),
                interval: const AnimationInterval(
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
              fillColor: const Color(0xFF000000),
              properties: PathAnimationProperties(
                pathData: [
                  AnimationProperty(
                    tween: PathDataTween(
                      end: PathData.parse(
                        "M 3,6 L 3,8 L 21,8 L 21,6 L 3,6 z M 3,11 L 3,13 L 21,13 L 21, 12 L 21,11 L 3,11 z M 3,18 L 3,16 L 21,16 L 21,18 L 3,18 z",
                      ),
                    ),
                    interval: const AnimationInterval(
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

  static final AnimatedVectorData expandToCollapse = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 250),
    root: RootVectorElement(
      elements: [
        GroupElement(
          translateX: 12,
          translateY: 15,
          properties: GroupAnimationProperties(
            translateY: [
              AnimationProperty(
                tween: Tween<double>(begin: 15.0, end: 9.0),
                interval: const AnimationInterval(
                  end: Duration(milliseconds: 250),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            GroupElement(
              rotation: 135,
              translateY: 3,
              properties: GroupAnimationProperties(
                rotation: [
                  AnimationProperty(
                    tween: Tween<double>(begin: 135, end: 45.0),
                    interval: const AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
              elements: [
                PathElement(
                  pathData: PathData.parse("M 1,-4 L 1,4 L -1,4 L -1,-4 Z"),
                  fillColor: const Color(0xFF000000),
                ),
              ],
            ),
            GroupElement(
              rotation: 45,
              translateY: -3,
              properties: GroupAnimationProperties(
                rotation: [
                  AnimationProperty(
                    tween: Tween<double>(begin: 45, end: 135.0),
                    interval: const AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
              elements: [
                PathElement(
                  pathData: PathData.parse("M 1,-4 L 1,4 L -1,4 L -1,-4 Z"),
                  fillColor: const Color(0xFF000000),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  static final AnimatedVectorData collapseToExpand = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 250),
    root: RootVectorElement(
      elements: [
        GroupElement(
          translateX: 12,
          translateY: 9,
          properties: GroupAnimationProperties(
            translateY: [
              AnimationProperty(
                tween: Tween<double>(begin: 9.0, end: 15.0),
                interval: const AnimationInterval(
                  end: Duration(milliseconds: 250),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          ),
          elements: [
            GroupElement(
              rotation: 45,
              translateY: 3,
              properties: GroupAnimationProperties(
                rotation: [
                  AnimationProperty(
                    tween: Tween<double>(begin: 45, end: 135.0),
                    interval: const AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
              elements: [
                PathElement(
                  pathData: PathData.parse("M 1,-4 L 1,4 L -1,4 L -1,-4 Z"),
                  fillColor: const Color(0xFF000000),
                ),
              ],
            ),
            GroupElement(
              rotation: 135,
              translateY: -3,
              properties: GroupAnimationProperties(
                rotation: [
                  AnimationProperty(
                    tween: Tween<double>(begin: 135, end: 45.0),
                    interval: const AnimationInterval(
                      end: Duration(milliseconds: 200),
                    ),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
              elements: [
                PathElement(
                  pathData: PathData.parse("M 1,-4 L 1,4 L -1,4 L -1,-4 Z"),
                  fillColor: const Color(0xFF000000),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  static final AnimatedVectorData crossToTick = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationProperty(
                tween: Tween<double>(begin: -180),
                interval: const AnimationInterval(
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
              strokeColor: const Color(0xFF000000),
              strokeWidth: 2,
              strokeCap: StrokeCap.square,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationProperty(
                    tween: PathDataTween(
                      end: PathData.parse(
                        "M4.8,13.4 L9,17.6 M10.4,16.2 L19.6,7",
                      ),
                    ),
                    interval: const AnimationInterval(
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

  static final AnimatedVectorData minusToPlus = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationProperty(
                tween: Tween<double>(begin: -180),
                interval: const AnimationInterval(
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
              fillColor: const Color(0xFF000000),
              strokeCap: StrokeCap.square,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationProperty(
                    tween: PathDataTween(
                      end: PathData.parse(
                        "M 5,11 L 11,11 L 11,11 L 13,11 L 13,11 L 19,11 L 19,13 L 13,13 L 13,13 L 11,13 L 11,13 L 5,13 Z",
                      ),
                    ),
                    interval: const AnimationInterval(
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

  static final AnimatedVectorData plusToMinus = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 300),
    root: RootVectorElement(
      elements: [
        GroupElement(
          pivotX: 12,
          pivotY: 12,
          properties: GroupAnimationProperties(
            rotation: [
              AnimationProperty(
                tween: Tween<double>(begin: -180),
                interval: const AnimationInterval(
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
              fillColor: const Color(0xFF000000),
              strokeCap: StrokeCap.square,
              properties: PathAnimationProperties(
                pathData: [
                  AnimationProperty(
                    tween: PathDataTween(
                      end: PathData.parse(
                        "M 5,11 L 11,11 L 11,5 L 13,5 L 13,11 L 19,11 L 19,13 L 13,13 L 13,19 L 11,19 L 11,13 L 5,13 Z",
                      ),
                    ),
                    interval: const AnimationInterval(
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

  static final AnimatedVectorData visibilityToggle = AnimatedVectorData(
    viewportSize: const Size.square(24),
    duration: const Duration(milliseconds: 900),
    root: RootVectorElement(
      elements: [
        PathElement(
          pathData: PathData.parse("M 2 4.27 L 3.27 3 L 3.27 3 L 2 4.27 Z"),
          fillColor: const Color(0xFF000000),
          properties: PathAnimationProperties(
            pathData: [
              AnimationProperty(
                tween: PathDataTween(
                  end: PathData.parse(
                    "M 19.73 22 L 21 20.73 L 3.27 3 L 2 4.27 Z",
                  ),
                ),
                interval: const AnimationInterval(
                  start: Duration(milliseconds: 268),
                  end: Duration(milliseconds: 1539),
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
              AnimationProperty(
                tween: PathDataTween(
                  end: PathData.parse(
                    "M 0 0 L 24 0 L 24 24 L 0 24 L 0 0 Z M 4.54 1.73 L 3.27 3 L 21 20.73 L 22.27 19.46 Z",
                  ),
                ),
                interval: const AnimationInterval(
                  start: Duration(milliseconds: 268),
                  end: Duration(milliseconds: 1539),
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
          fillColor: const Color(0xFF000000),
        ),
      ],
    ),
  );

  static final AnimatedVectorData musicNext = AnimatedVectorData(
    viewportSize: const Size.square(200),
    duration: const Duration(milliseconds: 333),
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
              fillColor: const Color(0xFF000000),
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
                      fillColor: const Color(0xFF000000),
                      properties: PathAnimationProperties(
                        pathData: [
                          AnimationProperty(
                            tween: PathDataTween(
                              end: PathData.parse(
                                "M 10,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                              ),
                            ),
                            interval: const AnimationInterval(
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
                      fillColor: const Color(0xFF000000),
                      properties: PathAnimationProperties(
                        pathData: [
                          AnimationProperty(
                            tween: PathDataTween(
                              end: PathData.parse(
                                "M -14,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                              ),
                            ),
                            interval: const AnimationInterval(
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

  static final AnimatedVectorData musicPrevious = AnimatedVectorData(
    viewportSize: const Size.square(200),
    duration: const Duration(milliseconds: 333),
    root: RootVectorElement(
      elements: [
        GroupElement(
          scaleX: 3.34,
          scaleY: 3.34,
          translateX: 100.295,
          translateY: 98.94466,
          rotation: 180,
          pivotX: 100,
          pivotY: 100,
          elements: [
            PathElement(
              pathData: PathData.parse(
                "M 9.3330078125,14.0 c 0.0,0.0 4.6669921875,0.0 4.6669921875,0.0 c 0.0,0.0 0.0,-28.0 0.0,-28.0 c 0.0,0.0 -4.6669921875,0.0 -4.6669921875,0.0 c 0.0,0.0 0.0,28.0 0.0,28.0 Z",
              ),
              fillColor: const Color(0xFF000000),
            ),
          ],
        ),
        GroupElement(
          scaleX: 3.34,
          scaleY: 3.34,
          translateX: 100.295,
          translateY: 98.94466,
          rotation: 180,
          pivotX: 100,
          pivotY: 100,
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
                      fillColor: const Color(0xFF000000),
                      properties: PathAnimationProperties(
                        pathData: [
                          AnimationProperty(
                            tween: PathDataTween(
                              end: PathData.parse(
                                "M 10,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                              ),
                            ),
                            interval: const AnimationInterval(
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
          rotation: 180,
          pivotX: 100,
          pivotY: 100,
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
                      fillColor: const Color(0xFF000000),
                      properties: PathAnimationProperties(
                        pathData: [
                          AnimationProperty(
                            tween: PathDataTween(
                              end: PathData.parse(
                                "M -14,14 c 0,0 19.8330078125,-14 19.8330078125,-14 c 0,0 -19.8330078125,-14 -19.8330078125,-14 c 0,0 0,28 0,28 Z",
                              ),
                            ),
                            interval: const AnimationInterval(
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

  static final AnimatedVectorData searchToBack = AnimatedVectorData(
    root: RootVectorElement(
      elements: [
        PathElement(
          pathData: PathData.parse(
            "M24.7,12.7 C24.70,12.7 31.8173374,19.9066081 31.8173371,19.9066082 C32.7867437,20.7006357 34.4599991,23 37.5,23 C40.54,23 43,20.54 43,17.5 C43,14.46 40.54,12 37.5,12 C34.46,12 33.2173088,12 31.8173371,12 C31.8173374,12 18.8477173,12 18.8477173,12",
          ),
          strokeColor: const Color(0xFF000000),
          strokeWidth: 2,
          trimStart: 0,
          trimEnd: 0.185,
          properties: PathAnimationProperties(
            trimStart: [
              AnimationProperty(
                tween: Tween<double>(end: 0.75),
                interval: const AnimationInterval(
                  end: Duration(milliseconds: 600),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            ],
            trimEnd: [
              AnimationProperty(
                tween: Tween<double>(end: 1),
                interval: const AnimationInterval(
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
          strokeColor: const Color(0xFF000000),
          strokeWidth: 2,
          trimEnd: 1,
          properties: PathAnimationProperties(
            trimEnd: [
              AnimationProperty(
                tween: Tween<double>(end: 0),
                interval: const AnimationInterval(
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
              AnimationProperty(
                tween: Tween<double>(begin: 8, end: 8),
                interval: const AnimationInterval(
                  end: Duration(milliseconds: 0),
                ),
              ),
              AnimationProperty(
                tween: Tween<double>(end: 0),
                interval: AnimationInterval.withDuration(
                  startOffset: const Duration(milliseconds: 350),
                  duration: const Duration(milliseconds: 250),
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
              strokeColor: const Color(0xFF000000),
              strokeWidth: 2,
              trimEnd: 0,
              properties: PathAnimationProperties(
                trimEnd: [
                  AnimationProperty(
                    tween: Tween<double>(end: 0),
                    interval: const AnimationInterval(
                      end: Duration(milliseconds: 0),
                    ),
                  ),
                  AnimationProperty(
                    tween: Tween<double>(end: 1),
                    interval: AnimationInterval.withDuration(
                      startOffset: const Duration(milliseconds: 350),
                      duration: const Duration(milliseconds: 250),
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
              strokeColor: const Color(0xFF000000),
              strokeWidth: 2,
              trimEnd: 0,
              properties: PathAnimationProperties(
                trimEnd: [
                  AnimationProperty(
                    tween: Tween<double>(end: 0),
                    interval: const AnimationInterval(
                      end: Duration(milliseconds: 0),
                    ),
                  ),
                  AnimationProperty(
                    tween: Tween<double>(end: 1),
                    interval: AnimationInterval.withDuration(
                      startOffset: const Duration(milliseconds: 350),
                      duration: const Duration(milliseconds: 250),
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
    duration: const Duration(milliseconds: 600),
    viewportSize: const Size(48, 24),
  );
}
