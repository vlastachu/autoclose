import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:flutter/gestures.dart';

class ClosableGestureRecognizer extends SingleAutoClosable<GestureRecognizer> {
  ClosableGestureRecognizer(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => null;
}

extension GestureRecognizerClose on GestureRecognizer {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableGestureRecognizer(this, doOnClose));
  }
}
