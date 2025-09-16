import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:meta/meta.dart';

/// Represents entities which able to (and should be) close
/// This class descendant designed for the simple case of a single entity
@immutable
abstract class SingleAutoClosable<T> extends AutoClosable {
  /// The closable entity that this [SingleAutoClosable] instance is associated with.
  final T closable;

  @override
  final void Function()? onClose;

  /// Creates an [SingleAutoClosable] instance to manage the termination and cleanup
  /// of a specified closable entity.
  ///
  /// The [closable] parameter represents the entity that should be closed when
  /// necessary, such as a stream subscription or a resource. The [onClose]
  /// parameter is an optional callback function that can be used to define
  /// custom actions to be performed when the [closable] entity is closed.
  SingleAutoClosable(this.closable, this.onClose);

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) =>
      other is SingleAutoClosable && closable == other.closable;

  @override
  int get hashCode => closable.hashCode;
}
