import 'package:animated_vector/animated_vector.dart';
import 'package:example/custom.dart';
import 'package:example/digits.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  double _iconSize = 32;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("animated_vector example"),
      ),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            AnimatedVectorButton(
              item: AnimatedVectors.arrowToDrawer,
              reverseItem: AnimatedVectors.drawerToArrow,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.closeToSearch,
              reverseItem: AnimatedVectors.searchToClose,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.collapseToExpand,
              reverseItem: AnimatedVectors.expandToCollapse,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.crossToTick,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.minusToPlus,
              reverseItem: AnimatedVectors.plusToMinus,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.musicPrevious,
              resetOnClick: false,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.musicNext,
              resetOnClick: false,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.pauseToPlay,
              reverseItem: AnimatedVectors.playToPause,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.searchToBack,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.visibilityToggle,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: CustomVectors.addTransition,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: CustomVectors.appsToClose,
              size: _iconSize,
            ),
            AnimatedVectorJumpCarousel(size: _iconSize),
            AnimatedDigitSwitcher(size: _iconSize),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text("Icon size"),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: _iconSize,
                  onChanged: (value) =>
                      setState(() => _iconSize = value.roundToDouble()),
                  divisions: 56 - 16,
                  min: 16,
                  max: 56,
                ),
              ),
              const SizedBox(width: 16),
              Text(_iconSize.round().toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedVectorButton extends StatefulWidget {
  final AnimatedVectorData item;
  final AnimatedVectorData? reverseItem;
  final bool resetOnClick;
  final double size;

  const AnimatedVectorButton({
    required this.item,
    this.reverseItem,
    this.resetOnClick = true,
    required this.size,
    super.key,
  });

  @override
  State<AnimatedVectorButton> createState() => _AnimatedVectorButtonState();
}

class _AnimatedVectorButtonState extends State<AnimatedVectorButton>
    with SingleTickerProviderStateMixin {
  late final _ac = AnimationController(
    vsync: this,
    duration: widget.item.duration,
  );
  final _controller = AnimatedSequenceController();

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.item.viewportSize.aspectRatio == 1.0
        ? Size.square(widget.size)
        : () {
            final min = widget.item.viewportSize.shortestSide;
            final ratio = widget.size / min;

            return widget.item.viewportSize * ratio;
          }();

    return IconButton(
      iconSize: widget.size,
      onPressed: () {
        if (widget.reverseItem != null) {
          _controller.skip();
        } else if (widget.resetOnClick) {
          if (_ac.isCompleted) {
            _ac.value = 0;
          } else {
            _ac.forward();
          }
        } else {
          _ac.value = 0;
          _ac.forward();
        }
      },
      icon: widget.reverseItem != null
          ? AnimatedSequence(
              items: [
                SequenceItem(widget.item),
                SequenceItem(widget.reverseItem!),
              ],
              autostart: false,
              controller: _controller,
              size: size,
              applyColor: true,
            )
          : AnimatedVector(
              vector: widget.item,
              progress: _ac,
              size: size,
              applyColor: true,
            ),
    );
  }
}

class AnimatedVectorJumpCarousel extends StatefulWidget {
  final double size;

  const AnimatedVectorJumpCarousel({required this.size, super.key});

  @override
  State<AnimatedVectorJumpCarousel> createState() =>
      _AnimatedVectorJumpCarouselState();
}

class _AnimatedVectorJumpCarouselState
    extends State<AnimatedVectorJumpCarousel> {
  final controller = AnimatedSequenceController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.size,
      onPressed: () {
        controller.jumpTo("loopend");
      },
      icon: AnimatedSequence(
        items: const [
          SequenceGroup(
            repeatCount: null,
            children: [
              SequenceItem(AnimatedVectors.arrowToDrawer, nextOnComplete: true),
              SequenceItem(AnimatedVectors.drawerToArrow, nextOnComplete: true),
              SequenceItem(AnimatedVectors.plusToMinus, nextOnComplete: true),
              SequenceItem(AnimatedVectors.minusToPlus, nextOnComplete: true),
              SequenceItem(AnimatedVectors.searchToClose, nextOnComplete: true),
              SequenceItem(AnimatedVectors.closeToSearch, nextOnComplete: true),
            ],
          ),
          SequenceItem(
            AnimatedVectors.pauseToPlay,
            nextOnComplete: true,
            tag: "loopend",
          ),
          SequenceItem(
            AnimatedVectors.playToPause,
            nextOnComplete: true,
          ),
        ],
        controller: controller,
        applyColor: true,
        size: Size.square(widget.size),
      ),
    );
  }
}

class AnimatedDigitSwitcher extends StatefulWidget {
  final double size;

  const AnimatedDigitSwitcher({
    required this.size,
    super.key,
  });

  @override
  State<AnimatedDigitSwitcher> createState() => _AnimatedDigitSwitcherState();
}

class _AnimatedDigitSwitcherState extends State<AnimatedDigitSwitcher> {
  final controller = AnimatedSequenceController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.size,
      onPressed: () {
        controller.skip();
      },
      icon: AnimatedSequence(
        items: digitSequence,
        controller: controller,
        applyColor: true,
        autostart: false,
        size: Size.square(widget.size),
      ),
    );
  }
}
