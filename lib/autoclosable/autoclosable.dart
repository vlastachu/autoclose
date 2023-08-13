import 'dart:async';

/// Represents entities which able to (and should be) close
/// 'Close' means different cases of termination: cancel, unsubscribe, dispose etc
abstract class AutoClosable<T> {
  final T closable;
  final void Function()? onClose;

  AutoClosable(this.closable, this.onClose);

  /// Closes the current instance.
  /// The returned future completes when the instance has been closed.
  FutureOr<void> close();

  /// Whether the object is already closed.
  /// null means you can't extract such information
  /// For example: Flutter's ChangeNotifier doesn't tell you if he was disposed
  bool? get isClosed;

  @override
  bool operator ==(dynamic other) =>
      other is AutoClosable && closable == other.closable;

  @override
  int get hashCode => closable.hashCode;
}