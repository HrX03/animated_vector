/// A library to use in tandem with `package:animated_vector` and `package:animated_vector_gen`.
///
/// Contains annotations for code generation, such as [ShapeshifterAsset].
library animated_vector_annotations;

export 'dart:ui' show Color, Size, StrokeCap, StrokeJoin;
export 'package:animated_vector/animated_vector.dart'
    show
        AnimatedVectorData,
        AnimationInterval,
        AnimationStep,
        ClipPathAnimationProperties,
        ClipPathElement,
        ConstColorTween,
        ConstPathDataTween,
        ConstTween,
        GroupAnimationProperties,
        GroupElement,
        PathAnimationProperties,
        PathData,
        PathElement,
        RootVectorAnimationProperties,
        RootVectorElement,
        ShapeShifterCurves;

export 'src/animated_vector_annotations.dart';
