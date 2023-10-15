import 'package:autoclose/closer/has_closer.dart';
import 'package:autoclose/subautoclosable/subautoclosable.dart';
import 'package:flutter/widgets.dart';

class ClosableWidgetsBinding
    extends SubAutoClosable<WidgetsBinding, WidgetsBindingObserver> {
  ClosableWidgetsBinding(super.closable, super.subClosable, super.onClose);

  @override
  void close() {
    closable.removeObserver(subClosable);
  }

  @override
  bool? get isClosed => null;
}

extension WidgetsBindingClose on WidgetsBinding {
  void addObserverWithCloser(
      HasCloser hasCloser, WidgetsBindingObserver observer,
      {void Function()? onClose}) {
    addObserver(observer);
    hasCloser.closer
        .addSubClosable(ClosableWidgetsBinding(this, observer, onClose));
  }
}
