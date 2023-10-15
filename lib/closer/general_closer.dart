import 'package:autoclose/single_autoclosable/autoclosable.dart';
import 'package:autoclose/closer/closer.dart';
import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/subautoclosable/subautoclosable.dart';

class GeneralCloser implements Closer {
  /// SingleAutoClosable instances which already attached to their Closer's
  static final Set<SingleAutoClosable> attachedAutoclosables = {};
  static final Set<SubAutoClosable> attachedSubAutoclosables = {};

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
    genericClearClosables(subClosables, attachedSubAutoclosables);
    genericClearClosables(closables, attachedAutoclosables);
  }

  void genericClearClosables(List<AutoClosable> genericClosables,
      Set<AutoClosable> genericAttachedSet) {
    for (final closable in genericClosables) {
      if (closable.isClosed != true) {
        _callCloser(closable);
      }
      final wasRemoved = genericAttachedSet.remove(closable);
      assert(wasRemoved);
    }
    genericClosables.clear();
  }

  void _callCloser(AutoClosable closable) async {
    await closable.close();
    final onClose = closable.onClose;
    if (onClose != null) {
      onClose();
    }
  }
}
