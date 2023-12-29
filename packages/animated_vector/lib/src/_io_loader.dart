import 'dart:io';

import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/shapeshifter.dart';

Future<AnimatedVectorData> loadDataFromFile(String path) async {
  return ShapeShifterConverter.toAVD(await File(path).readAsString());
}
