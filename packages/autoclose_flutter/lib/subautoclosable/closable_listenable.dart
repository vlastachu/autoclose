import 'package:autoclose/closer/has_closer.dart';
import 'package:autoclose/subautoclosable/subautoclosable.dart';
import 'package:flutter/foundation.dart';

class ClosableListenable extends SubAutoClosable<Listenable, VoidCallback> {
  ClosableListenable(super.closable, super.subClosable, super.onClose);

  @override
  void close() {
    return closable.removeListener(subClosable);
  }

  @override
  bool? get isClosed => null;
}

extension ListenableClose on Listenable {
  void addListenerWithCloser(HasCloser hasCloser, VoidCallback listener,
      {void Function()? onClose}) {
    addListener(listener);
    hasCloser.closer
        .addSubClosable(ClosableListenable(this, listener, onClose));
  }
}
