import 'dart:async';

import 'package:async/async.dart';
import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/closer.dart';

class ClosableFuture<T> implements AutoClosable {
  final CancelableOperation<T> cancelableOperation;

  ClosableFuture(Future<T> future)
      : cancelableOperation = CancelableOperation<T>.fromFuture(future);

  @override
  Future<void> close() {
    return cancelableOperation.cancel();
  }

  @override
  bool? get isClosed =>
      cancelableOperation.isCompleted || cancelableOperation.isCanceled;
}

extension FutureClose<T> on Future<T> {
  Future<T> closeWith(Closer closer) {
    final closable = ClosableFuture(this);
    closer.addClosable(closable);
    return closable.cancelableOperation.value;
  }
}
