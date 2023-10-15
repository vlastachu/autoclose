import 'dart:async';

import 'package:async/async.dart';
import 'package:autoclose/single_autoclosable/autoclosable.dart';
import 'package:autoclose/closer/closer.dart';
import 'package:autoclose/closer/has_closer.dart';

class _ClosableFuture<T> extends SingleAutoClosable<Future<T>> {
  final CancelableOperation<T> cancelableOperation;

  _ClosableFuture(Future<T> future, {void Function()? doOnClose})
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

/// An extension on the [Future] class that allows you to 
/// manage its lifecycle with a [HasCloser]'s Closer.
/// This extension simplifies the process of adding
/// a [Future] to a [Closer] while hiding the SingleAutoClosable implementation details.
extension FutureClose<T> on Future<T> {
  /// Associates the [Future] with a [Closer] and adds it for management. You can
  /// provide an optional [doOnClose] callback function to define custom actions
  /// to be performed when the [Future] is closed.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// myFuture.closeWith(hasCloser, doOnClose: () {
  ///   // Custom actions to be performed when the [Future] is closed.
  /// });
  /// ```
  ///
  /// The [closeWith] method returns the original [Future] value, allowing you
  /// to continue using the [Future] after associating it with the [Closer].
  /// 
  /// See also:
  /// package:autoclose/test_gc/autoclosable/closable_future.dart#testClosableFuture
  /// test case shows how it works (it is cancels from outside)
  Future<T> closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    final closable = _ClosableFuture(this, doOnClose: doOnClose);
    hasCloser.closer.addClosable(closable);
    return closable.cancelableOperation.value;
  }
}
