import 'dart:async';

import 'package:async/async.dart';
import 'package:autoclose/closer/closer.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:autoclose/single_autoclosable/single_autoclosable.dart';

class _ClosableFuture<T> extends SingleAutoClosable<Future<T>> {
  final CancelableOperation<T> cancelableOperation;

  _ClosableFuture(Future<T> future, {void Function()? onClose})
      : cancelableOperation = CancelableOperation<T>.fromFuture(future),
        super(future, onClose);

  @override
  Future<void> close() {
    return cancelableOperation.cancel();
  }

  @override
  bool? get isClosed =>
      cancelableOperation.isCompleted || cancelableOperation.isCanceled;
}

/// An extension on the [Future] class that allows you to manage its lifecycle
/// with a [HasCloser]'s Closer. This extension simplifies the process of adding
/// a [Future] to a [Closer] while hiding the SingleAutoClosable implementation details.
extension FutureClose<T> on Future<T> {
  /// Associates the [Future] with the [Closer] context. You can
  /// provide an optional [onClose] callback function to define custom actions
  /// to be performed when the [Future] is closed.
  ///
  /// **Important note:** unlike other `closeWith` methods, this method has a return value.
  /// The [closeWith] method returns the original [Future] value, allowing you
  /// to continue using the [Future] after associating it with the [Closer].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// InkWell(onTap: () async {
  ///   final data = await fetchLongRequest().closeWith(this, onClose: () {
  ///     // Optional custom actions to be performed when the [Future] is closed *by closer*
  ///     // If future completes successfully by themself, then handler will not be called
  ///   });
  ///   // these lines will not be executed if widget leave widget's tree
  ///   processData(data);
  /// })
  /// ```
  ///
  /// See also:
  /// [package:autoclose/test_gc/autoclosable/closable_future.dart#testClosableFuture]
  /// test case shows how it works (it is cancels from outside)
  Future<T> closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    final closable = _ClosableFuture(this, onClose: onClose);
    hasCloser.closer.addClosable(closable);
    return closable.cancelableOperation.value;
  }
}
