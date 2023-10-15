import 'dart:async';

import 'package:autoclose/autoclose.dart';
import 'package:bloc/bloc.dart';

class ClosableBloc extends SingleAutoClosable<Closable> {
  ClosableBloc(super.closable, super.onClose);

  @override
  FutureOr<void> close() {
    return closable.close();
  }

  @override
  bool? get isClosed => closable.isClosed;
}

extension BlocClose on Closable {
  void closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    hasCloser.closer.addClosable(ClosableBloc(this, onClose));
  }
}
