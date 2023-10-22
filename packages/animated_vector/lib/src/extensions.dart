extension ListNullGet<T> on List<T> {
  T? getOrNull(int index) {
    if (index < 0 || index > length - 1) {
      return null;
    }
    return this[index];
  }
}

extension DoubleWrapper on double {
  double wrap(double min, double max) {
    if (this > max || this < min) {
      return min + (this - min) % (max - min);
    } else {
      return this;
    }
  }
}

extension NumHelper on num {
  bool get isInt {
    if (this is int) return true;
    return (this % 1) == 0;
  }

  num get eventuallyAsInt {
    if (isInt) return round();
    return this;
  }
}
