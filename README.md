<p align="center">
  <img src="https://raw.githubusercontent.com/HrX03/animated_vector/main/static/logo_dark.gif#gh-dark-mode-only" height="128px" alt="animated_vector" />
  <img src="https://raw.githubusercontent.com/HrX03/animated_vector/main/static/logo_light.gif#gh-light-mode-only" height="128px" alt="animated_vector" />
</p>

# animated_vector

Define and use animated vectors all in your code editor with a data format inspired by flutter's composable widgets.

### [Live site with examples](https://hrx03.github.io/animated_vector/)

## Usage

You'll need to depend on animated_vector first of all:

```yaml
dependencies:
  animated_vector: ^0.1.0
```

After that, you can use animations with either the [AnimatedVector](https://pub.dev/documentation/animated_vector/latest/animated_vector/AnimatedVector-class.html) widget for simple animations and/or low level control, or the [AnimatedSequence](https://pub.dev/documentation/animated_vector/latest/animated_vector/AnimatedSequence-class.html) widget to create more complex interactions between multiple animations.

[AnimatedVectorData](https://pub.dev/documentation/animated_vector/latest/animated_vector/AnimatedVectorData-class.html) exposes some even lower level methods that you can use to paint directly on a canvas for example, check the docs for full info.

The package bundles multiple already made vector animations, all available on the [AnimatedVectors](https://pub.dev/documentation/animated_vector/latest/animated_vector/AnimatedVectorData-class.html) class.

An example is available on [the package example](https://github.com/HrX03/animated_vector/tree/main/example/).

## Description and inspiration
The data format is heavily inspired from the AnimatedVectorDrawable from android, which allows for pretty flexible animations.
It also adapts the declarative style for definitions, allowing for immutable composable instances.

[This article](https://www.androiddesignpatterns.com/2016/11/introduction-to-icon-animation-techniques.html) was the main reason for developing this package, huge props to the author for the awesome resource.

## Support
The package should support every single platform as it doesn't depend on any platform specific implementation, it's completely dart and flutter.
In case you need any help with the package, head over to the [github issues page](https://github.com/HrX03/animated_vector/issues).

## Extras
Code generation is available for generating `AnimatedVectorData` from `.shapeshifter` files.

### More info over [animated_vector_gen](https://pub.dev/packages/aniamted_vector_gen).