import 'package:autoclose/autoclose.dart';
import 'package:flutter/widgets.dart';

mixin CloserWidgetState<T extends StatefulWidget> on State<T> implements HasCloser {
  @override
  final closer = GeneralCloser();

  @override
  void dispose() {
    closer.onClose();
    super.dispose();
  }
}
