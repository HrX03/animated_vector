import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_parsing/path_parsing.dart';

typedef AnimationPropertySequence<T> = List<AnimationProperty<T>>;
typedef PathCommands = List<PathCommand>;
typedef VectorElements = List<VectorElement>;

class AnimatedVector extends StatelessWidget {
  final AnimatedVectorData vector;
  final Animation<double> progress;
  final Size? size;
  final Color? color;
  final double? opacity;
  final bool applyColor;

  const AnimatedVector({
    required this.vector,
    required this.progress,
    this.color,
    this.applyColor = false,
    this.opacity,
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        Widget child = CustomPaint(
          painter: _AnimatedVectorPainter(
            vector: vector,
            progress: progress.value,
          ),
          size: size ?? vector.viewportSize,
        );

        if (opacity != null) {
          child = Opacity(
            opacity: opacity ?? 1.0,
            child: child,
          );
        }

        if (applyColor) {
          child = ColorFiltered(
            colorFilter: ColorFilter.mode(
              color ?? Theme.of(context).iconTheme.color ?? Colors.black,
              BlendMode.srcIn,
            ),
            child: child,
          );
        }

        return child;
      },
    );
  }
}

class _AnimatedVectorPainter extends CustomPainter {
  final AnimatedVectorData vector;
  final double progress;

  const _AnimatedVectorPainter({
    required this.vector,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(
      size.width / vector.viewportSize.width,
      size.height / vector.viewportSize.height,
    );

    for (final VectorElement element in vector.elements) {
      element.paint(canvas, progress, vector.duration);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedVectorPainter old) {
    return vector != old.vector || progress != old.progress;
  }
}

class AnimatedVectorData {
  final VectorElements elements;
  final Duration duration;
  final Size viewportSize;

  const AnimatedVectorData({
    required this.elements,
    required this.duration,
    required this.viewportSize,
  });

  @override
  int get hashCode => hashValues(
        elements.hashCode,
        duration.hashCode,
        viewportSize.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is AnimatedVectorData) {
      return listEquals(elements, other.elements) &&
          duration == other.duration &&
          viewportSize == other.viewportSize;
    }

    return false;
  }
}

abstract class VectorElement {
  const VectorElement();

  VectorElement evaluate(
    double t, {
    Duration baseDuration = const Duration(milliseconds: 300),
  });

  void paint(Canvas canvas, double progress, Duration duration);

  T? evaluateProperties<T>(
    AnimationPropertySequence<T>? properties,
    T? defaultValue,
    Duration baseDuration,
    double t,
  ) {
    if (properties == null || properties.isEmpty) return defaultValue;

    final List<Interval> intervals = [];
    if (properties.length > 1) {
      for (int i = 1; i <= properties.length; i++) {
        final AnimationProperty<T> currentProperty = properties[i - 1];
        late final AnimationProperty<T> nextProperty;
        if (i != properties.length) {
          nextProperty = properties[i];
        } else {
          intervals.add(currentProperty.calculateIntervalCurve(baseDuration));
          break;
        }

        final Interval currentInterval =
            currentProperty.calculateIntervalCurve(baseDuration);
        final Interval nextInterval =
            nextProperty.calculateIntervalCurve(baseDuration);

        intervals.add(
          Interval(currentInterval.begin, nextInterval.begin),
        );
      }
    } else {
      intervals.add(properties.single.calculateIntervalCurve(baseDuration));
    }

    final List<Tween<T>> tweens = [];
    if (properties.length > 1) {
      for (int i = 0; i < properties.length; i++) {
        final AnimationProperty<T> currentProperty = properties[i];

        final Tween<T> t = currentProperty.tween;
        t.begin = t.begin ??
            AnimationProperties._getNearestDefaultForTween(
                properties, i, defaultValue,
                goDown: true);
        t.end = t.end ??
            AnimationProperties._getNearestDefaultForTween(
                properties, i, defaultValue);
        tweens.add(t);
      }
    } else {
      tweens.add(properties.single.tween);
    }

    late final int index;
    late final Curve c;

    if (t <= intervals.first.begin) {
      index = 0;
      c = intervals.first;
    } else if (t >= intervals.last.end) {
      index = intervals.length - 1;
      c = intervals.last;
    } else {
      index = intervals.indexWhere((i) => t >= i.begin && t <= i.end);
      c = intervals[index];
    }

    final double curvedT = c.transform(t);
    tweens[index].begin = tweens[index].begin ?? defaultValue;
    tweens[index].end = tweens[index].end ?? defaultValue;
    return tweens[index].transform(curvedT);
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
  void paint(Canvas canvas, double progress, Duration duration) {
    final GroupElement evaluated = evaluate(
      progress,
      baseDuration: duration,
    );

    Matrix4 transformMatrix = Matrix4.identity();
    transformMatrix = transformMatrix.clone()
      ..translate(evaluated.pivotX, evaluated.pivotY)
      ..multiply(Matrix4.rotationZ(evaluated.rotation * math.pi / 180))
      ..translate(-evaluated.pivotX, -evaluated.pivotY);
    transformMatrix.translate(evaluated.translateX, evaluated.translateY);
    transformMatrix.scale(evaluated.scaleX, evaluated.scaleY);

    canvas.save();
    canvas.transform(transformMatrix.storage);
    for (final VectorElement element in evaluated.elements) {
      element.paint(canvas, progress, duration);
    }
    canvas.restore();
  }

  @override
  int get hashCode => hashValues(
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
  final Color? strokeColor;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final double strokeMiterLimit;
  final double trimOffsetStart;
  final double trimOffsetEnd;
  final PathAnimationProperties properties;

  PathElement({
    required this.pathData,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.bevel,
    this.strokeMiterLimit = 4.0,
    this.trimOffsetStart = 0.0,
    this.trimOffsetEnd = 1.0,
    PathAnimationProperties? properties,
  })  : properties = properties ?? PathAnimationProperties(),
        assert(trimOffsetStart >= 0 && trimOffsetStart <= 1),
        assert(trimOffsetEnd >= 0 && trimOffsetEnd <= 1);

  @override
  PathElement evaluate(
    double t, {
    Duration baseDuration = const Duration(milliseconds: 300),
  }) {
    final PathData pathData = evaluateProperties(
        properties.pathData, this.pathData, baseDuration, t)!;
    final Color? fillColor = evaluateProperties(
        properties.fillColor, this.fillColor, baseDuration, t);
    final Color? strokeColor = evaluateProperties(
        properties.strokeColor, this.strokeColor, baseDuration, t);
    final double strokeWidth = evaluateProperties(
        properties.strokeWidth, this.strokeWidth, baseDuration, t)!;
    final double trimOffsetStart = evaluateProperties(
        properties.trimOffsetStart, this.trimOffsetStart, baseDuration, t)!;
    final double trimOffsetEnd = evaluateProperties(
        properties.trimOffsetEnd, this.trimOffsetEnd, baseDuration, t)!;

    return PathElement(
      pathData: pathData,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      strokeCap: strokeCap,
      strokeJoin: strokeJoin,
      strokeMiterLimit: strokeMiterLimit,
      trimOffsetStart: trimOffsetStart,
      trimOffsetEnd: trimOffsetEnd,
    );
  }

  @override
  void paint(Canvas canvas, double progress, Duration duration) {
    final PathElement evaluated = evaluate(
      progress,
      baseDuration: duration,
    );

    canvas.drawPath(
      evaluated.pathData.toPath(
        trimOffsetStart: evaluated.trimOffsetStart,
        trimOffsetEnd: evaluated.trimOffsetEnd,
      ),
      Paint()
        ..color = evaluated.strokeColor ?? Colors.transparent
        ..strokeWidth = evaluated.strokeWidth
        ..strokeCap = evaluated.strokeCap
        ..strokeJoin = evaluated.strokeJoin
        ..strokeMiterLimit = evaluated.strokeMiterLimit
        ..style = PaintingStyle.stroke,
    );
    canvas.drawPath(
      evaluated.pathData.toPath(
        trimOffsetStart: evaluated.trimOffsetStart,
        trimOffsetEnd: evaluated.trimOffsetEnd,
      ),
      Paint()..color = evaluated.fillColor ?? Colors.transparent,
    );
  }

  @override
  int get hashCode => hashValues(
        pathData.hashCode,
        fillColor.hashCode,
        strokeColor.hashCode,
        strokeWidth.hashCode,
        strokeCap.hashCode,
        strokeJoin.hashCode,
        strokeMiterLimit.hashCode,
        trimOffsetStart.hashCode,
        trimOffsetEnd.hashCode,
        properties.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is PathElement) {
      return pathData == other.pathData &&
          fillColor == other.fillColor &&
          strokeColor == other.strokeColor &&
          strokeWidth == other.strokeWidth &&
          strokeCap == other.strokeCap &&
          strokeJoin == other.strokeJoin &&
          strokeMiterLimit == other.strokeMiterLimit &&
          trimOffsetStart == other.trimOffsetStart &&
          trimOffsetEnd == other.trimOffsetEnd &&
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
    final PathData pathData = evaluateProperties(
        properties.pathData, this.pathData, baseDuration, t)!;

    return ClipPathElement(pathData: pathData);
  }

  @override
  void paint(Canvas canvas, double progress, Duration duration) {
    final ClipPathElement evaluated = evaluate(
      progress,
      baseDuration: duration,
    );

    canvas.clipPath(evaluated.pathData.toPath());
  }

  @override
  int get hashCode => hashValues(pathData.hashCode, properties.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is ClipPathElement) {
      return pathData == other.pathData && properties == other.properties;
    }

    return false;
  }
}

class PathDataTween extends Tween<PathData> {
  PathDataTween({PathData? begin, PathData? end})
      : super(begin: begin, end: end);

  @override
  PathData lerp(double t) {
    return PathData.lerp(begin!, end!, t);
  }

  @override
  int get hashCode => hashValues(begin.hashCode, end.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is PathDataTween) {
      return begin == other.begin && end == other.end;
    }

    return false;
  }
}

class PathData {
  final PathCommands operations;

  const PathData(this.operations);

  factory PathData.parse(String svg) {
    if (svg == '') {
      return const PathData([]);
    }

    final SvgPathStringSource parser = SvgPathStringSource(svg);
    final _PathCommandPathProxy path = _PathCommandPathProxy();
    final SvgPathNormalizer normalizer = SvgPathNormalizer();
    for (PathSegmentData seg in parser.parseSegments()) {
      normalizer.emitSegment(seg, path);
    }
    return PathData(path.operations);
  }

  static PathData lerp(PathData a, PathData b, double t) {
    assert(a.checkForCompatibility(b));
    final PathCommands interpolatedOperations = [];

    for (int i = 0; i < a.operations.length; i++) {
      interpolatedOperations.add(PathCommand.lerp(
        a.operations[i],
        b.operations[i],
        t,
      ));
    }

    return PathData(interpolatedOperations);
  }

  bool checkForCompatibility(PathData other) {
    if (operations.length != other.operations.length) return false;

    for (int i = 0;
        i < math.min(operations.length, other.operations.length);
        i++) {
      final PathCommand aItem = operations[i];
      final PathCommand bItem = operations[i];
      if (aItem.type != bItem.type) return false;
      if (aItem.points.length != bItem.points.length) return false;
    }
    return true;
  }

  Path toPath({
    double trimOffsetStart = 0.0,
    double trimOffsetEnd = 1.0,
  }) {
    final Path base = Path();

    for (final PathCommand operation in operations) {
      switch (operation.type) {
        case PathCommandType.moveTo:
          final double x = operation.points[0];
          final double y = operation.points[1];
          base.moveTo(x, y);
          break;
        case PathCommandType.lineTo:
          final double x = operation.points[0];
          final double y = operation.points[1];
          base.lineTo(x, y);
          break;
        case PathCommandType.curveTo:
          final double x1 = operation.points[0];
          final double y1 = operation.points[1];
          final double x2 = operation.points[2];
          final double y2 = operation.points[3];
          final double x = operation.points[4];
          final double y = operation.points[5];
          base.cubicTo(x1, y1, x2, y2, x, y);
          break;
        case PathCommandType.close:
          base.close();
          break;
      }
    }

    final Path trimStart = Path();
    for (final PathMetric metric in base.computeMetrics()) {
      trimStart.addPath(
        metric.extractPath(metric.length * trimOffsetStart, metric.length),
        Offset.zero,
      );
    }

    final Path trimEnd = Path();
    for (final PathMetric metric in trimStart.computeMetrics()) {
      trimEnd.addPath(
        metric.extractPath(0.0, metric.length * trimOffsetEnd),
        Offset.zero,
      );
    }

    return trimEnd;
  }

  @override
  int get hashCode => operations.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is PathData) {
      return listEquals(operations, other.operations);
    }

    return false;
  }
}

class PathCommand {
  final PathCommandType type;
  final List<double> points;

  PathCommand._raw(
    this.type,
    this.points,
  );

  PathCommand.moveTo(
    double x,
    double y,
  )   : type = PathCommandType.moveTo,
        points = [x, y];

  PathCommand.lineTo(
    double x,
    double y,
  )   : type = PathCommandType.lineTo,
        points = [x, y];

  PathCommand.curveTo(
    double x,
    double y,
    double x1,
    double y1,
    double x2,
    double y2,
  )   : type = PathCommandType.curveTo,
        points = [x1, y1, x2, y2, x, y];

  const PathCommand.close()
      : type = PathCommandType.close,
        points = const [];

  static PathCommand lerp(PathCommand start, PathCommand end, double progress) {
    assert(progress >= 0 && progress <= 1);
    assert(start.type == end.type);
    assert(start.points.length == end.points.length);

    final List<double> interpolatedPoints = [];

    for (int i = 0; i < math.min(start.points.length, end.points.length); i++) {
      interpolatedPoints.add(
        lerpDouble(
          start.points[i],
          end.points[i],
          progress,
        )!,
      );
    }

    return PathCommand._raw(start.type, interpolatedPoints);
  }

  @override
  int get hashCode => hashValues(type.hashCode, points.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is PathCommand) {
      return type == other.type && listEquals(points, other.points);
    }

    return false;
  }
}

class AnimationProperties {
  const AnimationProperties();

  static bool checkForIntervalsValidity(AnimationPropertySequence? properties) {
    if (properties == null) return true;

    Duration lastValidEndDuration = Duration.zero;

    for (final AnimationProperty property in properties) {
      if (property.interval.start >= lastValidEndDuration) {
        lastValidEndDuration = property.interval.end;
        continue;
      }
      return false;
    }

    return true;
  }

  static T _getNearestDefaultForTween<T>(
    AnimationPropertySequence<T> properties,
    int startIndex,
    T defaultValue, {
    bool goDown = false,
  }) {
    final List<Tween<T>> tweens = properties.map((p) => p.tween).toList();
    T? value;

    for (int i = startIndex;
        goDown ? i > 0 : i < properties.length;
        goDown ? i-- : i++) {
      if (value != null) break;
      value ??= goDown
          ? tweens.getOrNull(i - 1)?.end
          : tweens.getOrNull(i + 1)?.begin;
    }

    return value ?? defaultValue;
  }
}

class GroupAnimationProperties extends AnimationProperties {
  final AnimationPropertySequence<double>? translateX;
  final AnimationPropertySequence<double>? translateY;
  final AnimationPropertySequence<double>? scaleX;
  final AnimationPropertySequence<double>? scaleY;
  final AnimationPropertySequence<double>? pivotX;
  final AnimationPropertySequence<double>? pivotY;
  final AnimationPropertySequence<double>? rotation;

  const GroupAnimationProperties({
    this.translateX,
    this.translateY,
    this.scaleX,
    this.scaleY,
    this.pivotX,
    this.pivotY,
    this.rotation,
  });

  @override
  int get hashCode => hashValues(
        translateX,
        translateY,
        scaleX,
        scaleY,
        pivotX,
        pivotY,
        rotation,
      );

  @override
  bool operator ==(Object other) {
    if (other is GroupAnimationProperties) {
      return listEquals(translateX, other.translateX) &&
          listEquals(translateY, other.translateY) &&
          listEquals(scaleX, other.scaleX) &&
          listEquals(scaleY, other.scaleY) &&
          listEquals(pivotX, other.pivotX) &&
          listEquals(pivotY, other.pivotY) &&
          listEquals(rotation, other.rotation);
    }

    return false;
  }
}

class PathAnimationProperties extends AnimationProperties {
  final AnimationPropertySequence<PathData>? pathData;
  final AnimationPropertySequence<Color>? fillColor;
  final AnimationPropertySequence<Color>? strokeColor;
  final AnimationPropertySequence<double>? strokeWidth;
  final AnimationPropertySequence<double>? trimOffsetStart;
  final AnimationPropertySequence<double>? trimOffsetEnd;

  PathAnimationProperties({
    this.pathData,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth,
    this.trimOffsetStart,
    this.trimOffsetEnd,
  })  : assert(AnimationProperties.checkForIntervalsValidity(pathData)),
        assert(AnimationProperties.checkForIntervalsValidity(fillColor)),
        assert(AnimationProperties.checkForIntervalsValidity(strokeColor)),
        assert(AnimationProperties.checkForIntervalsValidity(strokeWidth)),
        assert(AnimationProperties.checkForIntervalsValidity(trimOffsetStart)),
        assert(AnimationProperties.checkForIntervalsValidity(trimOffsetEnd));

  @override
  int get hashCode => hashValues(
        pathData,
        fillColor,
        strokeColor,
        strokeWidth,
        trimOffsetStart,
        trimOffsetEnd,
      );

  @override
  bool operator ==(Object other) {
    if (other is PathAnimationProperties) {
      return listEquals(pathData, other.pathData) &&
          listEquals(fillColor, other.fillColor) &&
          listEquals(strokeColor, other.strokeColor) &&
          listEquals(strokeWidth, other.strokeWidth) &&
          listEquals(trimOffsetStart, other.trimOffsetStart) &&
          listEquals(trimOffsetEnd, other.trimOffsetEnd);
    }

    return false;
  }
}

class ClipPathAnimationProperties extends AnimationProperties {
  final AnimationPropertySequence<PathData>? pathData;

  const ClipPathAnimationProperties({this.pathData});

  @override
  int get hashCode => pathData.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is ClipPathAnimationProperties) {
      return listEquals(pathData, other.pathData);
    }

    return false;
  }
}

class AnimationProperty<T> {
  final Tween<T> tween;
  final AnimationInterval interval;
  final Curve curve;

  const AnimationProperty({
    required this.tween,
    required this.interval,
    this.curve = Curves.linear,
  });

  T evaluate(T? defaultValue, Duration baseDuration, double t) {
    final Curve c = calculateIntervalCurve(baseDuration);

    final double curvedT = c.transform(t);
    tween.begin = tween.begin ?? defaultValue;
    tween.end = tween.end ?? defaultValue;
    return tween.transform(curvedT);
  }

  Interval calculateIntervalCurve(Duration baseDuration) {
    final int start =
        interval.start.inMilliseconds.clamp(0, baseDuration.inMilliseconds);
    final int end =
        interval.end.inMilliseconds.clamp(0, baseDuration.inMilliseconds);

    return Interval(
      start / baseDuration.inMilliseconds,
      end / baseDuration.inMilliseconds,
      curve: curve,
    );
  }

  @override
  int get hashCode => hashValues(
        tween.hashCode,
        interval.hashCode,
        curve.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is AnimationProperty) {
      return tween == other.tween &&
          interval == other.interval &&
          curve == other.curve;
    }

    return false;
  }
}

class AnimationInterval {
  final Duration start;
  final Duration end;

  const AnimationInterval({
    this.start = Duration.zero,
    required this.end,
  });

  AnimationInterval.withDuration({
    Duration startOffset = Duration.zero,
    required Duration duration,
  })  : start = startOffset,
        end = Duration(
          microseconds: startOffset.inMicroseconds + duration.inMicroseconds,
        );

  @override
  int get hashCode => hashValues(start.hashCode, end.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is AnimationInterval) {
      return start == other.start && end == other.end;
    }

    return false;
  }
}

enum PathCommandType {
  moveTo,
  lineTo,
  curveTo,
  close,
}

class _PathCommandPathProxy implements PathProxy {
  final PathCommands operations = [];

  @override
  void close() {
    operations.add(const PathCommand.close());
  }

  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    operations.add(PathCommand.curveTo(x3, y3, x1, y1, x2, y2));
  }

  @override
  void lineTo(double x, double y) {
    operations.add(PathCommand.lineTo(x, y));
  }

  @override
  void moveTo(double x, double y) {
    operations.add(PathCommand.moveTo(x, y));
  }
}

extension _ListNullGet<T> on List<T> {
  T? getOrNull(int index) {
    if (index < 0 || index > length - 1) {
      return null;
    }
    return this[index];
  }
}
