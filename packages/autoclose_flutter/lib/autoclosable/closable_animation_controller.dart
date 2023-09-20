import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:flutter/widgets.dart';

class ClosableAnimationController extends AutoClosable<AnimationController> {
  ClosableAnimationController(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => closable.toStringDetails().contains('DISPOSED');
}

extension AnimationControllerClose on AnimationController {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableAnimationController(this, doOnClose));
  }
}
