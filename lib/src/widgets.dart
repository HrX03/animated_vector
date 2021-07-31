import 'dart:io';

import 'package:animated_vector/src/data.dart';
import 'package:animated_vector/src/provider.dart';
import 'package:flutter/material.dart';

class AnimatedVector extends StatelessWidget {
  final Animation<double> progress;
  final DataLoadedCallback? onDataLoaded;
  final Size? size;
  final Color? color;
  final bool applyColor;

  late final Widget _child;

  AnimatedVector({
    required AnimatedVectorDataProvider vector,
    required this.progress,
    this.onDataLoaded,
    this.color,
    this.applyColor = false,
    this.size,
    Key? key,
  }) : super(key: key) {
    _child = _getChildForProvider(vector: vector);
  }

  AnimatedVector.fromData(
    AnimatedVectorData data, {
    required this.progress,
    this.color,
    this.applyColor = false,
    this.size,
    Key? key,
  })  : onDataLoaded = null,
        _child = _AnimatedVectorBuilder(
          vector: data,
          progress: progress,
          color: color,
          applyColor: applyColor,
          size: size,
        ),
        super(key: key);

  AnimatedVector.fromFile(
    File file, {
    required this.progress,
    this.onDataLoaded,
    this.color,
    this.applyColor = false,
    this.size,
    Key? key,
  })  : _child = _AsyncAnimatedVectorBuilder(
          vector: FileAnimatedVectorData(file),
          progress: progress,
          onDataLoaded: onDataLoaded,
          color: color,
          applyColor: applyColor,
          size: size,
          key: key,
        ),
        super(key: key);

  AnimatedVector.fromAsset(
    String assetName, {
    AssetBundle? bundle,
    String? package,
    required this.progress,
    this.onDataLoaded,
    this.color,
    this.applyColor = false,
    this.size,
    Key? key,
  })  : _child = _AsyncAnimatedVectorBuilder(
          vector: AssetAnimatedVectorData(
            assetName,
            bundle: bundle,
            package: package,
          ),
          progress: progress,
          onDataLoaded: onDataLoaded,
          color: color,
          applyColor: applyColor,
          size: size,
          key: key,
        ),
        super(key: key);

  Widget _getChildForProvider({required AnimatedVectorDataProvider vector}) {
    if (vector is DirectAnimatedVectorData) {
      return _AnimatedVectorBuilder(
        vector: vector.data,
        progress: progress,
        color: color,
        applyColor: applyColor,
        size: size,
      );
    }

    return _AsyncAnimatedVectorBuilder(
      vector: vector,
      progress: progress,
      onDataLoaded: onDataLoaded,
      color: color,
      applyColor: applyColor,
      size: size,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) => _child;
}

class _AnimatedVectorBuilder extends StatelessWidget {
  final AnimatedVectorData vector;
  final Animation<double> progress;
  final Size? size;
  final Color? color;
  final bool applyColor;

  const _AnimatedVectorBuilder({
    required this.vector,
    required this.progress,
    this.color,
    this.applyColor = false,
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        Widget child = CustomPaint(
          painter: _AnimatedVectorPainter(
            vector: vector,
            progress: progress.value,
            colorOverride: applyColor
                ? color ?? Theme.of(context).iconTheme.color ?? Colors.black
                : null,
          ),
          child: SizedBox.fromSize(
            size: size ?? vector.viewportSize,
          ),
        );

        return child;
      },
    );
  }
}

class _AsyncAnimatedVectorBuilder extends StatefulWidget {
  final AnimatedVectorDataProvider vector;
  final Animation<double> progress;
  final DataLoadedCallback? onDataLoaded;
  final Size? size;
  final Color? color;
  final bool applyColor;

  const _AsyncAnimatedVectorBuilder({
    required this.vector,
    required this.progress,
    this.onDataLoaded,
    this.color,
    this.applyColor = false,
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  _AsyncAnimatedVectorBuilderState createState() =>
      _AsyncAnimatedVectorBuilderState();
}

class _AsyncAnimatedVectorBuilderState
    extends State<_AsyncAnimatedVectorBuilder> {
  AnimatedVectorData? _loadedData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant _AsyncAnimatedVectorBuilder old) {
    super.didUpdateWidget(old);
    if (widget.vector != old.vector) {
      _loadData();
    }
  }

  void _loadData() async {
    _loadedData = await widget.vector.load();
    widget.onDataLoaded?.call(_loadedData!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loadedData == null) return SizedBox.fromSize(size: widget.size);

    return _AnimatedVectorBuilder(
      vector: _loadedData!,
      progress: widget.progress,
      color: widget.color,
      applyColor: widget.applyColor,
      size: widget.size,
    );
  }
}

class _AnimatedVectorPainter extends CustomPainter {
  final AnimatedVectorData vector;
  final double progress;
  final Color? colorOverride;

  const _AnimatedVectorPainter({
    required this.vector,
    required this.progress,
    this.colorOverride,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(
      size.width / vector.viewportSize.width,
      size.height / vector.viewportSize.height,
    );

    if (colorOverride != null) {
      canvas.saveLayer(
        null,
        Paint()
          ..colorFilter = ColorFilter.mode(
            colorOverride!,
            BlendMode.srcIn,
          ),
      );
    }
    vector.root.paint(canvas, vector.viewportSize, progress, vector.duration);
    if (colorOverride != null) canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AnimatedVectorPainter old) {
    return vector != old.vector || progress != old.progress;
  }
}
