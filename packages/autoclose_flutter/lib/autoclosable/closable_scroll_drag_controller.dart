import 'package:autoclose/autoclose.dart';
import 'package:flutter/widgets.dart';

class ClosableScrollDragController
    extends SingleAutoClosable<ScrollDragController> {
  ClosableScrollDragController(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => closable.lastDetails == null;
}

extension ScrollDragControllerClose on ScrollDragController {
  void closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    hasCloser.closer.addClosable(ClosableScrollDragController(this, onClose));
  }
}
