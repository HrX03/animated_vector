import 'dart:convert';
import 'dart:ui';

import 'package:animated_vector/src/animation.dart';
import 'package:animated_vector/src/curves.dart';
import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/extensions.dart';
import 'package:animated_vector/src/path.dart';
import 'package:flutter/animation.dart';

/// Utility class to interface with [Shape Shifter](shapeshifter.design).
///
/// It can take in a json saved from Shape Shifter and convert it to an
/// [AnimatedVectorData] at runtime using [ShapeShifterConverter.toAVD]
/// or convert an already built [AnimatedVectorData] to json string data using
/// [ShapeShifterConverter.toJson].
///
/// This class is not recommended for loading in JSON files and instead
/// [animated_vector_gen](https://pub.dev/packages/animated_vector_gen) is suggested
/// to be used instead.
abstract final class ShapeShifterConverter {
  const ShapeShifterConverter._();

  /// Convert a json file download from Shape Shifter to an instance of [AnimatedVectorData].
  ///
  /// This method is recommended only when static code generation with [animated_vector_gen](https://pub.dev/packages/animated_vector_gen)
  /// can't be achieved (for example when dynamically loading in files).
  static AnimatedVectorData toAVD(String rawJson) {
    final Map<String, dynamic> json =
        jsonDecode(rawJson) as Map<String, dynamic>;

    final Map<String, dynamic> layers = json.get("layers");
    final Map<String, dynamic> vectorLayer = layers.get("vectorLayer");
    final Map<String, dynamic> animation =
        json.get<Map<String, dynamic>>("timeline").get("animation");
    final List<_JsonAnimationProperty> blocks = animation
        .get<List<dynamic>>("blocks")
        .map((e) => _JsonAnimationProperty.fromJson(e as Map<String, dynamic>))
        .toList();
    final List<dynamic> children = vectorLayer.get("children");

    final AnimatedVectorData data = AnimatedVectorData(
      viewportSize: Size(
        vectorLayer.get<num>("width").toDouble(),
        vectorLayer.get<num>("height").toDouble(),
      ),
      duration: Duration(milliseconds: animation.get("duration")),
      root: RootVectorElement(
        alpha: vectorLayer.maybeGet<num>("alpha")?.toDouble() ?? 1.0,
        properties: RootVectorAnimationProperties(
          alpha: _parseJsonAnimationProperties<double>(
            blocks,
            vectorLayer.get<String>("id"),
            "alpha",
          ),
        ),
        elements: _elementsFromJson(
          children.cast<Map<String, dynamic>>(),
          blocks,
        ),
      ),
    );

    return data;
  }

  /// Convert an [AnimatedVectorData] to a json file that Shape Shifter can open and edit.
  static Map<String, dynamic> toJson(AnimatedVectorData data, String name) {
    final Map<String, dynamic> documentRoot = {"version": 1};
    final _UniqueID idGen = _UniqueID();
    final Map<String, dynamic> vectorLayer = {
      "id": idGen.generate(),
      "name": name,
      "type": "vector",
      "width": data.viewportSize.width.floor(),
      "height": data.viewportSize.height.floor(),
    };
    final String rootId = idGen.generate();
    final Map<String, dynamic> timelineRoot = {
      "id": rootId,
      "name": "anim",
      "duration": data.duration.inMilliseconds,
    };
    final Map<String, List<Map<String, dynamic>>> info =
        _elementsToJson(data.root.elements, idGen);
    vectorLayer["children"] = info["children"];

    final alphaAnim = _timelineFromProperties<double, num>(
      data.root.properties.alpha,
      "alpha",
      rootId,
      (value) => value.eventuallyAsInt,
      data.root.alpha,
      idGen,
    );
    timelineRoot["blocks"] = [
      if (alphaAnim != null) alphaAnim,
      ...info["timeline"]!,
    ];
    if (data.root.alpha != 1) {
      vectorLayer["alpha"] = data.root.alpha.eventuallyAsInt;
    }

    documentRoot["layers"] = {
      "vectorLayer": vectorLayer,
      "hiddenLayerIds": [],
    };
    documentRoot["timeline"] = {"animation": timelineRoot};

    return documentRoot;
  }

  static Map<String, List<Map<String, dynamic>>> _elementsToJson(
    VectorElements elements,
    _UniqueID generator,
  ) {
    final List<Map<String, dynamic>> returnElements = [];
    final List<Map<String, dynamic>> returnTimeline = [];

    for (final VectorElement element in elements) {
      final String id = generator.generate();
      final Map<String, dynamic> toJson = {};
      if (element is PathElement) {
        toJson["id"] = id;
        toJson["name"] = "path";
        toJson["type"] = "path";
        toJson["pathData"] = element.pathData.toString();
        if (element.fillColor != null) {
          toJson["fillColor"] = _colorToHex(element.fillColor!);
        }
        if (element.fillAlpha != 1) {
          toJson["fillAlpha"] = element.fillAlpha.eventuallyAsInt;
        }
        if (element.strokeColor != null) {
          toJson["strokeColor"] = _colorToHex(element.strokeColor!);
        }
        if (element.strokeAlpha != 1) {
          toJson["strokeAlpha"] = element.strokeAlpha.eventuallyAsInt;
        }
        if (element.strokeWidth != 0) {
          toJson["strokeWidth"] = element.strokeWidth.eventuallyAsInt;
        }
        if (element.strokeCap != StrokeCap.butt) {
          toJson["strokeLinecap"] = _strokeCapToString(element.strokeCap);
        }
        if (element.strokeJoin != StrokeJoin.miter) {
          toJson["strokeLinejoin"] = _strokeJoinToString(element.strokeJoin);
        }
        if (element.strokeMiterLimit != 4) {
          toJson["strokeMiterLimit"] = element.strokeMiterLimit.eventuallyAsInt;
        }
        if (element.trimStart != 0) {
          toJson["trimPathStart"] = element.trimStart.eventuallyAsInt;
        }
        if (element.trimEnd != 1) {
          toJson["trimPathEnd"] = element.trimEnd.eventuallyAsInt;
        }
        if (element.trimOffset != 0) {
          toJson["trimPathOffset"] = element.trimOffset.eventuallyAsInt;
        }

        final pathDataAnim = _timelineFromProperties<PathData, String>(
          element.properties.pathData,
          "pathData",
          id,
          (value) => value.toString(),
          element.pathData,
          generator,
        );
        final fillColorAnim = _timelineFromProperties<Color?, String>(
          element.properties.fillColor,
          "fillColor",
          id,
          (value) => _colorToHex(value!),
          element.fillColor,
          generator,
        );
        final fillAlphaAnim = _timelineFromProperties<double, num>(
          element.properties.fillAlpha,
          "fillAlpha",
          id,
          (value) => value.eventuallyAsInt,
          element.fillAlpha,
          generator,
        );
        final strokeColorAnim = _timelineFromProperties<Color?, String>(
          element.properties.strokeColor,
          "strokeColor",
          id,
          (value) => _colorToHex(value!),
          element.strokeColor,
          generator,
        );
        final strokeAlphaAnim = _timelineFromProperties<double, num>(
          element.properties.strokeAlpha,
          "strokeAlpha",
          id,
          (value) => value.eventuallyAsInt,
          element.strokeAlpha,
          generator,
        );
        final strokeWidthAnim = _timelineFromProperties<double, num>(
          element.properties.strokeWidth,
          "strokeWidth",
          id,
          (value) => value.eventuallyAsInt,
          element.strokeWidth,
          generator,
        );
        final trimStartAnim = _timelineFromProperties<double, num>(
          element.properties.trimStart,
          "trimPathStart",
          id,
          (value) => value.eventuallyAsInt,
          element.trimStart,
          generator,
        );
        final trimEndAnim = _timelineFromProperties<double, num>(
          element.properties.trimEnd,
          "trimPathEnd",
          id,
          (value) => value.eventuallyAsInt,
          element.trimEnd,
          generator,
        );
        final trimOffsetAnim = _timelineFromProperties<double, num>(
          element.properties.trimOffset,
          "trimPathOffset",
          id,
          (value) => value.eventuallyAsInt,
          element.trimOffset,
          generator,
        );

        if (pathDataAnim != null) returnTimeline.addAll(pathDataAnim);
        if (fillColorAnim != null) returnTimeline.addAll(fillColorAnim);
        if (fillAlphaAnim != null) returnTimeline.addAll(fillAlphaAnim);
        if (strokeColorAnim != null) returnTimeline.addAll(strokeColorAnim);
        if (strokeAlphaAnim != null) returnTimeline.addAll(strokeAlphaAnim);
        if (strokeWidthAnim != null) returnTimeline.addAll(strokeWidthAnim);
        if (trimStartAnim != null) returnTimeline.addAll(trimStartAnim);
        if (trimEndAnim != null) returnTimeline.addAll(trimEndAnim);
        if (trimOffsetAnim != null) returnTimeline.addAll(trimOffsetAnim);
      } else if (element is GroupElement) {
        toJson["id"] = id;
        toJson["name"] = "group";
        toJson["type"] = "group";
        if (element.translateX != 0) {
          toJson["translateX"] = element.translateX.eventuallyAsInt;
        }
        if (element.translateY != 0) {
          toJson["translateY"] = element.translateY.eventuallyAsInt;
        }
        if (element.scaleX != 1) {
          toJson["scaleX"] = element.scaleX.eventuallyAsInt;
        }
        if (element.scaleY != 1) {
          toJson["scaleY"] = element.scaleY.eventuallyAsInt;
        }
        if (element.pivotX != 0) {
          toJson["pivotX"] = element.pivotX.eventuallyAsInt;
        }
        if (element.pivotY != 0) {
          toJson["pivotY"] = element.pivotY.eventuallyAsInt;
        }
        if (element.rotation != 0) {
          toJson["rotation"] = element.rotation.eventuallyAsInt;
        }
        final Map<String, List<Map<String, dynamic>>> info =
            _elementsToJson(element.elements, generator);
        toJson["children"] = info["children"];
        returnTimeline.addAll(info["timeline"]!);

        final translateXAnim = _timelineFromProperties<double, num>(
          element.properties.translateX,
          "translateX",
          id,
          (value) => value.eventuallyAsInt,
          element.translateX,
          generator,
        );
        final translateYAnim = _timelineFromProperties<double, num>(
          element.properties.translateY,
          "translateY",
          id,
          (value) => value.eventuallyAsInt,
          element.translateY,
          generator,
        );
        final scaleXAnim = _timelineFromProperties<double, num>(
          element.properties.scaleX,
          "scaleX",
          id,
          (value) => value.eventuallyAsInt,
          element.scaleX,
          generator,
        );
        final scaleYAnim = _timelineFromProperties<double, num>(
          element.properties.scaleY,
          "scaleY",
          id,
          (value) => value.eventuallyAsInt,
          element.scaleY,
          generator,
        );
        final pivotXAnim = _timelineFromProperties<double, num>(
          element.properties.pivotX,
          "pivotX",
          id,
          (value) => value.eventuallyAsInt,
          element.pivotX,
          generator,
        );
        final pivotYAnim = _timelineFromProperties<double, num>(
          element.properties.pivotY,
          "pivotY",
          id,
          (value) => value.eventuallyAsInt,
          element.pivotY,
          generator,
        );
        final rotationAnim = _timelineFromProperties<double, num>(
          element.properties.rotation,
          "rotation",
          id,
          (value) => value.eventuallyAsInt,
          element.rotation,
          generator,
        );

        if (translateXAnim != null) returnTimeline.addAll(translateXAnim);
        if (translateYAnim != null) returnTimeline.addAll(translateYAnim);
        if (scaleXAnim != null) returnTimeline.addAll(scaleXAnim);
        if (scaleYAnim != null) returnTimeline.addAll(scaleYAnim);
        if (pivotXAnim != null) returnTimeline.addAll(pivotXAnim);
        if (pivotYAnim != null) returnTimeline.addAll(pivotYAnim);
        if (rotationAnim != null) returnTimeline.addAll(rotationAnim);
      } else if (element is ClipPathElement) {
        toJson["id"] = id;
        toJson["name"] = "mask";
        toJson["type"] = "mask";
        toJson["pathData"] = element.pathData.toString();

        final pathDataAnim = _timelineFromProperties<PathData, String>(
          element.properties.pathData,
          "pathData",
          id,
          (value) => value.toString(),
          element.pathData,
          generator,
        );

        if (pathDataAnim != null) returnTimeline.addAll(pathDataAnim);
      }

      if (toJson.isNotEmpty) returnElements.add(toJson);
    }

    return {
      "children": returnElements,
      "timeline": returnTimeline,
    };
  }

  static List<Map<String, dynamic>>? _timelineFromProperties<T, V>(
    AnimationPropertySequence<T>? properties,
    String name,
    String layerId,
    V Function(T value) formatter,
    T defaultValue,
    _UniqueID generator,
  ) {
    if (properties == null) return null;
    final List<Map<String, dynamic>> returnTimeline = [];

    final String type;
    if (defaultValue is PathData) {
      type = "path";
    } else if (defaultValue is num) {
      type = "number";
    } else if (defaultValue is Color?) {
      type = "color";
    } else {
      throw UnsupportedError("Type not supported, something went wrong");
    }

    for (int i = 0; i < properties.length; i++) {
      final AnimationProperty<T> prop = properties[i];
      final T beginValue = prop.tween.begin ??
          AnimationProperties.getNearestDefaultForTween(
            properties,
            i,
            defaultValue,
            goDown: true,
          );
      final T endValue = prop.tween.end ??
          AnimationProperties.getNearestDefaultForTween(
            properties,
            i,
            defaultValue,
          );

      final Map<String, dynamic> jsonProp = {
        "id": generator.generate(),
        "layerId": layerId,
        "propertyName": name,
        "startTime": prop.interval.start.inMilliseconds,
        "endTime": prop.interval.end.inMilliseconds,
        "interpolator":
            _JsonAnimationProperty._stringFromInterpolator(prop.curve),
        "type": type,
        "fromValue": formatter(beginValue),
        "toValue": formatter(endValue),
      };
      returnTimeline.add(jsonProp);
    }

    return returnTimeline;
  }

  static VectorElements _elementsFromJson(
    List<Map<String, dynamic>> json,
    List<_JsonAnimationProperty> animations,
  ) {
    final VectorElements elements = [];

    for (final Map<String, dynamic> child in json) {
      final String id = child.get<String>("id");
      final String type = child.get<String>("type");

      switch (type) {
        case "path":
          final PathElement element = PathElement(
            pathData: PathData.parse(child.get<String>("pathData")),
            fillColor: _colorFromHex(child.maybeGet<String>("fillColor")),
            fillAlpha: child.maybeGet<num>("fillAlpha")?.toDouble() ?? 1.0,
            strokeColor: _colorFromHex(child.maybeGet<String>("strokeColor")),
            strokeAlpha: child.maybeGet<num>("strokeAlpha")?.toDouble() ?? 1.0,
            strokeWidth: child.maybeGet<num>("strokeWidth")?.toDouble() ?? 1.0,
            strokeCap:
                _strokeCapFromString(child.maybeGet<String>("strokeLinecap")),
            strokeJoin:
                _strokeJoinFromString(child.maybeGet<String>("strokeLinejoin")),
            strokeMiterLimit:
                child.maybeGet<num>("strokeMiterLimit")?.toDouble() ?? 4.0,
            trimStart: child.maybeGet<num>("trimPathStart")?.toDouble() ?? 0.0,
            trimEnd: child.maybeGet<num>("trimPathEnd")?.toDouble() ?? 1.0,
            trimOffset:
                child.maybeGet<num>("trimPathOffset")?.toDouble() ?? 0.0,
            properties: PathAnimationProperties(
              pathData: _parseJsonAnimationProperties<PathData>(
                animations,
                id,
                "pathData",
              ),
              fillColor: _parseJsonAnimationProperties<Color?>(
                animations,
                id,
                "fillColor",
              ),
              fillAlpha: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "fillAlpha",
              ),
              strokeColor: _parseJsonAnimationProperties<Color?>(
                animations,
                id,
                "strokeColor",
              ),
              strokeAlpha: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "strokeAlpha",
              ),
              strokeWidth: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "strokeWidth",
              ),
              trimStart: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "trimPathStart",
              ),
              trimEnd: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "trimPathEnd",
              ),
              trimOffset: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "trimPathOffset",
              ),
            ),
          );
          elements.add(element);
        case "mask":
          final ClipPathElement element = ClipPathElement(
            pathData: PathData.parse(child.get<String>("pathData")),
            properties: ClipPathAnimationProperties(
              pathData: _parseJsonAnimationProperties<PathData>(
                animations,
                id,
                "pathData",
              ),
            ),
          );
          elements.add(element);
        case "group":
          final GroupElement element = GroupElement(
            translateX: child.maybeGet<num>("translateX")?.toDouble() ?? 0.0,
            translateY: child.maybeGet<num>("translateY")?.toDouble() ?? 0.0,
            scaleX: child.maybeGet<num>("scaleX")?.toDouble() ?? 1.0,
            scaleY: child.maybeGet<num>("scaleY")?.toDouble() ?? 1.0,
            pivotX: child.maybeGet<num>("pivotX")?.toDouble() ?? 0.0,
            pivotY: child.maybeGet<num>("pivotY")?.toDouble() ?? 0.0,
            rotation: child.maybeGet<num>("rotation")?.toDouble() ?? 0.0,
            elements: _elementsFromJson(
              child.get<List<dynamic>>("children").cast<Map<String, dynamic>>(),
              animations,
            ),
            properties: GroupAnimationProperties(
              translateX: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "translateX",
              ),
              translateY: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "translateY",
              ),
              scaleX: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "scaleX",
              ),
              scaleY: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "scaleY",
              ),
              pivotX: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "pivotX",
              ),
              pivotY: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "pivotY",
              ),
              rotation: _parseJsonAnimationProperties<double>(
                animations,
                id,
                "rotation",
              ),
            ),
          );
          elements.add(element);
      }
    }

    return elements;
  }

  static AnimationPropertySequence<T> _parseJsonAnimationProperties<T>(
    List<_JsonAnimationProperty> properties,
    String layerId,
    String propertyName,
  ) {
    return properties
        .where((a) => a.layerId == layerId && a.propertyName == propertyName)
        .map(
          (a) => AnimationProperty<T>(
            tween: a.tween as ConstTween<T>,
            interval: AnimationInterval(
              start: Duration(milliseconds: a.startTime),
              end: Duration(milliseconds: a.endTime),
            ),
            curve: a.interpolator,
          ),
        )
        .toList();
  }

  static StrokeCap _strokeCapFromString(String? source) {
    switch (source) {
      case "square":
        return StrokeCap.square;
      case "round":
        return StrokeCap.round;
      case "butt":
      default:
        return StrokeCap.butt;
    }
  }

  static StrokeJoin _strokeJoinFromString(String? source) {
    switch (source) {
      case "bevel":
        return StrokeJoin.bevel;
      case "round":
        return StrokeJoin.round;
      case "miter":
      default:
        return StrokeJoin.miter;
    }
  }

  static String _strokeCapToString(StrokeCap source) {
    switch (source) {
      case StrokeCap.square:
        return "square";
      case StrokeCap.round:
        return "round";
      case StrokeCap.butt:
      default:
        return "butt";
    }
  }

  static String _strokeJoinToString(StrokeJoin source) {
    switch (source) {
      case StrokeJoin.bevel:
        return "bevel";
      case StrokeJoin.round:
        return "round";
      case StrokeJoin.miter:
      default:
        return "miter";
    }
  }
}

class _JsonAnimationProperty<T> {
  final String layerId;
  final String propertyName;
  final ConstTween<T?> tween;
  final int startTime;
  final int endTime;
  final Curve interpolator;

  const _JsonAnimationProperty({
    required this.layerId,
    required this.propertyName,
    required this.tween,
    required this.startTime,
    required this.endTime,
    required this.interpolator,
  });

  static _JsonAnimationProperty fromJson<T>(Map<String, dynamic> json) {
    final String layerId = json.get<String>("layerId");
    final String propertyName = json.get<String>("propertyName");
    final int startTime = json.get<int>("startTime");
    final int endTime = json.get<int>("endTime");
    final Curve interpolator =
        _interpolatorFromString(json.get<String>("interpolator"));
    final String type = json.get<String>("type");

    switch (type) {
      case "path":
        final PathData from = PathData.parse(json.get<String>("fromValue"));
        final PathData to = PathData.parse(json.get<String>("toValue"));
        return _JsonAnimationProperty<PathData>(
          layerId: layerId,
          propertyName: propertyName,
          startTime: startTime,
          endTime: endTime,
          interpolator: interpolator,
          tween: ConstPathDataTween(begin: from, end: to),
        );
      case "color":
        final Color from = _colorFromHex(json.get<String>("fromValue"))!;
        final Color to = _colorFromHex(json.get<String>("toValue"))!;
        return _JsonAnimationProperty<Color>(
          layerId: layerId,
          propertyName: propertyName,
          startTime: startTime,
          endTime: endTime,
          interpolator: interpolator,
          tween: ConsteColorTween(begin: from, end: to),
        );
      case "number":
        final double from = json.get<num>("fromValue").toDouble();
        final double to = json.get<num>("toValue").toDouble();
        return _JsonAnimationProperty<double>(
          layerId: layerId,
          propertyName: propertyName,
          startTime: startTime,
          endTime: endTime,
          interpolator: interpolator,
          tween: ConstTween<double>(begin: from, end: to),
        );
      default:
        throw UnsupportedAnimationProperty(type);
    }
  }

  static Curve _interpolatorFromString(String interpolator) {
    switch (interpolator) {
      case "FAST_OUT_SLOW_IN":
        return ShapeShifterCurves.fastOutSlowIn;
      case "FAST_OUT_LINEAR_IN":
        return ShapeShifterCurves.fastOutLinearIn;
      case "LINEAR_OUT_SLOW_IN":
        return ShapeShifterCurves.linearOutSlowIn;
      case "ACCELERATE_DECELERATE":
        return ShapeShifterCurves.accelerateDecelerate;
      case "ACCELERATE":
        return ShapeShifterCurves.accelerate;
      case "DECELERATE":
        return ShapeShifterCurves.decelerate;
      case "ANTICIPATE":
        return ShapeShifterCurves.anticipate;
      case "OVERSHOOT":
        return ShapeShifterCurves.overshoot;
      case "BOUNCE":
        return ShapeShifterCurves.bounce;
      case "ANTICIPATE_OVERSHOOT":
        return ShapeShifterCurves.anticipateOvershoot;
      case "LINEAR":
      default:
        return ShapeShifterCurves.linear;
    }
  }

  static String _stringFromInterpolator(Curve interpolator) {
    switch (interpolator) {
      case ShapeShifterCurves.fastOutSlowIn:
        return "FAST_OUT_SLOW_IN";
      case ShapeShifterCurves.fastOutLinearIn:
        return "FAST_OUT_LINEAR_IN";
      case ShapeShifterCurves.linearOutSlowIn:
        return "LINEAR_OUT_SLOW_IN";
      case ShapeShifterCurves.accelerateDecelerate:
        return "ACCELERATE_DECELERATE";
      case ShapeShifterCurves.accelerate:
        return "ACCELERATE";
      case ShapeShifterCurves.decelerate:
        return "DECELERATE";
      case ShapeShifterCurves.anticipate:
        return "ANTICIPATE";
      case ShapeShifterCurves.overshoot:
        return "OVERSHOOT";
      case ShapeShifterCurves.bounce:
        return "BOUNCE";
      case ShapeShifterCurves.anticipateOvershoot:
        return "ANTICIPATE_OVERSHOOT";
      case ShapeShifterCurves.linear:
      default:
        return "LINEAR";
    }
  }
}

Color? _colorFromHex(String? hex) {
  if (hex == null) return null;

  String cleanHex = hex.replaceAll("#", "");
  cleanHex = switch (cleanHex.length) {
    6 => ["FF", cleanHex].join(),
    3 => ["FF", cleanHex, cleanHex].join(),
    2 => ["FF", cleanHex, cleanHex, cleanHex].join(),
    _ => cleanHex,
  };
  final int? colorValue = int.tryParse(cleanHex, radix: 16);

  if (colorValue == null) return null;
  return Color(colorValue);
}

String _colorToHex(Color color) {
  final String radixString = color.value.toRadixString(16);
  if (color.alpha == 0xFF) return "#${radixString.substring(2)}";
  return "#$radixString";
}

/// Exception thrown when [ShapeShifterConverter.toAVD] finds an animation property
/// that refers to a property the lib was not built to handle.
///
/// Usually happens with corrupted or misconstructed json files.
class UnsupportedAnimationProperty implements Exception {
  /// The property that was not recognized by the converter.
  final String property;

  /// Builds a new [UnsupportedAnimationProperty].
  const UnsupportedAnimationProperty(this.property);

  @override
  String toString() {
    return "The property '$property' is not handled by the lib or not valid";
  }
}

/// Exception thrown when [ShapeShifterConverter.toAVD] needs a property to be found
/// inside the json file but couldn't.
///
/// Usually happens with corrupted or misconstructed json files.
class MissingPropertyException implements Exception {
  /// The property that was not found by the converter.
  final String property;

  /// Builds a new [MissingPropertyException].
  const MissingPropertyException(this.property);

  @override
  String toString() {
    return "The provided json doesn't have required property '$property'";
  }
}

extension<K> on Map<K, dynamic> {
  T get<T>(K key) {
    if (!containsKey(key)) {
      throw MissingPropertyException(key.toString());
    }

    return this[key]! as T;
  }

  T? maybeGet<T>(K key) {
    return this[key] as T?;
  }
}

class _UniqueID {
  final Map<String, int> _generatedIds = {};

  String generate([String prefix = '%default%']) {
    if (!_generatedIds.containsKey(prefix)) {
      _generatedIds[prefix] = 1;
    } else {
      _generatedIds[prefix] = _generatedIds[prefix]! + 1;
    }
    final int id = _generatedIds[prefix]!;

    if (prefix == '%default%') {
      return '$id';
    }

    return '$prefix$id';
  }

  void reset() {
    _generatedIds.clear();
  }
}
