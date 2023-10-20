import 'package:autoclose/autoclose.dart';
import 'package:flutter/widgets.dart';

class ClosableAnimationController
    extends SingleAutoClosable<AnimationController> {
  ClosableAnimationController(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => closable.toStringDetails().contains('DISPOSED');
}

extension AnimationControllerClose on AnimationController {
  void closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    hasCloser.closer.addClosable(ClosableAnimationController(this, onClose));
  }
}
