import 'dart:ui';

import 'package:animated_vector/src/data.dart';
import 'package:collection/collection.dart';

/// An internal utility for the [AnimatedSequence] widget.
/// It manages the state of a [sequence] and handles transitions and configurations.
class SequenceMachine {
  /// The sequence to execute. This field will be read once and then converted
  /// to a list of sequential instructions similar to assembly instructions.
  final List<SequenceEntry> sequence;

  late final List<_ExecutionEntry> _instructions;
  late final Map<String, int> _tagMap;

  int _currIndex = 0;
  bool _voidTickExecuted = false;
  bool _execHalted = false;
  bool _forceExec = false;
  int? _requestedIndex;

  /// Builds a new instance of [SequenceMachine] with the provided [sequence].
  /// If tags are assigned to any item inside the sequence they must be unique.
  SequenceMachine(this.sequence) {
    final (entries, tags) = _buildExecutionEntries(sequence);
    _instructions = entries;
    _tagMap = tags;

    _instructions.add(
      (
        repetitionsLeft: _EntryPropCounter(1),
        item: _ExecutionGroupBoundary(
          start: 0,
          nextOnComplete: _instructions.last.item.nextOnComplete,
        ),
      ),
    );
  }

  SequenceItem get currentItem => (_currentEntry.item as _ExecutionItem).sItem;
  _ExecutionEntry get _currentEntry => _instructions[_currIndex];

  /// Tick the machine.
  ///
  /// The first tick executes nothing but initializes the machine, it's used to
  /// execute the animation of the first item without immediately jumping to the
  /// next one.
  ///
  /// A tick causes the left repetitions for the current item to decrease and, if
  /// they hit zero, the machine will be moved forward in the same tick.
  ///
  /// Groups aren't exposed through the [currentItem] getter and they are only used
  /// as markers in the execution entry list. They follow the same rules as individual
  /// items for repetitions and they'll eventually repeat each time inside themselves.
  ///
  /// If any item is marked as `nextOnComplete: false` then the execution is forcefully
  /// stopped and any other call to [tick] will not move the machine.
  /// The only way to exit this state is by calling [skip] or [jumpTo].
  ///
  /// When the end of the execution list is reached the machine will stop unless
  /// the last item has `nextOnComplete` set to `true`, in that case it will
  /// automatically restart.
  bool tick() {
    // we forcefully clean up the _forceExec flag as it could be dirty if skip is called instead of tick.
    // if we don't do this the next call to tick would actually move the machine even if nextOnComplete is false
    final forceExec = _forceExec;
    _forceExec = false;

    final requestedIndex = _requestedIndex;
    _requestedIndex = null;

    if (_execHalted) return false;
    if (!_voidTickExecuted) {
      _voidTickExecuted = true;
      return true;
    }

    assert(_currentEntry.item is _ExecutionItem);

    if (!_currentEntry.repetitionsLeft.decrease() && !forceExec) return true;
    _currentEntry.repetitionsLeft.reset();

    if (!_currentEntry.item.nextOnComplete && !forceExec) {
      _execHalted = true;
      return false;
    }

    if (requestedIndex != null) {
      _currIndex = requestedIndex;
    } else {
      _currIndex++;
    }
    if (_currentEntry.item is! _ExecutionGroupBoundary) return true;

    final group = _currentEntry.item as _ExecutionGroupBoundary;
    if (!_currentEntry.repetitionsLeft.decrease()) {
      _currIndex = group.start;
      return true;
    }
    _currentEntry.repetitionsLeft.reset();
    if (!_currentEntry.item.nextOnComplete && !forceExec) {
      _currIndex--;
      _execHalted = true;
      return false;
    }

    final newIndex = _currIndex + 1;
    _currIndex = newIndex >= _instructions.length ? 0 : newIndex;
    return true;
  }

  /// Forcefully skip ahead to the next sequence item, discarding eventual left
  /// repetitions.
  ///
  /// To skip to a precise item in the sequence list give the item a tag and use
  /// [jumpTo] with said tag.
  void skip() {
    _execHalted = false;
    _forceExec = true;
    tick();
  }

  /// Jumps to the specific item with the tag [tag].
  /// If the tag is not found inside the sequence list then this call will be ignored.
  /// To be sure that the [tag] exists use [hasTag].
  ///
  /// Behaves the same way as [skip].
  void jumpTo(String tag) {
    _requestedIndex = _tagMap[tag];
    skip();
  }

  /// Returns whether the sequence list has an item with tag [tag].
  bool hasTag(String tag) {
    return _tagMap.containsKey(tag);
  }
}

(List<_ExecutionEntry>, Map<String, int>) _buildExecutionEntries(
  List<SequenceEntry> items,
) {
  final List<_ExecutionEntry> entries = [];
  final Map<String, int> tags = {};

  for (final item in items) {
    final currentIndex = entries.length;
    switch (item) {
      case final SequenceItem item:
        entries.add(
          (
            repetitionsLeft: _EntryPropCounter(item.repeatCount),
            item: _ExecutionItem(
              sItem: item,
              nextOnComplete: item.nextOnComplete,
            ),
          ),
        );

        if (item.tag == null) continue;
        _insertTag(tags, item.tag!, currentIndex);
      case final SequenceGroup group:
        final (newEntries, newTags) = _buildExecutionEntries(group.children);
        entries.addAll(newEntries);

        for (final MapEntry(:key, :value) in newTags.entries) {
          _insertTag(tags, key, currentIndex + value);
        }

        entries.add(
          (
            repetitionsLeft: _EntryPropCounter(item.repeatCount),
            item: _ExecutionGroupBoundary(
              start: currentIndex,
              nextOnComplete: item.nextOnComplete,
            ),
          ),
        );
    }
  }

  return (entries, tags);
}

void _insertTag(Map<String, int> origin, String tag, int index) {
  if (origin.containsKey(tag)) {
    throw Exception("Duplicate key found in sequence: $tag");
  }
  origin[tag] = index;
}

typedef _ExecutionEntry = ({
  _EntryPropCounter repetitionsLeft,
  _ExecutionBaseItem item,
});

class _EntryPropCounter {
  final int? count;
  int? _counter;

  _EntryPropCounter(this.count) : _counter = count;

  // returns a bool to signal whether the counter is considered completed, like
  // reaching the end of an iterable
  bool decrease() {
    if (_counter == null) return false;
    _counter = _counter! - 1;

    return _counter! <= 0;
  }

  void reset() => _counter = count;
}

/// Represents an entry inside [AnimatedSequence] or [SequenceMachine].
///
/// The class has two implementers:
/// - [SequenceItem]: A single animated vector that sits inside the sequence
/// - [SequenceGroup]: Groups multiple [SequenceEntry]s into one configurable block
sealed class SequenceEntry {
  /// The numbers of time to repeat this animation before being marked as complete.
  /// If this value is set to null the animation will loop until manually skipped.
  /// This value must be a greater than 0 integer.
  final int? repeatCount;

  /// If this flag is set to true any call to [AnimatedSequenceController.skip] will
  /// have the current item immediately skipping without waiting for it to complete
  /// before jumping ahead
  final bool skipMidAnimation;

  /// Whether to automatically jump to the next item in the sequence once this item
  /// has finished playing
  final bool nextOnComplete;

  /// Abstract super constructor.
  /// repeatCount must either be null or greater than zero.
  const SequenceEntry({
    this.repeatCount = 1,
    this.skipMidAnimation = true,
    this.nextOnComplete = false,
  }) : assert(repeatCount == null || repeatCount > 0);

  @override
  int get hashCode => Object.hash(
        repeatCount,
        skipMidAnimation,
        nextOnComplete,
      );

  @override
  bool operator ==(Object other) {
    if (other is SequenceItem) {
      return repeatCount == other.repeatCount &&
          skipMidAnimation == other.skipMidAnimation &&
          nextOnComplete == other.nextOnComplete;
    }

    return false;
  }
}

/// Single item version of [SequenceEntry].
///
/// Requires a single [AnimatedVectorData] to be provided and optionally a
/// [colorOverride] and a [tag].
class SequenceItem extends SequenceEntry {
  /// The vector data this sequence item holds
  final AnimatedVectorData data;

  /// An optional color that will override the color of this item vector data
  final Color? colorOverride;

  /// The blend mode to use when applying colors over this item
  final BlendMode? blendMode;

  /// Used to jump to a specific item in a sequence using the
  /// [AnimatedSequenceController.jumpTo] method
  final String? tag;

  /// Builds an instance of [SequenceItem].
  /// The [data] argument is required, [repeatCount] must be greater than zero.
  const SequenceItem(
    this.data, {
    super.repeatCount,
    super.skipMidAnimation,
    super.nextOnComplete,
    this.colorOverride,
    this.blendMode,
    this.tag,
  });

  @override
  int get hashCode => Object.hash(
        repeatCount,
        skipMidAnimation,
        nextOnComplete,
        data,
        colorOverride,
        blendMode,
        tag,
      );

  @override
  bool operator ==(Object other) {
    if (other is SequenceItem) {
      return repeatCount == other.repeatCount &&
          skipMidAnimation == other.skipMidAnimation &&
          nextOnComplete == other.nextOnComplete &&
          data == other.data &&
          colorOverride == other.colorOverride &&
          blendMode == other.blendMode &&
          tag == other.tag;
    }

    return false;
  }
}

/// A subclass of [SequenceEntry] that treats multiple [SequenceEntry]s as a single one.
///
/// The properties set in the class will be checked only after the last item of
/// [children] will be done executing.
class SequenceGroup extends SequenceEntry {
  final List<SequenceEntry> children;

  /// Builds an instance of [SequenceGroup].
  /// The [children] argument is required, [repeatCount] must be greater than zero.
  const SequenceGroup({
    required this.children,
    super.repeatCount,
    super.skipMidAnimation,
    super.nextOnComplete,
  });

  @override
  int get hashCode => Object.hash(
        repeatCount,
        skipMidAnimation,
        nextOnComplete,
        children,
      );

  @override
  bool operator ==(Object other) {
    if (other is SequenceGroup) {
      return repeatCount == other.repeatCount &&
          skipMidAnimation == other.skipMidAnimation &&
          nextOnComplete == other.nextOnComplete &&
          const ListEquality().equals(children, other.children);
    }

    return false;
  }
}

sealed class _ExecutionBaseItem {
  final bool nextOnComplete;

  const _ExecutionBaseItem({required this.nextOnComplete});
}

class _ExecutionItem extends _ExecutionBaseItem {
  final SequenceItem sItem;

  const _ExecutionItem({required this.sItem, required super.nextOnComplete});
}

class _ExecutionGroupBoundary extends _ExecutionBaseItem {
  final int start;

  const _ExecutionGroupBoundary({
    required this.start,
    required super.nextOnComplete,
  });
}
