import 'package:autoclose/autoclosable/autoclosable.dart';

class DoOnClose extends SingleAutoClosable<void Function()> {
  DoOnClose(void Function() f) : super(f, null);

  @override
  void close() {
    closable();
  }

  @override
  bool? get isClosed => null;
}
