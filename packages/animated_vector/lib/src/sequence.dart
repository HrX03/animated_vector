import 'dart:ui';

import 'package:animated_vector/src/data.dart';
import 'package:collection/collection.dart';

class SequenceMachine {
  final List<SequenceEntry> sequence;
  late final List<_ExecutionEntry> _instructions;
  late final Map<String, int> _tagMap;

  int _currIndex = 0;
  bool _voidTickExecuted = false;
  bool _execHalted = false;
  bool _forceExec = false;
  int? _requestedIndex;

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

  void skip() {
    _execHalted = false;
    _forceExec = true;
    tick();
  }

  void jumpTo(String tag) {
    _requestedIndex = _tagMap[tag];
    skip();
  }

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

sealed class SequenceEntry {
  /// The numbers of time to repeat this animation before being marked as complete.
  /// If this value is set to null the animation will loop until manually skipped.
  final int? repeatCount;

  /// If this flag is set to true any call to [AnimatedSequenceController.skip] will
  /// have the current item immediately skipping without waiting for it to complete
  /// before jumping ahead
  final bool skipMidAnimation;

  /// Whether to automatically jump to the next item in the sequence once this item
  /// has finished playing
  final bool nextOnComplete;

  const SequenceEntry({
    this.repeatCount = 1,
    this.skipMidAnimation = true,
    this.nextOnComplete = false,
  });

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

class SequenceItem extends SequenceEntry {
  /// The vector data this sequence item holds
  final AnimatedVectorData data;

  /// An optional color that will override the color of this item vector data
  final Color? colorOverride;

  /// Used to jump to a specific item in a sequence using the
  /// [AnimatedSequenceController.jumpTo] method
  final String? tag;

  const SequenceItem(
    this.data, {
    super.repeatCount,
    super.skipMidAnimation,
    super.nextOnComplete,
    this.colorOverride,
    this.tag,
  });

  @override
  int get hashCode => Object.hash(
        repeatCount,
        skipMidAnimation,
        nextOnComplete,
        data,
        colorOverride,
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
          tag == other.tag;
    }

    return false;
  }
}

class SequenceGroup extends SequenceEntry {
  final List<SequenceEntry> children;

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
