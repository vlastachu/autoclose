import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:flutter/widgets.dart';

class ClosableScrollDragController extends AutoClosable<ScrollDragController> {
  ClosableScrollDragController(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => closable.lastDetails == null;
}

extension ScrollDragControllerClose on ScrollDragController {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableScrollDragController(this, doOnClose));
  }
}
