import 'dart:async';

import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/closer.dart';
import 'package:autoclose/single_autoclosable/single_autoclosable.dart';
import 'package:autoclose/subautoclosable/subautoclosable.dart';

/// A class that implements the common [Closer] logic and provides the capability
/// to manage collections of [SingleAutoClosable] and [SubAutoClosable] instances.
///
/// Other [Closer] should only implement `HasCloser` by this class instance,
/// and call `onClose` when the time comes.
///
/// It facilitates the controlled closure of these instances in accordance with
/// its own lifecycle. [SingleAutoClosable] instances are given priority during
/// closure operations.
class GeneralCloser implements Closer {
  /// [SingleAutoClosable] instances which already attached to their Closer's
  static final Set<SingleAutoClosable> attachedAutoclosables = {};

  /// [SubAutoClosable] instances which already attached to their Closer's
  static final Set<SubAutoClosable> attachedSubAutoclosables = {};

  /// simple closables
  final List<SingleAutoClosable> closables = [];

  /// subClosables list have higher priority
  final List<SubAutoClosable> subClosables = [];

  @override
  void addClosable(SingleAutoClosable closable) {
    if (!attachedAutoclosables.contains(closable)) {
      attachedAutoclosables.add(closable);
      closables.add(closable);
    }
  }

  @override
  void addSubClosable(SubAutoClosable subClosable) {
    if (!attachedSubAutoclosables.contains(subClosable)) {
      attachedSubAutoclosables.add(subClosable);
      subClosables.add(subClosable);
    }
  }

  @override
  void onClose() {
    clearClosables(subClosables, attachedSubAutoclosables);
    clearClosables(closables, attachedAutoclosables);
  }

  /// Clears and closes the provided collection of closables and removes them
  /// from the attached set. This method is used during the `onClose` operation.
  void clearClosables(
    List<AutoClosable> closables,
    Set<AutoClosable> attachedSet,
  ) {
    for (final closable in closables) {
      if (closable.isClosed != true) {
        unawaited(_callCloser(closable));
      }
      final wasRemoved = attachedSet.remove(closable);
      assert(wasRemoved, 'check if entity wasn`t removed twice');
    }
    closables.clear();
  }

  Future<void> _callCloser(AutoClosable closable) async {
    await closable.close();
    final onClose = closable.onClose;
    if (onClose != null) {
      onClose();
    }
  }
}
