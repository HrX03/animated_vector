import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/shapeshifter.dart';

extension ShapeshifterExporter on AnimatedVectorData {
  Map<String, dynamic> toJson(String name) {
    return ShapeshifterConverter.toJson(this, name);
  }
}
