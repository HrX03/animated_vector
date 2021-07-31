import 'dart:math' as math;
import 'dart:ui';

import 'package:animated_vector/src/extensions.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:path_parsing/path_parsing.dart';

typedef PathCommands = List<PathCommand>;

class PathData {
  final PathCommands operations;

  const PathData(this.operations);

  factory PathData.parse(String svg) {
    if (svg == '') {
      return const PathData([]);
    }

    if (!svg.toUpperCase().startsWith("M")) {
      svg = "M 0 0 $svg";
    }

    final SvgPathStringSource parser = SvgPathStringSource(svg);
    final _PathCommandPathProxy path = _PathCommandPathProxy();
    final SvgPathNormalizer normalizer = SvgPathNormalizer();
    for (PathSegmentData seg in parser.parseSegments()) {
      normalizer.emitSegment(seg, path);
    }
    return PathData(path.operations);
  }

  static PathData? tryParse(String svg) {
    try {
      return PathData.parse(svg);
    } on StateError {
      return null;
    }
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
    double trimStart = 0.0,
    double trimEnd = 1.0,
    double trimOffset = 0.0,
  }) {
    if (trimStart == trimEnd) return Path();

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

    if (trimStart == 0.0 && trimEnd == 1.0) return base;

    final Path trimPath = Path();
    for (final PathMetric metric in base.computeMetrics()) {
      final double offset = metric.length * trimOffset;
      double start = metric.length * trimStart + offset;
      double end = metric.length * trimEnd + offset;
      start = start.wrap(0, metric.length);
      end = end.wrap(0, metric.length);

      final Path path;

      if (end <= start) {
        final Path lower = metric.extractPath(0.0, end);
        final Path higher = metric.extractPath(start, metric.length);
        path = Path()
          ..addPath(lower, Offset.zero)
          ..addPath(higher, Offset.zero);
      } else {
        path = metric.extractPath(start, end);
      }

      trimPath.addPath(path, Offset.zero);
    }

    return trimPath;
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

  @override
  String toString() {
    return operations.join(" ");
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

  @override
  String toString() {
    switch (type) {
      case PathCommandType.moveTo:
        return "M ${points[0].eventuallyAsInt} ${points[1].eventuallyAsInt}";
      case PathCommandType.lineTo:
        return "L ${points[0].eventuallyAsInt} ${points[1].eventuallyAsInt}";
      case PathCommandType.curveTo:
        return "C ${points[0].eventuallyAsInt} ${points[1].eventuallyAsInt} ${points[2].eventuallyAsInt} ${points[3].eventuallyAsInt} ${points[4].eventuallyAsInt} ${points[5].eventuallyAsInt}";
      case PathCommandType.close:
        return "Z";
    }
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
