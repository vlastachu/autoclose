import 'dart:async';

import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:bloc/bloc.dart';

class ClosableBloc extends AutoClosable<Closable> {
  ClosableBloc(super.closable, super.onClose);

  @override
  FutureOr<void> close() {
    return closable.close();
  }

  @override
  bool? get isClosed => closable.isClosed;
}

extension BlocClose on Closable {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableBloc(this, doOnClose));
  }
}
