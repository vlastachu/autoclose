import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/closer.dart';
import 'package:autoclose/generic_autoclosable/generic_autoclosable.dart';
import 'package:autoclose/subautoclosable/subautoclosable.dart';

class GeneralCloser implements Closer {
  /// AutoClosable instances which already attached to their Closer's
  static final Set<AutoClosable> attachedAutoclosables = {};
  static final Set<SubAutoClosable> attachedSubAutoclosables = {};

  final List<AutoClosable> closables = [];

  /// subClosables list have higher priority
  final List<SubAutoClosable> subClosables = [];

  @override
  void addClosable(AutoClosable closable) {
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

  void genericClearClosables(List<GenericAutoClosable> genericClosables,
      Set<GenericAutoClosable> genericAttachedSet) {
    for (final closable in genericClosables) {
      if (closable.isClosed != true) {
        _callCloser(closable);
      }
      final wasRemoved = genericAttachedSet.remove(closable);
      assert(wasRemoved);
    }
    genericClosables.clear();
  }

  void _callCloser(GenericAutoClosable closable) async {
    await closable.close();
    final onClose = closable.onClose;
    if (onClose != null) {
      onClose();
    }
  }
}
