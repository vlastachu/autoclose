import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/closer.dart';

class GeneralCloser implements Closer {
  /// AutoClosable instances which already attached to their Closer's
  // TODO check that instance shares between packages
  static final Set<AutoClosable> attachedAutoclosables = {};
  final List<AutoClosable> closables = [];

  @override
  void addClosable(AutoClosable closable) {
    if (!attachedAutoclosables.contains(closable)) {
      attachedAutoclosables.add(closable);
      closables.add(closable);
    }
  }

  @override
  void onClose() {
    for (final closable in closables) {
      if (closable.isClosed != true) {
        _callCloser(closable);
      }
      final wasRemoved = attachedAutoclosables.remove(closable);
      assert(!wasRemoved);
    }
    closables.clear();
  }

  void _callCloser(AutoClosable closable) async {
    await closable.close();
    final onClose = closable.onClose;
    if (onClose != null) {
      onClose();
    }
  }
}
