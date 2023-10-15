import 'closer.dart';

/// to have ability to extend on GeneralCloser
/// because dart mixins is not extendable
abstract class HasCloser {
  /// Gets access to the associated `Closer` instance for managing closable
  /// objects.
  Closer get closer;
}
