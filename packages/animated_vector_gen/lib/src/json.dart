import 'dart:convert';

import 'package:animated_vector_gen/src/templates/animated_vector_data.dart';
import 'package:animated_vector_gen/src/templates/animation_property.dart';
import 'package:animated_vector_gen/src/templates/clip_element.dart';
import 'package:animated_vector_gen/src/templates/group_element.dart';
import 'package:animated_vector_gen/src/templates/path_element.dart';
import 'package:animated_vector_gen/src/templates/root_element.dart';
import 'package:animated_vector_gen/src/templates/template.dart';
import 'package:animated_vector_gen/src/templates/utils.dart';

AnimatedVectorDataTemplate jsonToCode(String rawJson) {
  final Map<String, dynamic> json = jsonDecode(rawJson) as Map<String, dynamic>;

  final Map<String, dynamic> layers = json.get("layers");
  final Map<String, dynamic> vectorLayer = layers.get("vectorLayer");
  final Map<String, dynamic> animation =
      json.get<Map<String, dynamic>>("timeline").get("animation");
  final List<_JsonAnimationProperty> blocks = animation
      .get<List<dynamic>>("blocks")
      .map((e) => _JsonAnimationProperty.fromJson(e as Map<String, dynamic>))
      .toList();
  final List<dynamic> children = vectorLayer.get("children");

  return AnimatedVectorDataTemplate(
    viewportSize: (
      vectorLayer.get<num>("width"),
      vectorLayer.get<num>("height")
    ),
    duration: animation.get("duration"),
    root: RootElementTemplate(
      alpha: vectorLayer.maybeGet<num>("alpha"),
      elements: _elementsFromJson(
        children.cast<Map<String, dynamic>>(),
        blocks,
      ),
      properties: RootAnimationPropertiesTemplate(
        alpha: _parseProperties<double>(
          blocks,
          vectorLayer.get<String>("id"),
          "alpha",
        ),
      ),
    ),
  );
}

List<ElementTemplate> _elementsFromJson(
  List<Map<String, dynamic>> json,
  List<_JsonAnimationProperty> animations,
) {
  final List<ElementTemplate> elements = [];

  for (final Map<String, dynamic> child in json) {
    final String id = child.get<String>("id");
    final String type = child.get<String>("type");

    switch (type) {
      case "path":
        final element = PathElementTemplate(
          pathData: child.get<String>("pathData"),
          fillColor: _colorFromHex(child.maybeGet<String>("fillColor")),
          fillAlpha: child.maybeGet<num>("fillAlpha")?.toDouble(),
          strokeColor: _colorFromHex(child.maybeGet<String>("strokeColor")),
          strokeAlpha: child.maybeGet<num>("strokeAlpha")?.toDouble(),
          strokeWidth: child.maybeGet<num>("strokeWidth")?.toDouble(),
          strokeCap: child.maybeGet<String>("strokeLinecap"),
          strokeJoin: child.maybeGet<String>("strokeLinejoin"),
          strokeMiterLimit: child.maybeGet<num>("strokeMiterLimit")?.toDouble(),
          trimStart: child.maybeGet<num>("trimPathStart")?.toDouble(),
          trimEnd: child.maybeGet<num>("trimPathEnd")?.toDouble(),
          trimOffset: child.maybeGet<num>("trimPathOffset")?.toDouble(),
          properties: PathAnimationPropertiesTemplate(
            pathData: _parseProperties<String>(animations, id, "pathData"),
            fillColor: _parseProperties<int?>(animations, id, "fillColor"),
            fillAlpha: _parseProperties<double>(animations, id, "fillAlpha"),
            strokeColor: _parseProperties<int?>(animations, id, "strokeColor"),
            strokeAlpha:
                _parseProperties<double>(animations, id, "strokeAlpha"),
            strokeWidth:
                _parseProperties<double>(animations, id, "strokeWidth"),
            trimStart:
                _parseProperties<double>(animations, id, "trimPathStart"),
            trimEnd: _parseProperties<double>(animations, id, "trimPathEnd"),
            trimOffset:
                _parseProperties<double>(animations, id, "trimPathOffset"),
          ),
        );
        elements.add(element);
      case "mask":
        final element = ClipElementTemplate(
          pathData: child.get<String>("pathData"),
          properties: ClipAnimationPropertiesTemplate(
            pathData: _parseProperties<String>(animations, id, "pathData"),
          ),
        );
        elements.add(element);
      case "group":
        final element = GroupElementTemplate(
          translateX: child.maybeGet<num>("translateX")?.toDouble(),
          translateY: child.maybeGet<num>("translateY")?.toDouble(),
          scaleX: child.maybeGet<num>("scaleX")?.toDouble(),
          scaleY: child.maybeGet<num>("scaleY")?.toDouble(),
          pivotX: child.maybeGet<num>("pivotX")?.toDouble(),
          pivotY: child.maybeGet<num>("pivotY")?.toDouble(),
          rotation: child.maybeGet<num>("rotation")?.toDouble(),
          elements: _elementsFromJson(
            child.get<List<dynamic>>("children").cast<Map<String, dynamic>>(),
            animations,
          ),
          properties: GroupAnimationPropertiesTemplate(
            translateX: _parseProperties<double>(animations, id, "translateX"),
            translateY: _parseProperties<double>(animations, id, "translateY"),
            scaleX: _parseProperties<double>(animations, id, "scaleX"),
            scaleY: _parseProperties<double>(animations, id, "scaleY"),
            pivotX: _parseProperties<double>(animations, id, "pivotX"),
            pivotY: _parseProperties<double>(animations, id, "pivotY"),
            rotation: _parseProperties<double>(animations, id, "rotation"),
          ),
        );
        elements.add(element);
    }
  }

  return elements;
}

List<AnimationPropertyTemplate<T>> _parseProperties<T>(
  List<_JsonAnimationProperty> properties,
  String layerId,
  String propertyName,
) {
  return properties
      .where((a) => a.layerId == layerId && a.propertyName == propertyName)
      .map(
        (a) => AnimationPropertyTemplate<T>(
          tween: LerpTemplate<T>(
            begin: a.begin as T,
            end: a.end as T,
            type: a.type,
          ),
          type: a.type,
          start: a.startTime,
          end: a.endTime,
          curve: a.interpolator,
        ),
      )
      .toList();
}

class _JsonAnimationProperty<T> {
  final String layerId;
  final String propertyName;
  final T? begin;
  final T? end;
  final int startTime;
  final int endTime;
  final String interpolator;
  final ValueType type;

  const _JsonAnimationProperty({
    required this.layerId,
    required this.propertyName,
    required this.begin,
    required this.end,
    required this.startTime,
    required this.endTime,
    required this.interpolator,
    required this.type,
  });

  static _JsonAnimationProperty fromJson(Map<String, dynamic> json) {
    final String layerId = json.get<String>("layerId");
    final String propertyName = json.get<String>("propertyName");
    final int startTime = json.get<int>("startTime");
    final int endTime = json.get<int>("endTime");
    final String interpolator =
        _interpolatorFromString(json.get<String>("interpolator"));
    final String type = json.get<String>("type");

    switch (type) {
      case "path":
        return _JsonAnimationProperty<String>(
          layerId: layerId,
          propertyName: propertyName,
          startTime: startTime,
          endTime: endTime,
          interpolator: interpolator,
          begin: json.get<String>("fromValue"),
          end: json.get<String>("toValue"),
          type: ValueType.pathData,
        );
      case "color":
        return _JsonAnimationProperty<int>(
          layerId: layerId,
          propertyName: propertyName,
          startTime: startTime,
          endTime: endTime,
          interpolator: interpolator,
          begin: _colorFromHex(json.get<String>("fromValue")),
          end: _colorFromHex(json.get<String>("toValue")),
          type: ValueType.color,
        );
      case "number":
        return _JsonAnimationProperty<double>(
          layerId: layerId,
          propertyName: propertyName,
          startTime: startTime,
          endTime: endTime,
          interpolator: interpolator,
          begin: json.get<num>("fromValue").toDouble(),
          end: json.get<num>("toValue").toDouble(),
          type: ValueType.number,
        );
      default:
        throw UnsupportedAnimationProperty(type);
    }
  }

  static String _interpolatorFromString(String interpolator) {
    switch (interpolator) {
      case "FAST_OUT_SLOW_IN":
        return "ShapeshifterCurves.fastOutSlowIn";
      case "FAST_OUT_LINEAR_IN":
        return "ShapeshifterCurves.fastOutLinearIn";
      case "LINEAR_OUT_SLOW_IN":
        return "ShapeshifterCurves.linearOutSlowIn";
      case "ACCELERATE_DECELERATE":
        return "ShapeshifterCurves.accelerateDecelerate";
      case "ACCELERATE":
        return "ShapeshifterCurves.accelerate";
      case "DECELERATE":
        return "ShapeshifterCurves.decelerate";
      case "ANTICIPATE":
        return "ShapeshifterCurves.anticipate";
      case "OVERSHOOT":
        return "ShapeshifterCurves.overshoot";
      case "BOUNCE":
        return "ShapeshifterCurves.bounce";
      case "ANTICIPATE_OVERSHOOT":
        return "ShapeshifterCurves.anticipateOvershoot";
      case "LINEAR":
      default:
        return "ShapeshifterCurves.linear";
    }
  }
}

int? _colorFromHex(String? hex) {
  if (hex == null) return null;

  String cleanHex = hex.replaceAll("#", "");
  cleanHex = switch (cleanHex.length) {
    6 => ["FF", cleanHex].join(),
    3 => ["FF", cleanHex, cleanHex].join(),
    2 => ["FF", cleanHex, cleanHex, cleanHex].join(),
    _ => cleanHex,
  };
  final int? colorValue = int.tryParse(cleanHex, radix: 16);

  return colorValue;
}

class UnsupportedAnimationProperty implements Exception {
  final String property;

  const UnsupportedAnimationProperty(this.property);

  @override
  String toString() {
    return "The property '$property' is not handled from the lib or not valid";
  }
}

class MissingPropertyException implements Exception {
  final String property;

  const MissingPropertyException(this.property);

  @override
  String toString() {
    return "MissingPropertyException: The provided json doesn't have required property '$property'";
  }
}

extension MapGet<K> on Map<K, dynamic> {
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
