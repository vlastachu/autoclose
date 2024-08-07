import 'package:autoclose/autoclose.dart';
import 'package:flutter/widgets.dart';

mixin CloserChangeNotifier on ChangeNotifier implements HasCloser {
  @override
  final closer = GeneralCloser();

  @override
  void dispose() {
    closer.onClose();
    super.dispose();
  }
}
