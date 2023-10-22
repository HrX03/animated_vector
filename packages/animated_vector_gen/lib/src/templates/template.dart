abstract class Template {
  const Template();

  String? build();

  @override
  String toString() => build().toString();
}

abstract class ElementTemplate extends Template {
  const ElementTemplate();
}
