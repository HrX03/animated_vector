import 'dart:ui';

import 'package:animated_vector/src/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:path_parsing/path_parsing.dart';

/// A list of commands to build a path. Refer to [PathCommand] for more info
typedef PathCommands = List<PathCommand>;

/// A class that represents [svg path data](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d).
///
/// The default constructor uses a list of [PathCommand] to build its path.
/// To parse a path from SVG data use [PathData.parse].
///
/// To retrieve the operations stored within use the [PathData.operations] getter.
class PathData {
  final PathCommands _operations;

  /// Builds a new instance of [PathData] by using a list of [PathCommand]s.
  ///
  /// An easier way to build a [PathData] instance is by using [PathData.parse].
  const PathData(this._operations);

  /// The currently stored operations for this PathData
  PathCommands get operations => _operations;

  /// Builds a new instance of [PathData] using the [PathDataParse] class.
  ///
  /// The [svg] string is parsed only when [operations] is called and when the
  /// [PathCache] instance doesn't have a cached version of this path.
  const factory PathData.parse(String svg) = PathDataParse;

  /// Interpolates between two [PathData]s given an interval [t] that is described
  /// between 1.0 and 0.0 both inclusive.
  ///
  /// The two paths must be non null and compatible, which means they have to have
  /// the same length and the same commands must appear in the same order.
  factory PathData.lerp(PathData a, PathData b, double t) {
    assert(a.checkForCompatibility(b));
    final PathCommands interpolatedOperations = [];

    for (int i = 0; i < a.operations.length; i++) {
      interpolatedOperations.add(a.operations[i].lerp(b.operations[i], t));
    }

    return PathData(interpolatedOperations);
  }

  /// Check whether two paths can be interpolated between each other.
  ///
  /// Two paths are considered compatible if they have the same amount of commands
  /// and each pair of commands is of the same type.
  bool checkForCompatibility(PathData other) {
    if (operations.length != other.operations.length) return false;

    for (int i = 0; i < operations.length; i++) {
      final PathCommand aItem = operations[i];
      final PathCommand bItem = operations[i];
      if (aItem.type != bItem.type) return false;
    }
    return true;
  }

  /// Convert this PathData into a dart:ui [Path] object.
  /// This can then be used to paint inside a [Canvas] with [Canvas.drawPath].
  ///
  /// The three optional parameters [trimStart], [trimEnd] and [trimOffset] work
  /// especially best with stroked paths, they are used to cut the path using these
  /// points as percentages.
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

/// A specialized instance of [PathData] that is able to
/// build a list of [PathCommand] using the path data inside [svg].
///
/// This is the class that is used by [PathData.parse]
class PathDataParse extends PathData {
  /// The svg string to parse. Follows the conventions described in [this article](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d).
  final String svg;

  /// Builds a new instance of [PathDataParse].
  ///
  /// The [svg] string is parsed only when [operations] is called and when the
  /// [PathCache] instance doesn't have a cached version of this path.
  const PathDataParse(this.svg) : super(const []);

  /// The list of operations computed from the [svg] path data.
  /// Calling this the first time will cause the svg to be computed, afterwards
  /// a cached version of the commands list will be used instead.
  @override
  PathCommands get operations => PathCache.instance.get(this, _parse);

  PathCommands _parse() {
    String svg = this.svg;
    if (svg == '') return [];

    if (!svg.toUpperCase().startsWith("M")) {
      svg = "M 0 0 ${this.svg}";
    }

    final SvgPathStringSource parser = SvgPathStringSource(svg);
    final _PathCommandPathProxy path = _PathCommandPathProxy();
    final SvgPathNormalizer normalizer = SvgPathNormalizer();
    for (final seg in parser.parseSegments()) {
      normalizer.emitSegment(seg, path);
    }
    return path.operations;
  }

  @override
  int get hashCode => svg.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is PathDataParse) {
      return svg == other.svg;
    }

    return false;
  }

  @override
  String toString() {
    return svg;
  }
}

/// A cache for [PathDataParse] classes to avoid parsing and computing the svg
/// path each time the operations array is requested.
///
/// Use the [PathCache.instance] to access the singleton instance instead of building
/// a new instance.
final class PathCache {
  final Expando<PathCommands> _cache = Expando<PathCommands>();

  /// The singleton instance that [PathDataParse.operations] uses.
  /// Avoid building fresh instances where possible.
  static final PathCache instance = PathCache();

  /// Get stored [PathCommands] using a [PathDataParse] instance as [key].
  /// [onCacheMiss] will be called if there is no associated commands inside the
  /// cache for the specificed [key].
  PathCommands get(PathDataParse key, PathCommands Function() onCacheMiss) {
    return _cache[key] ?? (_cache[key] = onCacheMiss());
  }
}

/// A command inside inside a [PathData] instance.
/// Four types are available:
/// - [PathMoveTo], equivalent to the move to command or M in svg
/// - [PathLineTo], equivalent to the line to command or L in svg
/// - [PathCurveTo], equivalent to the cubic command or C in svg
/// - [PathClose], equivalent to the close command or Z in svg
sealed class PathCommand {
  /// The type of path command between move, line, cubic and close.
  /// Used to check for compatibility between commands.
  final PathCommandType type;

  /// Construct a new instance of [PathCommand] with a specific [type].
  const PathCommand(this.type);

  /// Interpolates between this and another command.
  /// The two commands must be of the same [type].
  PathCommand lerp(PathCommand other, double progress);

  /// Apply this command to the passed in [path].
  void applyToPath(Path path);
}

/// Represents an absolute [move to path command](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d#moveto_path_commands).
/// The point to move to is represented by its [x] and [y] coordinates.
class PathMoveTo extends PathCommand {
  /// The x coordinate of the point to move to.
  final double x;

  /// The y coordinate of the point to move to.
  final double y;

  /// Construct a new instance of [PathMoveTo]. Its [type] is [PathCommandType.moveTo].
  const PathMoveTo(this.x, this.y) : super(PathCommandType.moveTo);

  @override
  PathMoveTo lerp(PathCommand other, double progress) {
    assert(type == other.type);
    if (other is! PathMoveTo) {
      throw PathCommandsIncompatibleException(PathMoveTo, other.runtimeType);
    }
    final clampedProgress = progress.clamp(0.0, 1.0);

    return PathMoveTo(
      lerpDouble(x, other.x, clampedProgress)!,
      lerpDouble(y, other.y, clampedProgress)!,
    );
  }

  @override
  void applyToPath(Path path) {
    path.moveTo(x, y);
  }

  @override
  String toString() => "M ${x.eventuallyAsInt} ${y.eventuallyAsInt}";

  @override
  int get hashCode => Object.hash(x, y, type);

  @override
  bool operator ==(Object other) {
    if (other is PathMoveTo) {
      return type == other.type && x == other.x && y == other.y;
    }

    return false;
  }
}

/// Represents an absolute [line to path command](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d#lineto_path_commands).
/// The point to draw a line to is represented by its [x] and [y] coordinates.
/// The first point of the line is represented by the last drawn point.
class PathLineTo extends PathCommand {
  /// The x coordinate of the point to move to.
  final double x;

  /// The y coordinate of the point to move to.
  final double y;

  /// Construct a new instance of [PathLineTo]. Its [type] is [PathCommandType.lineTo].
  const PathLineTo(this.x, this.y) : super(PathCommandType.lineTo);

  @override
  PathLineTo lerp(PathCommand other, double progress) {
    assert(type == other.type);
    if (other is! PathLineTo) {
      throw PathCommandsIncompatibleException(PathLineTo, other.runtimeType);
    }
    final clampedProgress = progress.clamp(0.0, 1.0);

    return PathLineTo(
      lerpDouble(x, other.x, clampedProgress)!,
      lerpDouble(y, other.y, clampedProgress)!,
    );
  }

  @override
  void applyToPath(Path path) {
    path.lineTo(x, y);
  }

  @override
  String toString() => "L ${x.eventuallyAsInt} ${y.eventuallyAsInt}";

  @override
  int get hashCode => Object.hash(x, y, type);

  @override
  bool operator ==(Object other) {
    if (other is PathLineTo) {
      return type == other.type && x == other.x && y == other.y;
    }

    return false;
  }
}

/// Represents an absolute [cubic to path command](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d#cubic_b%C3%A9zier_curve).
/// The cubic will use [x1] and [y1] as its first control point, [x2] and [y2]
/// as its second control point and [x3] and [y3] as its end point.
/// The first point of the curve is represented by the last drawn point.
class PathCurveTo extends PathCommand {
  /// The x coordinate of the first control point.
  final double x1;

  /// The y coordinate of the first control point.
  final double y1;

  /// The x coordinate of the second control point.
  final double x2;

  /// The y coordinate of the second control point.
  final double y2;

  /// The x coordinate of the curve end point.
  final double x3;

  /// The y coordinate of the curve end point.
  final double y3;

  /// Construct a new instance of [PathCurveTo]. Its [type] is [PathCommandType.curveTo].
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
    final clampedProgress = progress.clamp(0.0, 1.0);

    return PathCurveTo(
      lerpDouble(x1, other.x1, clampedProgress)!,
      lerpDouble(y1, other.y1, clampedProgress)!,
      lerpDouble(x2, other.x2, clampedProgress)!,
      lerpDouble(y2, other.y2, clampedProgress)!,
      lerpDouble(x3, other.x3, clampedProgress)!,
      lerpDouble(y3, other.y3, clampedProgress)!,
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
  int get hashCode => Object.hash(x1, y1, x2, y2, x3, y3, type);

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

/// Represents a [close path command](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d#closepath).
/// The path will draw a line between the last point and the last move to directive.
class PathClose extends PathCommand {
  /// Construct a new instance of [PathClose]. Its [type] is [PathCommandType.close].
  const PathClose() : super(PathCommandType.close);

  @override
  PathClose lerp(PathCommand other, double progress) {
    assert(type == other.type);
    if (other is! PathClose) {
      throw PathCommandsIncompatibleException(PathClose, other.runtimeType);
    }

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

/// Thrown when two [PathCommand] don't match types between each other.
/// Usually thrown by [PathCommand.lerp]
class PathCommandsIncompatibleException implements Exception {
  /// The type of the source command, the expected one
  final Type expectedType;

  /// The type of the other command, the one which is matched onto the first one
  final Type receivedType;

  /// Build a new [PathCommandsIncompatibleException] instance.
  const PathCommandsIncompatibleException(this.expectedType, this.receivedType);

  @override
  String toString() {
    return "Tried to lerp two incompatible PathCommands, a $expectedType was needed but got a $receivedType";
  }
}

/// The type of a [PathCommand].
/// Used for compatibility checks between commands to interpolate paths.
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
