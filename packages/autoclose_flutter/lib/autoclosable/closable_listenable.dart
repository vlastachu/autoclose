import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:flutter/foundation.dart';

class ClosableListenable extends AutoClosable<Listenable> {
  final dynamic listener;
  ClosableListenable(super.closable, super.onClose, this.listener);

  @override
  void close() {
    return closable.removeListener(listener);
  }

  @override
  bool? get isClosed => null;
}

extension SubscriptionClose on Listenable {
  void addListenerWithCloser(HasCloser hasCloser, void Function() listener,
      {void Function()? doOnClose}) {
    addListener(listener);
    hasCloser.closer.addClosable(ClosableListenable(this, doOnClose, listener));
  }
}
