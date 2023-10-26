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

/// pure autoclose package has no [Closer] implementations so we have to create
/// own to test closables
class TestCloser extends _AbstractTestCloser with _CloserAbstractTestCloser {}
