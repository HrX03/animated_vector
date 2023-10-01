import 'package:animated_vector/animated_vector.dart';

typedef SequenceData = String;

class SequenceMachine {
  final List<BaseSequenceItem> sequence;
  final List<_ExecutionEntry> _instructions;
  late final _ExecutionEntry _masterGroup;
  final List<int> _execStack = [];
  int _currIndex = 0;
  bool _voidTickExecuted = false;
  bool _execHalted = false;
  bool _forceExec = false;

  SequenceMachine(this.sequence)
      : _instructions = _buildExecutionEntries(sequence) {
    _masterGroup = _ExecutionEntry.group(
      repetitionsLeft: _EntryPropCounter(1),
      groupItemsLeft: _EntryPropCounter(sequence.length, true),
      item: const _ExecutionGroupItem(
        repeatCount: 1,
        nextOnComplete: false,
        tag: null,
      ),
    );
    _resolve();
  }

  SequenceItem get currentItem => (_currentEntry.item as _ExecutionItem).sItem;

  _ExecutionEntry get _currentEntry => _instructions[_currIndex];
  _ExecutionEntry get _stackTop =>
      _execStack.isNotEmpty ? _instructions[_execStack.last] : _masterGroup;

  bool tick() {
    // we forcefully clean up the _forceExec flag as it could be dirty if skip is called instead of tick.
    // if we don't do this the next call to tick would actually move the machine even if nextOnComplete is false
    final forceExec = _forceExec;
    _forceExec = false;

    if (_execHalted) return false;
    if (!_voidTickExecuted) {
      _voidTickExecuted = true;
      return true;
    }

    if (!_currentEntry.repetitionsLeft.decrease()) return true;

    _currentEntry.repetitionsLeft.reset();

    if (!_stackTop.groupItemsLeft!.decrease()) {
      if (!_currentEntry.item.nextOnComplete) {
        _execHalted = true;
        if (!forceExec) return false;
      }
      if (_currIndex + 1 < _instructions.length) {
        _currIndex++;
      } else {
        _masterGroup.groupItemsLeft!.reset();
        _masterGroup.repetitionsLeft.reset();
        _currIndex = 0;
      }
      _resolve();
      return true;
    }
    _stackTop.groupItemsLeft!.reset();

    if (!_stackTop.repetitionsLeft.decrease()) {
      _currIndex = _execStack.isNotEmpty ? _execStack.last + 1 : 0;
      return true;
    }

    _stackTop.repetitionsLeft.reset();
    _execStack.removeLast();

    _stackTop.groupItemsLeft!.decrease();
    return tick();
  }

  void skip() {
    _execHalted = false;
    _forceExec = true;
    tick();
  }

  void _resolve() {
    switch (_currentEntry.item) {
      case _ExecutionGroupItem():
        _execStack.add(_currIndex);
        _currIndex++;
        _resolve();
      case _ExecutionItem():
        break;
    }
  }
}

List<_ExecutionEntry> _buildExecutionEntries(List<BaseSequenceItem> items) {
  final List<_ExecutionEntry> slots = [];

  for (final item in items) {
    switch (item) {
      case final SequenceItem item:
        slots.add(
          _ExecutionEntry.item(
            repetitionsLeft: _EntryPropCounter(item.repeatCount),
            item: _ExecutionItem(
              sItem: item,
              repeatCount: item.repeatCount,
              nextOnComplete: item.nextOnComplete,
              tag: item.tag,
            ),
          ),
        );
      case final GroupedSequenceItem group:
        final childSlots = _buildExecutionEntries(group.children);
        slots.add(
          _ExecutionEntry.group(
            repetitionsLeft: _EntryPropCounter(item.repeatCount),
            groupItemsLeft: _EntryPropCounter(group.children.length, true),
            item: _ExecutionGroupItem(
              repeatCount: item.repeatCount,
              nextOnComplete: item.nextOnComplete,
              tag: item.tag,
            ),
          ),
        );
        slots.addAll(childSlots);
    }
  }

  return slots;
}

class _ExecutionEntry {
  final _EntryPropCounter repetitionsLeft;
  final _EntryPropCounter? groupItemsLeft;
  final _ExecutionBaseItem item;

  _ExecutionEntry.item({
    required this.repetitionsLeft,
    required this.item,
  }) : groupItemsLeft = null;

  _ExecutionEntry.group({
    required this.repetitionsLeft,
    required this.groupItemsLeft,
    required this.item,
  });
}

class _EntryPropCounter {
  final int? count;

  // usually the counter will signal its end in the same cycle as it hits zero.
  // if this flag is set to true then another decrease call will be needed to be signaled as complete
  final bool signalUnderZero;
  int? _counter;

  _EntryPropCounter(this.count, [this.signalUnderZero = false])
      : _counter = count;

  // returns a bool to signal whether the counter is considered completed, like reaching the end of an iterable
  bool decrease() {
    if (_counter == null) return false;
    if (signalUnderZero && _counter! < 0) return false;
    _counter = _counter! - 1;

    return !signalUnderZero ? _counter! <= 0 : _counter! < 0;
  }

  void reset() => _counter = count;
}

sealed class BaseSequenceItem {
  /// The numbers of time to repeat this animation before being marked as complete.
  /// If this value is set to null the animation will loop until manually skipped.
  final int? repeatCount;

  /// If this flag is set to true any call to [AnimatedSequenceController.skip] will
  /// have the current item immediately skipping without waiting for it to complete
  /// before jumping ahead
  final bool skipMidAnimation;

  final bool nextOnComplete;
  final String? tag;

  const BaseSequenceItem({
    this.repeatCount = 1,
    this.skipMidAnimation = true,
    this.nextOnComplete = false,
    this.tag,
  });
}

class SequenceItem extends BaseSequenceItem {
  final AnimatedVectorData data;

  const SequenceItem(
    this.data, {
    super.repeatCount,
    super.skipMidAnimation,
    super.nextOnComplete,
    super.tag,
  });
}

class GroupedSequenceItem extends BaseSequenceItem {
  final List<BaseSequenceItem> children;

  const GroupedSequenceItem({
    required this.children,
    super.repeatCount,
    super.skipMidAnimation,
    super.nextOnComplete,
    super.tag,
  });
}

sealed class _ExecutionBaseItem {
  final int? repeatCount;
  final bool nextOnComplete;
  final String? tag;

  const _ExecutionBaseItem({
    required this.repeatCount,
    required this.nextOnComplete,
    required this.tag,
  });
}

class _ExecutionItem extends _ExecutionBaseItem {
  final SequenceItem sItem;

  const _ExecutionItem({
    required this.sItem,
    required super.repeatCount,
    required super.nextOnComplete,
    required super.tag,
  });
}

class _ExecutionGroupItem extends _ExecutionBaseItem {
  const _ExecutionGroupItem({
    required super.repeatCount,
    required super.nextOnComplete,
    required super.tag,
  });
}
