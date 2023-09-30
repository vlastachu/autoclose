import 'package:autoclose/generic_autoclosable/generic_autoclosable.dart';

/// Represents entities which able to (and should be) close
/// 'Close' means different cases of termination: cancel, unsubscribe, dispose etc
abstract class AutoClosable<T> extends GenericAutoClosable {
  final T closable;
  @override
  final void Function()? onClose;

  AutoClosable(this.closable, this.onClose);

  @override
  bool operator ==(dynamic other) =>
      other is AutoClosable && closable == other.closable;

  @override
  int get hashCode => closable.hashCode;
}
