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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(const bool.fromEnvironment("dart.library.io"));
          final _ = await AnimatedVectorData.loadFromFile(
            r"C:\Users\dnbia\Projects\animated_vector\example\assets\isocube.shapeshifter",
          );
        },
      ),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            AnimatedVectorButton(
              item: AnimatedVectors.arrow_to_drawer,
              reverseItem: AnimatedVectors.drawer_to_arrow,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.search_to_close,
              reverseItem: AnimatedVectors.close_to_search,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.collapse_to_expand,
              reverseItem: AnimatedVectors.expand_to_collapse,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.cross_to_tick,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.minus_to_plus,
              reverseItem: AnimatedVectors.plus_to_minus,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.music_previous,
              resetOnClick: false,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.music_next,
              resetOnClick: false,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.pause_to_play,
              reverseItem: AnimatedVectors.play_to_pause,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: CustomVectors.search_to_back,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.visibility_toggle,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: CustomVectors.add_transition,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: CustomVectors.apps_to_close,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.search_to_more,
              reverseItem: AnimatedVectors.more_to_search,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.search_to_back,
              reverseItem: AnimatedVectors.back_to_search,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.menu_to_close,
              reverseItem: AnimatedVectors.close_to_menu,
              size: _iconSize,
            ),
            AnimatedVectorButton(
              item: AnimatedVectors.more_to_close,
              reverseItem: AnimatedVectors.close_to_more,
              size: _iconSize,
            ),
            AnimatedCarouselSwitcher(
              sequence: const [
                SequenceItem(AnimatedVectors.search_to_more),
                SequenceItem(AnimatedVectors.more_to_close),
                SequenceItem(AnimatedVectors.close_to_menu),
                SequenceItem(AnimatedVectors.drawer_to_arrow),
                SequenceItem(AnimatedVectors.back_to_search),
              ],
              size: _iconSize,
            ),
            AnimatedCubeButton(size: _iconSize),
            AnimatedVectorJumpCarousel(size: _iconSize),
            AnimatedCarouselSwitcher(sequence: digitSequence, size: _iconSize),
            AnimatedDownloadCarousel(size: _iconSize),
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

    return _Button(
      onTap: () {
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
      child: widget.reverseItem != null
          ? AnimatedSequence(
              items: [
                SequenceItem(widget.item),
                SequenceItem(widget.reverseItem!),
              ],
              autostart: false,
              controller: _controller,
              size: size,
              applyTheme: true,
            )
          : AnimatedVector(
              vector: widget.item,
              progress: _ac,
              size: size,
              applyTheme: true,
            ),
    );
  }
}

class AnimatedCubeButton extends StatefulWidget {
  final double size;

  const AnimatedCubeButton({
    required this.size,
    super.key,
  });

  @override
  State<AnimatedCubeButton> createState() => _AnimatedCubeButtonState();
}

class _AnimatedCubeButtonState extends State<AnimatedCubeButton>
    with SingleTickerProviderStateMixin {
  late final _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Size.square(widget.size);

    return _Button(
      onTap: () {
        _ac.value = 0;
        _ac.forward();
      },
      child: AnimatedVector(
        vector: CustomVectors.isocube,
        progress: _ac,
        size: size,
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
    return _Button(
      onTap: () {
        controller.jumpTo("loopend");
      },
      child: AnimatedSequence(
        items: const [
          SequenceGroup(
            repeatCount: null,
            children: [
              SequenceItem(
                AnimatedVectors.arrow_to_drawer,
                nextOnComplete: true,
              ),
              SequenceItem(
                AnimatedVectors.drawer_to_arrow,
                nextOnComplete: true,
              ),
              SequenceItem(AnimatedVectors.plus_to_minus, nextOnComplete: true),
              SequenceItem(AnimatedVectors.minus_to_plus, nextOnComplete: true),
              SequenceItem(
                AnimatedVectors.search_to_close,
                nextOnComplete: true,
              ),
              SequenceItem(
                AnimatedVectors.close_to_search,
                nextOnComplete: true,
              ),
            ],
          ),
          SequenceItem(
            AnimatedVectors.pause_to_play,
            nextOnComplete: true,
            tag: "loopend",
          ),
          SequenceItem(
            AnimatedVectors.play_to_pause,
            nextOnComplete: true,
          ),
        ],
        controller: controller,
        applyTheme: true,
        size: Size.square(widget.size),
      ),
    );
  }
}

class AnimatedDownloadCarousel extends StatefulWidget {
  final double size;

  const AnimatedDownloadCarousel({required this.size, super.key});

  @override
  State<AnimatedDownloadCarousel> createState() =>
      _AnimatedDownloadCarouselState();
}

class _AnimatedDownloadCarouselState extends State<AnimatedDownloadCarousel> {
  final controller = AnimatedSequenceController();

  @override
  Widget build(BuildContext context) {
    return _Button(
      onTap: () {
        controller.skip();
      },
      child: AnimatedSequence(
        items: CustomSequences.download,
        controller: controller,
        applyTheme: true,
        size: Size.square(widget.size),
      ),
    );
  }
}

class AnimatedCarouselSwitcher extends StatefulWidget {
  final List<SequenceEntry> sequence;
  final double size;

  const AnimatedCarouselSwitcher({
    required this.sequence,
    required this.size,
    super.key,
  });

  @override
  State<AnimatedCarouselSwitcher> createState() =>
      _AnimatedCarouselSwitcherState();
}

class _AnimatedCarouselSwitcherState extends State<AnimatedCarouselSwitcher> {
  final controller = AnimatedSequenceController();

  @override
  Widget build(BuildContext context) {
    return _Button(
      onTap: () {
        controller.skip();
      },
      child: AnimatedSequence(
        items: widget.sequence,
        controller: controller,
        applyTheme: true,
        autostart: false,
        size: Size.square(widget.size),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _Button({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        radius: 32,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}
