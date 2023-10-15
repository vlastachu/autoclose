import 'package:autoclose/generic_autoclosable/generic_autoclosable.dart';
import 'package:meta/meta.dart';

/// Represents entities which able to (and should be) close
/// This class descendant designed for the simple case of a single entity
@immutable
abstract class AutoClosable<T> extends GenericAutoClosable {
  /// The closable entity that this [AutoClosable] instance is associated with.
  final T closable;

  @override
  final void Function()? onClose;

  /// Creates an [AutoClosable] instance to manage the termination and cleanup
  /// of a specified closable entity.
  ///
  /// The [closable] parameter represents the entity that should be closed when
  /// necessary, such as a stream subscription or a resource. The [onClose]
  /// parameter is an optional callback function that can be used to define
  /// custom actions to be performed when the [closable] entity is closed.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// AutoClosable(controller, () {
  ///   // Custom actions to be performed when the controller is closed.
  /// });
  /// ```
  AutoClosable(this.closable, this.onClose);

  @override
  bool operator ==(dynamic other) =>
      other is AutoClosable && closable == other.closable;

  @override
  int get hashCode => closable.hashCode;
}
