import 'package:autoclose/autoclose.dart';
import 'package:flutter/material.dart';

class ClosableInkFeature extends SingleAutoClosable<InkFeature> {
  ClosableInkFeature(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => null;
}

extension InkFeatureClose on InkFeature {
  void closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    hasCloser.closer.addClosable(ClosableInkFeature(this, onClose));
  }
}
