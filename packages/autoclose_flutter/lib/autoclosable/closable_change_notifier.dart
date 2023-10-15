import 'package:autoclose/autoclose.dart';
import 'package:flutter/foundation.dart';

class ClosableChangeNotifier extends SingleAutoClosable<ChangeNotifier> {
  ClosableChangeNotifier(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => null;
}

extension ChangeNotifierClose on ChangeNotifier {
  void closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    hasCloser.closer.addClosable(ClosableChangeNotifier(this, onClose));
  }
}
