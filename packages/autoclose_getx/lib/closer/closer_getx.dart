import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:get/get.dart';

mixin CloserGetx on DisposableInterface implements HasCloser {
  @override
  final closer = GeneralCloser();

  @override
  void onClose() {
    closer.onClose();
    super.onClose();
  }
}
