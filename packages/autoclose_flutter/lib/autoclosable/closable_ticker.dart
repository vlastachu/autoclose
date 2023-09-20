import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:flutter/scheduler.dart';

class ClosableTicker extends AutoClosable<Ticker> {
  ClosableTicker(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => null;
}

extension TickerClose on Ticker {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableTicker(this, doOnClose));
  }
}
