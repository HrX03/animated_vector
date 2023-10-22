import 'package:analyzer/dart/element/element.dart';
import 'package:animated_vector_annotations/animated_vector_annotations.dart';
import 'package:animated_vector_gen/src/json.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart'
    show
        AnnotatedElement,
        ConstantReader,
        Generator,
        LibraryReader,
        TypeChecker;

class ShapeshifterAssetGenerator extends Generator {
  TypeChecker get typeChecker =>
      const TypeChecker.fromRuntime(ShapeshifterAsset);

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final List<AnnotatedElement> elements = [];
    elements.addAll(library.annotatedWith(typeChecker));

    for (final cls in library.classes) {
      for (final element in cls.fields) {
        final annotation = typeChecker.firstAnnotationOf(element);
        if (annotation != null) {
          elements.add(AnnotatedElement(ConstantReader(annotation), element));
        }
      }
    }

    final List<String> parts = [];
    for (final element in elements) {
      final generated = await generateForAnnotatedElement(
        element.element,
        element.annotation,
        buildStep,
      );
      parts.add(generated);
    }

    return parts.join("\n\n");
  }

  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! VariableElement || !element.isStatic) {
      throw Exception(
        "Only a toplevel variable or a static class field can be annotated with @ShapeshifterAsset.\nTried annotating ${element.source}.",
      );
    }

    if (!element.isConst) {
      throw Exception("The annotated field must be const.\n${element.source}.");
    }

    final filePath = annotation.read("path").stringValue;
    final assets = await buildStep.findAssets(Glob(filePath)).toList();
    if (assets.isEmpty) {
      throw Exception(
        "No file found for path $filePath, make sure the path is correct and the file exists",
      );
    }

    if (assets.length > 1) {
      throw Exception(
        "Multiple inputs found for path $filePath, make sure to enter a fully qualified path",
      );
    }

    final vectorJson = await buildStep.readAsString(assets.first);
    final result = jsonToCode(vectorJson);

    final emitter = DartEmitter();
    final field = Field(
      (b) => b
        ..name = "_\$${element.name}"
        ..type = refer(
          "AnimatedVectorData",
          "package:animated_vector/animated_vector.dart",
        )
        ..modifier = FieldModifier.constant
        ..assignment = Code('$result'),
    );

    return field.accept(emitter).toString();
  }
}
