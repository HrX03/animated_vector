import 'dart:async';
import 'dart:io';

import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/shapeshifter.dart';
import 'package:flutter/services.dart';

typedef DataLoadedCallback = void Function(AnimatedVectorData data);

class _DataCache {
  final int maximumSize;
  final _cache = <String, AnimatedVectorData>{};

  _DataCache({int? maximumSize}) : maximumSize = maximumSize ?? 1000;

  static final _DataCache instance = _DataCache();

  Future<AnimatedVectorData> putIfAbsent(
    String key,
    FutureOr<AnimatedVectorData> Function() load,
  ) async {
    AnimatedVectorData? composition = _cache[key];
    if (composition != null) {
      return composition;
    } else {
      composition = await load();
    }

    _cache[key] = composition;

    _checkCacheSize();

    return composition;
  }

  void _checkCacheSize() {
    while (_cache.length > maximumSize) {
      _cache.remove(_cache.keys.first);
    }
  }

  void clear() {
    _cache.clear();
  }
}

abstract class AnimatedVectorDataProvider {
  const AnimatedVectorDataProvider();

  FutureOr<AnimatedVectorData> load() {
    return _DataCache.instance.putIfAbsent(key, _load);
  }

  String get key;
  FutureOr<AnimatedVectorData> _load();
}

class DirectAnimatedVectorData extends AnimatedVectorDataProvider {
  final AnimatedVectorData data;

  const DirectAnimatedVectorData(this.data);

  @override
  String get key => "data-${data.hashCode}";

  @override
  AnimatedVectorData load() => _load();
  @override
  AnimatedVectorData _load() => data;

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is DirectAnimatedVectorData) {
      return data == other.data;
    }

    return false;
  }
}

class AssetAnimatedVectorData extends AnimatedVectorDataProvider {
  final String assetName;
  final AssetBundle? bundle;
  final String? package;

  const AssetAnimatedVectorData(
    this.assetName, {
    this.bundle,
    this.package,
  });

  @override
  String get key => "asset-$assetKey";

  String get assetKey =>
      package != null ? "packages/$package/$assetName" : assetName;

  @override
  Future<AnimatedVectorData> _load() async {
    final AssetBundle _bundle = bundle ?? rootBundle;

    return _bundle.loadStructuredData(
      assetKey,
      (value) async => ShapeshifterConverter.toAVD(value),
    );
  }

  @override
  int get hashCode => assetName.hashCode ^ bundle.hashCode ^ package.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is AssetAnimatedVectorData) {
      return key == other.key;
    }

    return false;
  }
}

class FileAnimatedVectorData extends AnimatedVectorDataProvider {
  final File origin;

  const FileAnimatedVectorData(this.origin);

  @override
  String get key => "file-${origin.path}";

  @override
  Future<AnimatedVectorData> _load() async {
    return ShapeshifterConverter.toAVD(await origin.readAsString());
  }

  @override
  int get hashCode => origin.path.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is FileAnimatedVectorData) {
      return origin.path == other.origin.path;
    }

    return false;
  }
}
