import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:flutter/material.dart';

class ClosableDecorationImagePainter
    extends AutoClosable<DecorationImagePainter> {
  ClosableDecorationImagePainter(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => closable.toString().contains('image: null');
}

extension DecorationImagePainterClose on DecorationImagePainter {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer
        .addClosable(ClosableDecorationImagePainter(this, doOnClose));
  }
}
