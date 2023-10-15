import 'package:autoclose/closer/has_closer.dart';
import 'package:autoclose/single_autoclosable/single_autoclosable.dart';

class _DoOnClose extends SingleAutoClosable<void Function()> {
  _DoOnClose(void Function() f) : super(f, null);

  @override
  void close() {
    closable();
  }

  @override
  bool? get isClosed => null;
}


/// Adds custom actions to be executed when the associated `Closer` is closed.
extension HasCloserDoOnCloseExt on HasCloser {
  /// Adds custom actions to be executed when the associated `Closer` is closed.
  void doOnClose(void Function() onClose) {
    closer.addClosable(_DoOnClose(onClose));
  }
}
