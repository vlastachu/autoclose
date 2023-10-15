import 'dart:async';

import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';

class ClosableTimer extends SingleAutoClosable<Timer> {
  ClosableTimer(super.closable, super.onClose);

  @override
  void close() {
    return closable.cancel();
  }

  @override
  bool? get isClosed => !closable.isActive;
}

extension SubscriptionClose on Timer {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableTimer(this, doOnClose));
  }
}
