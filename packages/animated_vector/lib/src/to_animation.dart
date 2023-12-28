import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:animated_vector/animated_vector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// The format to use when exporting an [AnimatedVectorData].
/// Currently the only two supported formats are [gif] and [apng]
enum ExportAnimationFormat {
  /// Export the animation as an animated GIF.
  /// The max framerate it supports is 50.
  gif,

  /// Export the animation as an animated PNG (APNG).
  /// It has no framerate limit and encodes images at the best quality with support
  /// for transparency, but it might not be well supported by many apps.
  apng,
}

/// An extension over [AnimatedVectorData] to export it to an animated file format
/// to allow display over other apps.
extension AnimatedVectorDataToAnimation on AnimatedVectorData {
  /// Tranforms this [AnimatedVectorData] into an encoded byte list that represents
  /// an animated image file, either GIF or APNG.
  /// The byte encoding is ran on an isolate on non web platforms using [compute].
  ///
  /// The [format] parameter defines the output file format, either
  /// [ExportAnimationFormat.gif] or [ExportAnimationFormat.apng].
  /// See the docs on the specific values for info about these formats.
  ///
  /// [backgroundColor] sets the background color of the whole animation,
  /// defaults to [Colors.transparent]
  ///
  /// [frameRate] sets the frame rate of the animation to be as specified,
  /// defaults to 30. Must be greater than 0.
  ///
  /// [lastFrameDurationOverride] allows you to set a specific duration for the
  /// last frame, usually used to hold it for longer.
  /// Specified in milliseconds, default to null.
  ///
  /// [targetSize] allows to define the output resolution of the exported file,
  /// by default it will export at the resolution the animation declares.
  /// Must be finite, positive and not empty if specified.
  ///
  /// [frameDurationModifier] is a modifier number that allows more granular control
  /// over the duration of the frames. If for example it gets set to 2.0 it makes
  /// the animation twice as long with half the frame rate.
  /// Defaults to 1.0 and must be greater than 0.
  Future<Uint8List> renderAnimation({
    ExportAnimationFormat format = ExportAnimationFormat.gif,
    Color backgroundColor = Colors.transparent,
    int frameRate = 30,
    int? lastFrameDurationOverride,
    Size? targetSize,
    double frameDurationModifier = 1.0,
  }) async {
    assert(frameRate > 0);
    assert(frameDurationModifier > 0);
    assert(targetSize == null || !targetSize.isEmpty || !targetSize.isInfinite);

    final (width, height) = (
      (targetSize?.width ?? viewportSize.width),
      (targetSize?.height ?? viewportSize.height),
    );
    final frameDuration = (1000 / frameRate).floor();
    final animationStepInterval = frameDuration / duration.inMilliseconds;

    img.Image? gif;

    double progress = 0.0;
    bool shouldAnimate = true;

    while (shouldAnimate) {
      if (progress >= 1.0) shouldAnimate = false;

      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.scale(width / viewportSize.width, height / viewportSize.height);
      canvas.drawColor(backgroundColor, BlendMode.srcOver);
      paint(
        canvas,
        Size(width, height),
        progress.clamp(0.0, 1.0),
        duration,
        Matrix4.identity(),
      );
      final picture = recorder.endRecording();

      final image = await picture.toImage(width.toInt(), height.toInt());
      final byteData = await image.toByteData();
      final dartImage = await Isolate.run(
        () => img.Image.fromBytes(
          width: width.toInt(),
          height: height.toInt(),
          bytes: byteData!.buffer,
          numChannels: 4,
          frameDuration: (frameDuration * frameDurationModifier).floor(),
        ),
      );
      switch (gif) {
        case null:
          gif = dartImage;
        default:
          gif.addFrame(dartImage);
      }
      image.dispose();
      picture.dispose();

      progress += animationStepInterval;
    }

    if (lastFrameDurationOverride != null) {
      gif!.frames.last.frameDuration = lastFrameDurationOverride;
    }

    final encoder = switch (format) {
      ExportAnimationFormat.gif => img.encodeGif,
      ExportAnimationFormat.apng => img.encodePng,
    };

    return compute((gif) => encoder(gif), gif!);
  }
}
