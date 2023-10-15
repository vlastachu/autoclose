import 'package:autoclose/single_autoclosable/dart/do_on_close.dart';

import 'closer.dart';

/// to have ability to extend on GeneralCloser
/// because dart mixins is not extendable
abstract class HasCloser {
  Closer get closer;
}

extension HasCloserExt on HasCloser {
  void doOnClose(void Function() onClose) {
    closer.addClosable(DoOnClose(onClose));
  }
}
