import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
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
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableInkFeature(this, doOnClose));
  }
}
