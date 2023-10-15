import 'package:autoclose/autoclose.dart';
import 'package:flutter/scheduler.dart';

class ClosableTicker extends SingleAutoClosable<Ticker> {
  ClosableTicker(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => !closable.isActive;
}

extension TickerClose on Ticker {
  void closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    hasCloser.closer.addClosable(ClosableTicker(this, onClose));
  }
}
