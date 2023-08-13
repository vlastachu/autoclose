import 'package:autoclose/autoclose.dart';

abstract class _AbstractTestCloser {
  void close() {}
}

mixin _CloserAbstractTestCloser on _AbstractTestCloser implements HasCloser {
  @override
  final closer = GeneralCloser();

  @override
  void close() {
    closer.onClose();
    super.close();
  }
}

class TestCloser extends _AbstractTestCloser with _CloserAbstractTestCloser {}
