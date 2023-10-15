import 'dart:async';

/// Represents entities which able to (and should be) close
/// 'Close' means different cases of termination: cancel, unsubscribe, dispose etc
/// 
/// See also:
/// - [package:autoclose/closer/closer#Closer.addClosable]: Method to add closable entity to handle its 
/// closing when [package:autoclose/closer/closer#Closer.onClose] called
abstract class AutoClosable {
  /// A callback function that can be provided to perform custom actions when
  /// the associated entity is closed. This function is executed *after* [close]
  /// is called. If [close] is Future, then it will be awaited and called onClose.
  ///
  /// Example:
  ///
  /// ```dart
  /// SingleAutoClosable(controller, () {
  ///   // Custom actions to be performed when the controller is closed.
  /// });
  /// ```
  void Function()? get onClose;

  /// Closes the current instance.
  /// The returned future completes when the instance has been closed.
  FutureOr<void> close();

  /// Whether the object is already closed.
  /// `null` means you can't extract such information.
  /// For example: Flutter's ChangeNotifier doesn't tell you if he was disposed
  bool? get isClosed;
}
