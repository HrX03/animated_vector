import 'dart:math' as math;

import 'package:animated_vector/src/_stub_loader.dart'
    if (dart.library.io) 'package:animated_vector/src/_io_loader.dart';
import 'package:animated_vector/src/animation.dart';
import 'package:animated_vector/src/path.dart';
import 'package:animated_vector/src/shapeshifter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// A list of [VectorElement]s.
/// Used by [RootVectorElement] and [GroupElement].
typedef VectorElements = List<VectorElement>;

/// Data for an animated vector, to use with widgets like [AnimatedVector] or
/// inside a [SequenceItem] for [AnimatedSequence].
///
/// It requires a [root] vector element that can apply a global alpha to the vector,
/// and then as children [PathElement], [GroupElement] and [ClipPathElement] can
/// be used.
///
/// The [duration] parameter is used to define the target length of this animation,
/// using an [AnimationController] with its duration set to it will make sure
/// the vector runs at its intended speed.
///
/// [viewportSize] defines the size of the canvas for this vector animation,
/// [AnimatedVector.size] allows you to modify the destination size to scale up or down.
///
/// The static methods [loadFromFile] and [loadFromAsset] allow users to load a
/// Shape Shifter json vector animation dynamically at runtime.
/// Where possible prefer to use code generation from [animated_vector_gen](https://pub.dev/packages/animated_vector_gen)
/// as it's syncronous and allows for const instances to be created.
///
/// It is advised to always construct this class as `const` as parameters that need
/// to be changed at runtime (like color) can be modified using utilities in the
/// widgets themselves.
class AnimatedVectorData {
  /// The root element of this vector data.
  /// Mostly used to have a central entry point for painting elements, allows
  /// to specify a global alpha value that can optionally be animated.
  final RootVectorElement root;

  /// The target duration of this vector data.
  /// This value is propagated to elements and animation properties for normalization
  /// purposes, it is advised to have this value big enough to contain every
  /// animation interval inside the sequences.
  final Duration duration;

  /// The viewport size which contains the elements.
  /// Think of it as the size of the sheet of paper where you draw.
  ///
  /// This value is used to compute proportional scales and to understand the bounds
  /// of the icon.
  final Size viewportSize;

  /// Constructs a new [AnimatedVectorData] instance.
  ///
  /// Always try to have this defined as const to improve performance and to make
  /// sure everything is immutable. Icon data should not mutate, if needed some
  /// data can be overridden later on.
  const AnimatedVectorData({
    required this.root,
    required this.duration,
    required this.viewportSize,
  });

  /// Dynamically load an [AnimatedVectorData] from a json Shape Shifter file
  /// inside the file system.
  ///
  /// The returned instance needs to be stored somewhere in order to be used as
  /// this method doesn't store anything inside a cache or similar.
  ///
  /// This method will throw [UnsupportedError] when called on the web platform.s
  ///
  /// Where possible prefer to use code generation from [animated_vector_gen](https://pub.dev/packages/animated_vector_gen)
  /// as it's syncronous and allows for const instances to be created.
  static Future<AnimatedVectorData> loadFromFile(String path) async {
    return loadDataFromFile(path);
  }

  /// Dynamically load an [AnimatedVectorData] from a json Shape Shifter file
  /// bundled in the app or other packages assets.
  /// The [package] parameter allows to specify a specific package to obtain the
  /// asset from.
  ///
  /// The returned instance needs to be stored somewhere in order to be used as
  /// this method doesn't store anything inside a cache or similar.
  ///
  /// Where possible prefer to use code generation from [animated_vector_gen](https://pub.dev/packages/animated_vector_gen)
  /// as it's syncronous and allows for const instances to be created.
  static Future<AnimatedVectorData> loadFromAsset(
    String assetName, {
    AssetBundle? bundle,
    String? package,
  }) {
    final assetKey =
        package != null ? "packages/$package/$assetName" : assetName;

    return (bundle ?? rootBundle).loadStructuredData(
      assetKey,
      (value) async => ShapeShifterConverter.toAVD(value),
    );
  }

  /// Paint this vector data onto a [Canvas].
  /// The first two parameters behave the exact same way as [CustomPainter.paint].
  ///
  /// The [progress] parameter is a normalized double from 0.0 to 1.0 that represents
  /// the value of an animation, [animationDuration] is used to normalize the
  /// [AnimationInterval] ranges for animating, while [transform] is the current
  /// stack of transforms to apply to path data, it's usually modified by [GroupElement]
  /// paint operations.
  ///
  /// This method for now just forwards the paint call to [root], it was created
  /// to avoid breaking changes if the painting logic of elements changes in the future.
  void paint(
    Canvas canvas,
    Size size,
    double progress,
    Duration animationDuration,
    Matrix4 transform,
  ) {
    root.paint(canvas, size, progress, duration, transform);
  }

  /// Converts this data into json content that can be opened and edited within
  /// Shape Shifter
  Map<String, dynamic> toJson(String name) {
    return ShapeShifterConverter.toJson(this, name);
  }

  @override
  int get hashCode => Object.hash(root, duration, viewportSize);

  @override
  bool operator ==(Object other) {
    if (other is AnimatedVectorData) {
      return root == other.root &&
          duration == other.duration &&
          viewportSize == other.viewportSize;
    }

    return false;
  }
}

/// Base class for elements that lie inside [AnimatedVectorData.root].
///
/// The [properties] field contains animation properties for this element, these
/// are strictly tied to the element type.
///
/// The [paint] method defines how to draw this element, it should evaluate the
/// [properties] before anything else by calling [AnimationProperties.evaluate],
/// then use the canvas with the newly resolved properties.
///
/// Main subclasses of this class are as follows:
/// - [RootVectorElement]: the root of [AnimatedVectorData], it is not advised to use it anywhere else
/// - [PathElement]: draws a single path with various editable properties
/// - [GroupElement]: allows grouping elements together and can transform them all in unison
/// - [ClipPathElement]: masks elements after it in the same list and same group
abstract class VectorElement<T extends AnimationProperties> {
  /// Animation properties for this element.
  ///
  /// [AnimationProperties.evaluate] should be called to get actual values that
  /// can be used inside [paint].
  final T properties;

  /// Abstract base const constructor.
  /// The [properties] parameter should not be required for end users.
  /// In subclasses it has an empty const value of its properties type.
  const VectorElement({required this.properties});

  /// Paint this vector element onto a [Canvas].
  /// The first two parameters behave the exact same way as [CustomPainter.paint].
  ///
  /// The [progress] parameter is a normalized double from 0.0 to 1.0 that represents
  /// the value of an animation, [animationDuration] is used to normalize the
  /// [AnimationInterval] ranges for animating, while [transform] is the current
  /// stack of transforms to apply to path data, it's usually modified by [GroupElement]
  /// paint operations.
  void paint(
    Canvas canvas,
    Size size,
    double progress,
    Duration animationDuration,
    Matrix4 transform,
  );
}

/// The vector element that represents the root of a vector.
///
/// It contains a list of other [elements] and it can take in an [alpha] value
/// that can be applied to the whole vector. This value can also be animated
/// with [properties].
///
/// It can be inserted in other parts of the vector tree but it is advised to not
/// do so in case the library decides to handle the root differently in future.
class RootVectorElement extends VectorElement<RootVectorAnimationProperties> {
  /// The opacity of this element children, can go from 0.0 to 1.0
  final double alpha;

  /// The children of this element.
  final VectorElements elements;

  /// Constructs a new instance of [RootVectorElement].
  ///
  /// [alpha] has a value of 1.0 to indicate max opacity and both [properties] and
  /// [elements] get initialized with an empty value of the corrispective type.
  ///
  /// The [properties] parameter is of type [RootVectorAnimationProperties].
  const RootVectorElement({
    this.alpha = 1.0,
    super.properties = const RootVectorAnimationProperties(),
    this.elements = const [],
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
    double progress,
    Duration duration,
    Matrix4 transform,
  ) {
    final evaluated =
        properties.evaluate(progress, duration, defaultAlpha: alpha);

    canvas.saveLayer(
      Offset.zero & size,
      Paint()
        ..colorFilter = ColorFilter.mode(
          const Color(0xFFFFFFFF).withOpacity(evaluated.alpha!),
          BlendMode.modulate,
        ),
    );
    for (final VectorElement element in elements) {
      element.paint(canvas, size, progress, duration, transform);
    }
    canvas.restore();
  }

  @override
  int get hashCode => Object.hash(alpha, elements, properties);

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

/// The vector element that groups [elements] together.
///
/// This element proves useful because of its ability to transform
/// group of elements as if they were a single one.
///
/// The available transforms are translations ([translateX] and [translateY]),
/// scaling ([scaleX] and [scaleY]) and [rotation]s.
///
/// To control the reference point of these transformations [pivotX] and [pivotY]
/// can be modified.
/// By default transforms use the top left corner as the center point.
///
/// All of these parameters can be animated through this element [properties].
class GroupElement extends VectorElement<GroupAnimationProperties> {
  /// The horizontal translation of this group. Defaults to 0.0.
  final double translateX;

  /// The vertical translation of this group. Defaults to 0.0.
  final double translateY;

  /// The horizontal scale of this group. Defaults to 1.0.
  final double scaleX;

  /// The vertical scale of this group. Defaults to 1.0.
  final double scaleY;

  /// The horizontal coordinate of the pivot point. Defaults to 0.0.
  final double pivotX;

  /// The vertical coordinate of the pivot point. Defaults to 0.0.
  final double pivotY;

  /// The rotation to apply to this group, expressed in degrees. Defaults to 0.0.
  final double rotation;

  /// The children of this element.
  final VectorElements elements;

  /// Constructs a new instance of [GroupElement].
  ///
  /// Every double field defaults to 0.0 apart from [scaleX] and [scaleY]
  /// which defaults to 1.0. Both [properties] and [elements] get initialized
  /// with an empty value of the corrispective type.
  ///
  /// The [properties] parameter is of type [GroupAnimationProperties].
  const GroupElement({
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.pivotX = 0.0,
    this.pivotY = 0.0,
    this.rotation = 0.0,
    super.properties = const GroupAnimationProperties(),
    this.elements = const [],
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
    double progress,
    Duration duration,
    Matrix4 transform,
  ) {
    final evaluated = properties.evaluate(
      progress,
      duration,
      defaultTranslateX: translateX,
      defaultTranslateY: translateY,
      defaultScaleX: scaleX,
      defaultScaleY: scaleY,
      defaultPivotX: pivotX,
      defaultPivotY: pivotY,
      defaultRotation: rotation,
    );

    final transformMatrix = transform.clone()
      ..translate(evaluated.pivotX, evaluated.pivotY!)
      ..translate(evaluated.translateX, evaluated.translateY!)
      ..rotateZ(evaluated.rotation! * math.pi / 180)
      ..scale(evaluated.scaleX, evaluated.scaleY)
      ..translate(-evaluated.pivotX!, -evaluated.pivotY!);

    canvas.save();
    for (final VectorElement element in elements) {
      element.paint(canvas, size, progress, duration, transformMatrix);
    }
    canvas.restore();
  }

  @override
  int get hashCode => Object.hash(
        translateX,
        translateY,
        scaleX,
        scaleY,
        pivotX,
        pivotY,
        rotation,
        elements,
        properties,
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

/// A vector element that draws svg path data.
///
/// This element will draw [pathData] using the various parameters available.
///
/// Not every field of this class can be animated through this element [properties],
/// [strokeCap], [strokeJoin] and [strokeMiterLimit] are final as animating them
/// would be either useless or not possible.
class PathElement extends VectorElement<PathAnimationProperties> {
  /// The path data to animate. It is expressed through the use of svg path commands.
  /// Refer to the documentation on [PathData] for more.
  final PathData pathData;

  /// A color to apply to the path data as its fill.
  /// If null the path won't have any fill drawn, having the same effect of
  /// passing a transparent color.
  final Color? fillColor;

  /// The opacity to use when drawing the path fill. Useful when you want to
  /// animate fades without having to mess with [fillColor].
  final double fillAlpha;

  /// A color to apply to the path data as its stroke.
  /// If null the path won't have any stroke drawn, having the same effect of
  /// passing a transparent color.
  /// The path still won't be painted if [strokeWidth] is equal to zero.
  final Color? strokeColor;

  /// The opacity to use when drawing the path stroke. Useful when you want to
  /// animate fades without having to mess with [strokeColor].
  final double strokeAlpha;

  /// The width of the stroke to be painted.
  /// Valid only if [strokeColor] is not null.
  final double strokeWidth;

  /// The cap to use to paint stroke path endings.
  /// See [StrokeCap] for more complete docs and a list of available values.
  final StrokeCap strokeCap;

  /// The type of join to use to paint the path's stroke.
  /// See [StrokeJoin] for more complete docs and a list of available values.
  final StrokeJoin strokeJoin;

  /// The angle limit to use when [strokeJoin] is set to [StrokeJoin.miter].
  /// Refer to [Paint.strokeMiterLimit] for more complete docs.
  final double strokeMiterLimit;

  /// How much to trim from the start of the path, defined as a
  /// normalized percentage that is in the range 0.0 - 1.0.
  ///
  /// This value is applied only to the stroke and is ignored when one isn't to
  /// be painted.
  ///
  /// By default trims from the first point of the path
  /// (usually a move to) but this point can be modified with [trimOffset].
  final double trimStart;

  /// How much to trim from the end of the path, defined as a
  /// normalized percentage that is in the range 0.0 - 1.0.
  ///
  /// This value is applied only to the stroke and is ignored when one isn't to
  /// be painted.
  ///
  /// By default trims from the last point of the path but this point
  /// can be modified with [trimOffset].
  final double trimEnd;

  /// Where to start applying trims for [trimStart] and [trimEnd].
  /// This value is defined in the range 0.0 - 1.0 and moves the point along
  /// the path using the path contour length as its upper bound.
  ///
  /// For example, setting this value to 0.5 means that trims will begin trimming
  /// from exactly half of the path contour length.
  /// Setting this value to 1.0 is will have the same effects as having it to 0.0.
  final double trimOffset;

  /// Constructs a new instance of [PathElement].
  ///
  /// [fillAlpha], [strokeAlpha], [strokeWidth] and [trimEnd] default to 1.0.
  /// [trimStart] and [trimOffset] default to 0.0.
  /// [strokeMiterLimit] defaults to 4.0.
  /// [strokeCap] defaults to [StrokeCap.butt].
  /// [strokeJoin] defaults to [StrokeJoin.miter].
  /// [fillColor] and [strokeColor] default to `null`.
  ///
  /// [trimStart], [trimEnd] and [trimOffset] must be between 0.0 and 1.0 inclusive.
  ///
  /// The [properties] parameter is of type [PathAnimationProperties].
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
    super.properties = const PathAnimationProperties(),
  })  : assert(trimStart >= 0 && trimStart <= 1),
        assert(trimEnd >= 0 && trimEnd <= 1),
        assert(trimOffset >= 0 && trimOffset <= 1);

  @override
  void paint(
    Canvas canvas,
    Size size,
    double progress,
    Duration duration,
    Matrix4 transform,
  ) {
    final evaluated = properties.evaluate(
      progress,
      duration,
      defaultPathData: pathData,
      defaultFillColor: this.fillColor,
      defaultFillAlpha: fillAlpha,
      defaultStrokeColor: this.strokeColor,
      defaultStrokeAlpha: strokeAlpha,
      defaultStrokeWidth: strokeWidth,
      defaultTrimStart: trimStart,
      defaultTrimEnd: trimEnd,
      defaultTrimOffset: trimOffset,
    );

    final Color fillColor = evaluated.fillColor ?? const Color(0x00000000);
    final Color strokeColor = evaluated.strokeColor ?? const Color(0x00000000);

    if (evaluated.strokeWidth! > 0 && evaluated.strokeColor != null) {
      canvas.drawPath(
        evaluated.pathData!
            .toPath(
              trimStart: evaluated.trimStart!,
              trimEnd: evaluated.trimEnd!,
              trimOffset: evaluated.trimOffset!,
            )
            .transform(transform.storage),
        Paint()
          ..color = strokeColor
              .withOpacity(strokeColor.opacity * evaluated.strokeAlpha!)
          ..strokeWidth = evaluated.strokeWidth!
          ..strokeCap = strokeCap
          ..strokeJoin = strokeJoin
          ..strokeMiterLimit = strokeMiterLimit
          ..style = PaintingStyle.stroke,
      );
    }
    canvas.drawPath(
      evaluated.pathData!.toPath().transform(transform.storage),
      Paint()
        ..color =
            fillColor.withOpacity(fillColor.opacity * evaluated.fillAlpha!),
    );
  }

  @override
  int get hashCode => Object.hash(
        pathData,
        fillColor,
        fillAlpha,
        strokeColor,
        strokeAlpha,
        strokeWidth,
        strokeCap,
        strokeJoin,
        strokeMiterLimit,
        trimStart,
        trimEnd,
        trimOffset,
        properties,
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

/// An element that applies a clip to other elements based on its [pathData].
///
/// This clip is applied to every element inside a [GroupElement] or [RootVectorElement]
/// that lies after this element in the list.
///
/// For example:
/// ```dart
/// GroupElement([ ... ]), // not affected by the clipping element
/// ClipPathElement( ... ), // applies to every element after this one
/// PathElement( ... ), // clipped
/// GroupElement([ ... ]), // every element inside this group will be clipped
/// ```
class ClipPathElement extends VectorElement<ClipPathAnimationProperties> {
  /// The path data to use to clip this item. The visible portion is defined
  /// by the area of this path that would be painted if it were to be painted
  /// by a [PathElement] with a non null fill.
  final PathData pathData;

  /// Constructs a new instance of [ClipPathElement].
  ///
  /// The [properties] parameter is of type [ClipPathAnimationProperties].
  const ClipPathElement({
    required this.pathData,
    super.properties = const ClipPathAnimationProperties(),
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
    double progress,
    Duration duration,
    Matrix4 transform,
  ) {
    final evaluated = properties.evaluate(
      progress,
      duration,
      defaultPathData: pathData,
    );

    canvas.clipPath(evaluated.pathData!.toPath().transform(transform.storage));
  }

  @override
  int get hashCode => Object.hash(pathData, properties);

  @override
  bool operator ==(Object other) {
    if (other is ClipPathElement) {
      return pathData == other.pathData && properties == other.properties;
    }

    return false;
  }
}
