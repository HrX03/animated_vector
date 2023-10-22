String buildConstructorCall(String name, Map<String, Object?> fields) {
  final buffer = StringBuffer("$name(\n");

  for (final MapEntry(:key, :value) in fields.entries) {
    if (value == null) continue;
    if (value is List && value.isEmpty) continue;
    final val = switch (value) {
      final List list => "[${list.join(", ")},]",
      _ => value,
    };

    buffer.writeln("  $key: $val,");
  }

  buffer.write(")");
  return buffer.toString();
}

String colorFormat(int color) {
  return "0x${color.toRadixString(16).padLeft(8, "0").toUpperCase()}";
}

bool everythingEmpty(List<List<Object?>> properties) {
  return properties.every((element) => element.isEmpty);
}

String? wrapWithConstructor(Object? value, ValueType type) {
  if (value == null) return null;

  return switch (type) {
    ValueType.pathData => "PathData.parse('$value',)",
    ValueType.color => "Color(${colorFormat(value as int)})",
    ValueType.number => value.toString(),
  };
}

enum ValueType {
  color("Color", "ColorLerp"),
  pathData("PathData", "PathDataLerp"),
  number("double", "ValueLerp<double>");

  final String typeName;
  final String lerpName;

  const ValueType(this.typeName, this.lerpName);
}

T? handleDefault<T>(T? value, T defaultValue) {
  if (value == defaultValue) return null;
  return value;
}
