import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
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
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableChangeNotifier(this, doOnClose));
  }
}
