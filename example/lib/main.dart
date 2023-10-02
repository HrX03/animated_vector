import 'package:animated_vector/animated_vector.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("animated_vector example"),
      ),
      body: const Center(
        child: Wrap(
          children: [
            AnimatedVectorButton(
              item: AnimatedVectors.arrowToDrawer,
              reverseItem: AnimatedVectors.drawerToArrow,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.closeToSearch,
              reverseItem: AnimatedVectors.searchToClose,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.collapseToExpand,
              reverseItem: AnimatedVectors.expandToCollapse,
            ),
            AnimatedVectorButton(item: AnimatedVectors.crossToTick),
            AnimatedVectorButton(
              item: AnimatedVectors.minusToPlus,
              reverseItem: AnimatedVectors.plusToMinus,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.musicPrevious,
              resetOnClick: false,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.musicNext,
              resetOnClick: false,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.pauseToPlay,
              reverseItem: AnimatedVectors.playToPause,
            ),
            AnimatedVectorButton(item: AnimatedVectors.searchToBack),
            AnimatedVectorButton(item: AnimatedVectors.visibilityToggle),
          ],
        ),
      ),
    );
  }
}

class AnimatedVectorButton extends StatefulWidget {
  final AnimatedVectorData item;
  final AnimatedVectorData? reverseItem;
  final bool resetOnClick;

  const AnimatedVectorButton({
    required this.item,
    this.reverseItem,
    this.resetOnClick = true,
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
    return IconButton(
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
            )
          : AnimatedVector(
              vector: widget.item,
              progress: _ac,
              size: widget.item.viewportSize.aspectRatio == 1.0
                  ? const Size.square(24)
                  : null,
            ),
    );
  }
}
