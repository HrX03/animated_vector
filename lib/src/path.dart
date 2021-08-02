import 'dart:ui';

import 'package:animated_vector/src/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:path_parsing/path_parsing.dart';

typedef PathCommands = List<PathCommand>;

class PathData {
  final PathCommands _operations;

  const PathData(this._operations);

  PathCommands get operations => _operations;

  const factory PathData.parse(String svg) = PathDataParse;

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
      interpolatedOperations.add(a.operations[i].lerp(b.operations[i], t));
    }

    return PathData(interpolatedOperations);
  }

  bool checkForCompatibility(PathData other) {
    if (operations.length != other.operations.length) return false;

    for (int i = 0; i < operations.length; i++) {
      final PathCommand aItem = operations[i];
      final PathCommand bItem = operations[i];
      if (aItem.type != bItem.type) return false;
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
      operation.applyToPath(base);
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

class PathDataParse extends PathData {
  final String svg;

  const PathDataParse(this.svg) : super(const []);

  @override
  PathCommands get operations {
    String _svg = svg;
    if (_svg == '') {
      return [];
    }

    if (!_svg.toUpperCase().startsWith("M")) {
      _svg = "M 0 0 $svg";
    }

    final SvgPathStringSource parser = SvgPathStringSource(_svg);
    final _PathCommandPathProxy path = _PathCommandPathProxy();
    final SvgPathNormalizer normalizer = SvgPathNormalizer();
    for (PathSegmentData seg in parser.parseSegments()) {
      normalizer.emitSegment(seg, path);
    }
    return path.operations;
  }
}

abstract class PathCommand {
  final PathCommandType type;

  const PathCommand(this.type);

  PathCommand lerp(PathCommand other, double progress);

  void applyToPath(Path path);
}

class PathMoveTo extends PathCommand {
  final double x;
  final double y;

  const PathMoveTo(this.x, this.y) : super(PathCommandType.moveTo);

  @override
  PathMoveTo lerp(PathCommand other, double progress) {
    assert(type == other.type);
    if (other is! PathMoveTo) {
      throw PathCommandsIncompatibleException(PathMoveTo, other.runtimeType);
    }
    progress = progress.clamp(0.0, 1.0);

    return PathMoveTo(
      lerpDouble(x, other.x, progress)!,
      lerpDouble(y, other.y, progress)!,
    );
  }

  @override
  void applyToPath(Path path) {
    path.moveTo(x, y);
  }

  @override
  String toString() => "M ${x.eventuallyAsInt} ${y.eventuallyAsInt}";

  @override
  int get hashCode => hashValues(x.hashCode, y.hashCode, type.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is PathMoveTo) {
      return type == other.type && x == other.x && y == other.y;
    }

    return false;
  }
}

class PathLineTo extends PathCommand {
  final double x;
  final double y;

  const PathLineTo(this.x, this.y) : super(PathCommandType.lineTo);

  @override
  PathLineTo lerp(PathCommand other, double progress) {
    assert(type == other.type);
    if (other is! PathLineTo) {
      throw PathCommandsIncompatibleException(PathLineTo, other.runtimeType);
    }
    progress = progress.clamp(0.0, 1.0);

    return PathLineTo(
      lerpDouble(x, other.x, progress)!,
      lerpDouble(y, other.y, progress)!,
    );
  }

  @override
  void applyToPath(Path path) {
    path.lineTo(x, y);
  }

  @override
  String toString() => "L ${x.eventuallyAsInt} ${y.eventuallyAsInt}";

  @override
  int get hashCode => hashValues(x.hashCode, y.hashCode, type.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is PathLineTo) {
      return type == other.type && x == other.x && y == other.y;
    }

    return false;
  }
}

class PathCurveTo extends PathCommand {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double x3;
  final double y3;

  const PathCurveTo(
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    this.x3,
    this.y3,
  ) : super(PathCommandType.curveTo);

  @override
  PathCurveTo lerp(PathCommand other, double progress) {
    assert(type == other.type);
    if (other is! PathCurveTo) {
      throw PathCommandsIncompatibleException(PathCurveTo, other.runtimeType);
    }
    progress = progress.clamp(0.0, 1.0);

    return PathCurveTo(
      lerpDouble(x1, other.x1, progress)!,
      lerpDouble(y1, other.y1, progress)!,
      lerpDouble(x2, other.x2, progress)!,
      lerpDouble(y2, other.y2, progress)!,
      lerpDouble(x3, other.x3, progress)!,
      lerpDouble(y3, other.y3, progress)!,
    );
  }

  @override
  void applyToPath(Path path) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  String toString() =>
      "C ${x1.eventuallyAsInt} ${y1.eventuallyAsInt} ${x2.eventuallyAsInt} ${y2.eventuallyAsInt} ${x3.eventuallyAsInt} ${y3.eventuallyAsInt}";

  @override
  int get hashCode => hashValues(
        x1.hashCode,
        y1.hashCode,
        x2.hashCode,
        y2.hashCode,
        x3.hashCode,
        y3.hashCode,
        type.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is PathCurveTo) {
      return type == other.type &&
          x1 == other.x1 &&
          y1 == other.y1 &&
          x2 == other.x2 &&
          y2 == other.y2 &&
          x3 == other.x3 &&
          y3 == other.y3;
    }

    return false;
  }
}

class PathClose extends PathCommand {
  const PathClose() : super(PathCommandType.close);

  @override
  PathClose lerp(PathCommand other, double progress) {
    assert(type == other.type);
    if (other is! PathClose) {
      throw PathCommandsIncompatibleException(PathClose, other.runtimeType);
    }
    progress = progress.clamp(0.0, 1.0);

    return const PathClose();
  }

  @override
  void applyToPath(Path path) {
    path.close();
  }

  @override
  String toString() => "Z";

  @override
  int get hashCode => type.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is PathClose) {
      return type == other.type;
    }

    return false;
  }
}

class PathCommandsIncompatibleException implements Exception {
  final Type expectedType;
  final Type receivedType;

  const PathCommandsIncompatibleException(this.expectedType, this.receivedType);

  @override
  String toString() {
    return "Tried to lerp two incompatible PathCommands, a $expectedType was needed but got a $receivedType";
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
    operations.add(const PathClose());
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
    operations.add(PathCurveTo(x1, y1, x2, y2, x3, y3));
  }

  @override
  void lineTo(double x, double y) {
    operations.add(PathLineTo(x, y));
  }

  @override
  void moveTo(double x, double y) {
    operations.add(PathMoveTo(x, y));
  }
}
