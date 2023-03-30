import 'dart:ui';

import 'package:animated_vector/src/path.dart';
import 'package:flutter/animation.dart';

abstract final class ShapeshifterCurves {
  const ShapeshifterCurves._();

  static const Curve linear = Curves.linear;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve fastOutLinearIn = Cubic(0.4, 0, 1, 1);
  static const Curve linearOutSlowIn = Cubic(0, 0, 0.2, 1);
  static const Curve accelerateDecelerate = Cubic(0.455, 0.03, 0.515, 0.955);
  static const Curve accelerate = Cubic(0.55, 0.085, 0.68, 0.53);
  static const Curve decelerate = Cubic(0.25, 0.46, 0.45, 0.94);
  static const Curve anticipate = _AnticipateCurve();
  static const Curve overshoot = _OvershootCurve();
  static const Curve bounce = _BounceCurve();
  static const Curve anticipateOvershoot = _AnticipateOvershootCurve();
}

class _AnticipateCurve extends Curve {
  const _AnticipateCurve();

  @override
  double transformInternal(double t) {
    return t * t * ((2 + 1) * t - 2);
  }
}

class _OvershootCurve extends Curve {
  const _OvershootCurve();

  @override
  double transformInternal(double t) {
    return (t - 1) * (t - 1) * ((2 + 1) * (t - 1) + 2) + 1;
  }
}

class _BounceCurve extends Curve {
  const _BounceCurve();

  @override
  double transformInternal(double t) {
    double bounceFn(double t) => t * t * 8;

    t *= 1.1226;
    if (t < 0.3535) {
      return bounceFn(t);
    } else if (t < 0.7408) {
      return bounceFn(t - 0.54719) + 0.7;
    } else if (t < 0.9644) {
      return bounceFn(t - 0.8526) + 0.9;
    } else {
      return bounceFn(t - 1.0435) + 0.95;
    }
  }
}

class _AnticipateOvershootCurve extends Curve {
  const _AnticipateOvershootCurve();

  @override
  double transformInternal(double t) {
    double a(double t, double s) {
      return t * t * ((s + 1) * t - s);
    }

    double o(double t, double s) {
      return t * t * ((s + 1) * t + s);
    }

    if (t < 0.5) {
      return 0.5 * a(t * 2, 2 * 1.5);
    } else {
      return 0.5 * (o(t * 2 - 2, 2 * 1.5) + 2);
    }
  }
}

class PathCurve extends Curve {
  final PathData pathData;

  const PathCurve(this.pathData);

  @override
  double transformInternal(double t) {
    final Path path = pathData.toPath();
    assert(path.getBounds() == const Rect.fromLTWH(0, 0, 1, 1));

    final PathMetrics metrics = path.computeMetrics();
    final List<PathMetric> metricList = metrics.toList();
    assert(metricList.length == 1);

    for (final PathMetric metric in metricList) {
      return metric.getTangentForOffset(t)?.position.dy ?? 0;
    }

    return 0;
  }
}
