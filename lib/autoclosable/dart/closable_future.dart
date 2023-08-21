import 'dart:async';

import 'package:async/async.dart';
import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';

class ClosableFuture<T> extends AutoClosable<Future<T>> {
  final CancelableOperation<T> cancelableOperation;

  ClosableFuture(Future<T> future, {void Function()? doOnClose})
      : cancelableOperation = CancelableOperation<T>.fromFuture(future),
        super(future, doOnClose);

  @override
  Future<void> close() {
    return cancelableOperation.cancel();
  }

  @override
  bool? get isClosed =>
      cancelableOperation.isCompleted || cancelableOperation.isCanceled;
}

extension FutureClose<T> on Future<T> {
  Future<T> closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    final closable = ClosableFuture(this, doOnClose: doOnClose);
    hasCloser.closer.addClosable(closable);
    return closable.cancelableOperation.value;
  }
}
