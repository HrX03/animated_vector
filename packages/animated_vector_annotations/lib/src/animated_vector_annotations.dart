import 'package:meta/meta_meta.dart';

/// An annotation to generate [AnimatedVectorData] from a shapeshifter file.
@Target({TargetKind.field, TargetKind.topLevelVariable})
class ShapeshifterAsset {
  /// The path of the shapeshifter file to convert
  final String path;

  /// Convert a shapeshifter file into an [AnimatedVectorData] that can be used
  /// with the animated_vector library.
  ///
  /// The recommended way of using this annotation is to have it over a toplevel
  /// variable or on a static field. The generated variable name will be the name
  /// of the annotated var/field with `_$` appended in front of it.
  /// The annotations will generate a part for each file they are contained in and
  /// will contain a list of generated toplevel variables to point to.
  /// An example of its usage and generated file:
  ///
  ///
  /// vectors.dart
  /// ```dart
  /// import 'package:animated_vector_annotations/animated_vector_annotations.dart';
  ///
  /// part 'vectors.g.dart';
  ///
  /// @ShapeshifterAsset("assets/icon.shapeshifter")
  /// const icon = _$icon;
  /// ```
  ///
  /// vectors.g.dart
  /// ```dart
  /// part of 'vectors.dart';
  ///
  /// const AnimatedVectorData _$icon = AnimatedVectorData(
  ///   ...
  /// );
  /// ```
  ///
  ///
  /// A shapeshifter file can be created using [ShapeShifter](https://shapeshifter.design),
  /// by selecting the File > Save option.
  ///
  /// The file needs to be inserted into one of the folders mentioned in the Dart
  /// [package layout conventions](https://dart.dev/tools/pub/package-layout#the-pubspec)
  /// or into a flutter supported folder, either assets/ or shaders/.
  /// The recommended folder for this kind of file is assets or a subdirectory inside.
  ///
  /// [path] is the path to this file relative to the package root.
  /// Absolute paths aren't supported.
  ///
  /// If static conversion of a file can't be used (for example when the file
  /// needs to be picked at runtime) then [AnimatedVectorData] has static methods
  /// to load a file from the app's assets or directly from the file system.
  const ShapeshifterAsset(this.path);
}
