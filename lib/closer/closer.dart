import 'package:autoclose/single_autoclosable/single_autoclosable.dart';
import 'package:autoclose/subautoclosable/subautoclosable.dart';

/// Contains collection of SingleAutoClosable and SubAutoClosable instances
/// and handle their close with its own lifecycle period
abstract class Closer {
  /// Add [SingleAutoClosable] instance to that [Closer] to handle its destruction when [onClose] called
  void addClosable(SingleAutoClosable closable);

  /// Add [SubAutoClosable] instance to that [Closer] to handle its destruction when [onClose] called
  void addSubClosable(SubAutoClosable closable);

  /// Initiates the closure of all managed `SingleAutoClosable` and
  /// `SubAutoClosable` instances. The `onClose` operation handles the closure
  /// of these instances in accordance with the `Closer`'s own lifecycle.
  void onClose();
}
