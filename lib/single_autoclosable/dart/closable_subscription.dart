import 'dart:async';

import 'package:autoclose/closer/closer.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:autoclose/single_autoclosable/single_autoclosable.dart';

class _ClosableSubscription extends SingleAutoClosable<StreamSubscription> {
  _ClosableSubscription(super.closable, super.onClose);

  @override
  Future<void> close() {
    return closable.cancel();
  }

  @override
  bool? get isClosed => null;
}

/// An extension on the [StreamSubscription] class that allows you to manage its lifecycle
/// with a [HasCloser]'s Closer. This extension simplifies the process of adding
/// a [StreamSubscription] to a [Closer] while hiding the SingleAutoClosable implementation details.
extension SubscriptionClose on StreamSubscription {
  /// Associates the [StreamSubscription] with the [Closer] context. You can
  /// provide an optional [onClose] callback function to define custom actions
  /// to be performed when the [StreamSubscription] is closed.
  /// 
  /// Example usage:
  ///
  /// ```dart
  /// void initState() {
  ///   super.initState();
  ///   someStream.listen(processEventsData).closeWith(this);
  /// }
  /// ```
  void closeWith(HasCloser hasCloser, {void Function()? onClose}) {
    hasCloser.closer.addClosable(_ClosableSubscription(this, onClose));
  }
}
