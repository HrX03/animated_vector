# animated_vector_gen

Code generator for [animated_vector](https://github.com/packages/animated_vector).
It enables the generation of vector data for animations created with [ShapeShifter](https://shapeshifter.design).

## Getting started with code gen

To use this package you'll need to depend on animated_vector, animated_vector_annotations, animated_vector_gen and build_runner as follows:

```yaml
dependencies:
    # main package dependency
    animated_vector:
    # annotations to use with the package
    animated_vector_annotations:

dev_dependencies:
    # the code generator
    animated_vector_gen:
    # the tool that scans and generates code
    build_runner:
```

## Running the builder

You have two options regarding this:
- You can run the builder each time you modify your files with the following command: ```dart run build_runner build```
- You can start the builder in watch mode, it will be a persistent process that will detect when you save your files and will auto generate what you need. You can start it with ```dart run build_runner watch```

## Usage

You'll need to add your .shapeshifter files into one of the folders mentioned in the Dart [package layout conventions](https://dart.dev/tools/pub/package-layout#the-pubspec) or into a flutter supported folder, either `assets/` or `shaders/`.  
The recommended folder for this kind of file is `assets/` or a subdirectory inside.

A shapeshifter file can be created using [ShapeShifter](https://shapeshifter.design), by selecting the File > Save option.

The `@ShapeShifterAsset` annotation will only work on toplevel const variables or static const class fields and will generate a toplevel const variable that will have as name the var/field name with a `_$` prefix.

As follows we can see an example file and the generated counterpart:

`vectors.dart`
```dart
import 'package:animated_vector_annotations/animated_vector_annotations.dart';

part 'vectors.g.dart';

@ShapeShifterAsset("assets/iconA.shapeshifter")
const iconA = _$iconA;

class Vectors {
    @ShapeShifterAsset("assets/iconB.shapeshifter")
    static const playPause = _$playPause; // the field name doesn't need to match file name, but the generated var name will always be derived from the field name.
}
```

`vectors.g.dart`
```dart
part of 'vectors.dart';

const AnimatedVectorData _$iconA = AnimatedVectorData(
  ...
);

const AnimatedVectorData _$playPause = AnimatedVectorData(
  ...
);
```
