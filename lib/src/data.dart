import 'dart:math' as math;

import 'package:animated_vector/src/animation.dart';
import 'package:animated_vector/src/path.dart';
import 'package:animated_vector/src/shapeshifter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

typedef VectorElements = List<VectorElement>;

class AnimatedVectorData {
  final RootVectorElement root;
  final Duration duration;
  final Size viewportSize;

  const AnimatedVectorData({
    required this.root,
    required this.duration,
    required this.viewportSize,
  });

  @override
  int get hashCode => Object.hash(
        root.hashCode,
        duration.hashCode,
        viewportSize.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is AnimatedVectorData) {
      return root == other.root &&
          duration == other.duration &&
          viewportSize == other.viewportSize;
    }

    return false;
  }

  Map<String, dynamic> toJson(String name) {
    return ShapeshifterConverter.toJson(this, name);
  }
}

abstract class VectorElement {
  const VectorElement();

  VectorElement evaluate(
    double t, {
    Duration baseDuration = const Duration(milliseconds: 300),
  });

  void paint(Canvas canvas, Size size, double progress, Duration duration);

  T? evaluateProperties<T>(
    AnimationPropertySequence<T?>? properties,
    T? defaultValue,
    Duration baseDuration,
    double t,
  ) {
    if (properties == null || properties.isEmpty) return defaultValue;

    final AnimationTimeline<T?> timeline =
        AnimationTimeline(properties, baseDuration, defaultValue);

    return timeline.evaluate(t) ?? defaultValue;
  }
}

class RootVectorElement extends VectorElement {
  final double alpha;
  final RootVectorAnimationProperties properties;
  final VectorElements elements;

  const RootVectorElement({
    this.alpha = 1.0,
    this.properties = const RootVectorAnimationProperties(),
    this.elements = const [],
  });

  @override
  RootVectorElement evaluate(
    double t, {
    Duration baseDuration = const Duration(milliseconds: 300),
  }) {
    properties.checkForValidity();

    final double alpha =
        evaluateProperties(properties.alpha, this.alpha, baseDuration, t)!;

    return RootVectorElement(
      alpha: alpha,
      elements: elements,
    );
  }

  @override
  void paint(Canvas canvas, Size size, double progress, Duration duration) {
    final RootVectorElement evaluated = evaluate(
      progress,
      baseDuration: duration,
    );

    canvas.saveLayer(
      Offset.zero & size,
      Paint()
        ..colorFilter = ColorFilter.mode(
          const Color(0xFFFFFFFF).withOpacity(evaluated.alpha),
          BlendMode.modulate,
        ),
    );
    for (final VectorElement element in evaluated.elements) {
      element.paint(canvas, size, progress, duration);
    }
    canvas.restore();
  }

  @override
  int get hashCode => Object.hash(
        alpha.hashCode,
        elements.hashCode,
        properties.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is RootVectorElement) {
      return alpha == other.alpha &&
          listEquals(elements, other.elements) &&
          properties == other.properties;
    }

    return false;
  }
}

class GroupElement extends VectorElement {
  final double translateX;
  final double translateY;
  final double scaleX;
  final double scaleY;
  final double pivotX;
  final double pivotY;
  final double rotation;
  final GroupAnimationProperties properties;
  final VectorElements elements;

  const GroupElement({
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.pivotX = 0.0,
    this.pivotY = 0.0,
    this.rotation = 0.0,
    this.properties = const GroupAnimationProperties(),
    this.elements = const [],
  });

  @override
  GroupElement evaluate(
    double t, {
    Duration baseDuration = const Duration(milliseconds: 300),
  }) {
    properties.checkForValidity();

    final double translateX = evaluateProperties(
        properties.translateX, this.translateX, baseDuration, t)!;
    final double translateY = evaluateProperties(
        properties.translateY, this.translateY, baseDuration, t)!;
    final double scaleX =
        evaluateProperties(properties.scaleX, this.scaleX, baseDuration, t)!;
    final double scaleY =
        evaluateProperties(properties.scaleY, this.scaleY, baseDuration, t)!;
    final double pivotX =
        evaluateProperties(properties.pivotX, this.pivotX, baseDuration, t)!;
    final double pivotY =
        evaluateProperties(properties.pivotY, this.pivotY, baseDuration, t)!;
    final double rotation = evaluateProperties(
        properties.rotation, this.rotation, baseDuration, t)!;

    return GroupElement(
      translateX: translateX,
      translateY: translateY,
      scaleX: scaleX,
      scaleY: scaleY,
      pivotX: pivotX,
      pivotY: pivotY,
      rotation: rotation,
      elements: elements,
    );
  }

  @override
  void paint(Canvas canvas, Size size, double progress, Duration duration) {
    final GroupElement evaluated = evaluate(
      progress,
      baseDuration: duration,
    );

    Matrix4 transformMatrix = Matrix4.identity();
    transformMatrix.translate(evaluated.translateX, evaluated.translateY);
    transformMatrix = transformMatrix.clone()
      ..translate(evaluated.pivotX, evaluated.pivotY)
      ..rotateZ(evaluated.rotation * math.pi / 180)
      ..scale(evaluated.scaleX, evaluated.scaleY)
      ..translate(-evaluated.pivotX, -evaluated.pivotY);

    canvas.save();
    canvas.transform(transformMatrix.storage);
    for (final VectorElement element in evaluated.elements) {
      element.paint(canvas, size, progress, duration);
    }
    canvas.restore();
  }

  @override
  int get hashCode => Object.hash(
        translateX.hashCode,
        translateY.hashCode,
        scaleX.hashCode,
        scaleY.hashCode,
        pivotX.hashCode,
        pivotY.hashCode,
        rotation.hashCode,
        elements.hashCode,
        properties.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is GroupElement) {
      return translateX == other.translateX &&
          translateY == other.translateY &&
          scaleX == other.scaleX &&
          scaleY == other.scaleY &&
          pivotX == other.pivotX &&
          pivotY == other.pivotY &&
          rotation == other.rotation &&
          listEquals(elements, other.elements) &&
          properties == other.properties;
    }

    return false;
  }
}

class PathElement extends VectorElement {
  final PathData pathData;
  final Color? fillColor;
  final double fillAlpha;
  final Color? strokeColor;
  final double strokeAlpha;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final double strokeMiterLimit;
  final double trimStart;
  final double trimEnd;
  final double trimOffset;
  final PathAnimationProperties properties;

  const PathElement({
    required this.pathData,
    this.fillColor,
    this.fillAlpha = 1.0,
    this.strokeColor,
    this.strokeAlpha = 1.0,
    this.strokeWidth = 1.0,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    this.strokeMiterLimit = 4.0,
    this.trimStart = 0.0,
    this.trimEnd = 1.0,
    this.trimOffset = 0.0,
    this.properties = const PathAnimationProperties(),
  })  : assert(trimStart >= 0 && trimStart <= 1),
        assert(trimEnd >= 0 && trimEnd <= 1),
        assert(trimOffset >= 0 && trimOffset <= 1);

  @override
  PathElement evaluate(
    double t, {
    Duration baseDuration = const Duration(milliseconds: 300),
  }) {
    properties.checkForValidity();

    final PathData pathData = evaluateProperties(
        properties.pathData, this.pathData, baseDuration, t)!;
    final Color? fillColor = evaluateProperties(
        properties.fillColor, this.fillColor, baseDuration, t);
    final double fillAlpha = evaluateProperties(
        properties.fillAlpha, this.fillAlpha, baseDuration, t)!;
    final Color? strokeColor = evaluateProperties(
        properties.strokeColor, this.strokeColor, baseDuration, t);
    final double strokeAlpha = evaluateProperties(
        properties.strokeAlpha, this.strokeAlpha, baseDuration, t)!;
    final double strokeWidth = evaluateProperties(
        properties.strokeWidth, this.strokeWidth, baseDuration, t)!;
    final double trimStart = evaluateProperties(
        properties.trimStart, this.trimStart, baseDuration, t)!;
    final double trimEnd =
        evaluateProperties(properties.trimEnd, this.trimEnd, baseDuration, t)!;
    final double trimOffset = evaluateProperties(
        properties.trimOffset, this.trimOffset, baseDuration, t)!;

    return PathElement(
      pathData: pathData,
      fillColor: fillColor,
      fillAlpha: fillAlpha,
      strokeColor: strokeColor,
      strokeAlpha: strokeAlpha,
      strokeWidth: strokeWidth,
      strokeCap: strokeCap,
      strokeJoin: strokeJoin,
      strokeMiterLimit: strokeMiterLimit,
      trimStart: trimStart,
      trimEnd: trimEnd,
      trimOffset: trimOffset,
    );
  }

  @override
  void paint(Canvas canvas, Size size, double progress, Duration duration) {
    final PathElement evaluated = evaluate(
      progress,
      baseDuration: duration,
    );

    final Color fillColor = evaluated.fillColor ?? const Color(0x00000000);
    final Color strokeColor = evaluated.strokeColor ?? const Color(0x00000000);

    if (evaluated.strokeWidth > 0 && evaluated.strokeColor != null) {
      canvas.drawPath(
        evaluated.pathData.toPath(
          trimStart: evaluated.trimStart,
          trimEnd: evaluated.trimEnd,
          trimOffset: evaluated.trimOffset,
        ),
        Paint()
          ..color = strokeColor
              .withOpacity(strokeColor.opacity * evaluated.strokeAlpha)
          ..strokeWidth = evaluated.strokeWidth
          ..strokeCap = evaluated.strokeCap
          ..strokeJoin = evaluated.strokeJoin
          ..strokeMiterLimit = evaluated.strokeMiterLimit
          ..style = PaintingStyle.stroke,
      );
    }
    canvas.drawPath(
      evaluated.pathData.toPath(),
      Paint()
        ..color =
            fillColor.withOpacity(fillColor.opacity * evaluated.fillAlpha),
    );
  }

  @override
  int get hashCode => Object.hash(
        pathData.hashCode,
        fillColor.hashCode,
        fillAlpha.hashCode,
        strokeColor.hashCode,
        strokeAlpha.hashCode,
        strokeWidth.hashCode,
        strokeCap.hashCode,
        strokeJoin.hashCode,
        strokeMiterLimit.hashCode,
        trimStart.hashCode,
        trimEnd.hashCode,
        trimOffset.hashCode,
        properties.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is PathElement) {
      return pathData == other.pathData &&
          fillColor == other.fillColor &&
          fillAlpha == other.fillAlpha &&
          strokeColor == other.strokeColor &&
          strokeAlpha == other.strokeAlpha &&
          strokeWidth == other.strokeWidth &&
          strokeCap == other.strokeCap &&
          strokeJoin == other.strokeJoin &&
          strokeMiterLimit == other.strokeMiterLimit &&
          trimStart == other.trimStart &&
          trimEnd == other.trimEnd &&
          trimOffset == other.trimOffset &&
          properties == other.properties;
    }

    return false;
  }
}

class ClipPathElement extends VectorElement {
  final PathData pathData;
  final ClipPathAnimationProperties properties;

  const ClipPathElement({
    required this.pathData,
    this.properties = const ClipPathAnimationProperties(),
  });

  @override
  ClipPathElement evaluate(
    double t, {
    Duration baseDuration = const Duration(milliseconds: 300),
  }) {
    properties.checkForValidity();

    final PathData pathData = evaluateProperties(
        properties.pathData, this.pathData, baseDuration, t)!;

    return ClipPathElement(pathData: pathData);
  }

  @override
  void paint(Canvas canvas, Size size, double progress, Duration duration) {
    final ClipPathElement evaluated = evaluate(
      progress,
      baseDuration: duration,
    );

    canvas.clipPath(evaluated.pathData.toPath());
  }

  @override
  int get hashCode => Object.hash(pathData.hashCode, properties.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is ClipPathElement) {
      return pathData == other.pathData && properties == other.properties;
    }

    return false;
  }
}
