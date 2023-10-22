import 'package:animated_vector_gen/src/shapeshifter_asset.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder animatedVectorBuilder(BuilderOptions options) =>
    SharedPartBuilder([ShapeshifterAssetGenerator()], 'vector');
