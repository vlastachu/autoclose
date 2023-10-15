import 'package:autoclose/autoclose.dart';
import 'package:flutter/material.dart';

class ClosableDecorationImagePainter
    extends SingleAutoClosable<DecorationImagePainter> {
  ClosableDecorationImagePainter(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => closable.toString().contains('image: null');
}

extension DecorationImagePainterClose on DecorationImagePainter {
  void closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    hasCloser.closer
        .addClosable(ClosableDecorationImagePainter(this, onClose));
  }
}
