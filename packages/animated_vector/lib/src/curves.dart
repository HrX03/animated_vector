import 'package:flutter/animation.dart';

/// A collection of curves used by [ShapeShifter](https://shapeshifter.design).
/// Mostly used by [animated_vector_gen](https://pub.dev/packages/animated_vector_gen).
abstract final class ShapeShifterCurves {
  const ShapeShifterCurves._();

  /// The linear curve. Default one, applies no modifications to the base animation.
  static const Curve linear = Curves.linear;

  /// A curve that starts slowly and ends fast.
  ///
  /// To view it in action: https://cubic-bezier.com/#.4,0,.2,1
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  /// A curve that starts linearly and ends fast.
  ///
  /// To view it in action: https://cubic-bezier.com/#.4,0,1,1
  static const Curve fastOutLinearIn = Cubic(0.4, 0, 1, 1);

  /// A curve that starts slowly and ends linearly.
  ///
  /// To view it in action: https://cubic-bezier.com/#0,0,.2,1
  static const Curve linearOutSlowIn = Cubic(0, 0, 0.2, 1);

  /// A curve that combines the [accelerate] and [decelerate] curve.
  ///
  /// To view it in action: https://cubic-bezier.com/#.455,.03,.515,.955
  static const Curve accelerateDecelerate = Cubic(0.455, 0.03, 0.515, 0.955);

  /// A curve that starts slow and accelerates gradually.
  ///
  /// To view it in action: https://cubic-bezier.com/#.55,.085,.68,.53
  static const Curve accelerate = Cubic(0.55, 0.085, 0.68, 0.53);

  /// A curve that starts fast and decelerates gradually.
  ///
  /// To view it in action: https://cubic-bezier.com/#.25,.46,.45,.94
  static const Curve decelerate = Cubic(0.25, 0.46, 0.45, 0.94);

  /// A curve that goes back to before the lower 0.0 bound to then gradually
  /// decelerate.
  static const Curve anticipate = _AnticipateCurve();

  /// A curve that accelerates gradually and goes over the 1.0 bound, to then
  /// bounce back in.
  static const Curve overshoot = _OvershootCurve();

  /// A curve that is very similar to flutter's [Curves.bounceOut].
  static const Curve bounce = _BounceCurve();

  /// A curve that combines both [anticipate] and [overshoot].
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

    final multipliedT = t * 1.1226;
    if (multipliedT < 0.3535) {
      return bounceFn(multipliedT);
    } else if (multipliedT < 0.7408) {
      return bounceFn(multipliedT - 0.54719) + 0.7;
    } else if (multipliedT < 0.9644) {
      return bounceFn(multipliedT - 0.8526) + 0.9;
    } else {
      return bounceFn(multipliedT - 1.0435) + 0.95;
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
