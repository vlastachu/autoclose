import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:flutter/widgets.dart';

class ClosableBoxPainter extends SingleAutoClosable<BoxPainter> {
  ClosableBoxPainter(super.closable, super.onClose);

  @override
  void close() {
    return closable.dispose();
  }

  @override
  bool? get isClosed => null;
}

extension BoxPainterClose on BoxPainter {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableBoxPainter(this, doOnClose));
  }
}
