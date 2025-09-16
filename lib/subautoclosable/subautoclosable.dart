import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:meta/meta.dart';

/// represents pair of entities which should handled together to close them.
/// Good exaple is Listenable class from Flutter:
/// `listenable.addListener(listener);` has corresponding closing method `listenable.removeListener(listener);`
/// With autoclosable lib it rewrites to `listenable.addListenerWithCloser(closer, listener);`
@immutable
abstract class SubAutoClosable<Closable, SubClosable> extends AutoClosable {
  /// `listenable.addListener(listener);` -> `closable.addListener(subClosable);`
  final Closable closable;

  /// `listenable.addListener(listener);` -> `closable.addListener(subClosable);`
  final SubClosable subClosable;
  @override
  final void Function()? onClose;

  /// Creates a new instance of [SubAutoClosable] with the specified
  /// [closable] and [subClosable] entities, allowing them to be managed
  /// together for closure. You can also provide an optional [onClose]
  /// callback function to define custom actions to be executed when the
  /// [SubAutoClosable] is closed.
  SubAutoClosable(this.closable, this.subClosable, this.onClose);

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) =>
      other is SubAutoClosable &&
      closable == other.closable &&
      subClosable == other.subClosable;

  @override
  int get hashCode => Object.hash(closable, subClosable);
}
