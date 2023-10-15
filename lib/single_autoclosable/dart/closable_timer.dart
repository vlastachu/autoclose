import 'dart:async';

import 'package:autoclose/closer/closer.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:autoclose/single_autoclosable/single_autoclosable.dart';

class _ClosableTimer extends SingleAutoClosable<Timer> {
  _ClosableTimer(super.closable, super.onClose);

  @override
  void close() {
    return closable.cancel();
  }

  @override
  bool? get isClosed => !closable.isActive;
}

/// An extension on the [Timer] class that allows you to manage its lifecycle
/// with a [HasCloser]'s Closer. This extension simplifies the process of adding
/// a [Timer] to a [Closer] while hiding the SingleAutoClosable implementation details.
extension TimerClose on Timer {
  /// Associates the [Timer] with the [Closer] context. You can
  /// provide an optional [onClose] callback function to define custom actions
  /// to be performed when the [Timer] is closed.
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
    hasCloser.closer.addClosable(_ClosableTimer(this, onClose));
  }
}
