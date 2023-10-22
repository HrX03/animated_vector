import 'package:meta/meta_meta.dart';

@Target({TargetKind.field, TargetKind.topLevelVariable})
class ShapeshifterAsset {
  final String path;

  const ShapeshifterAsset(this.path);
}
