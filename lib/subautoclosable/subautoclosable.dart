import 'package:autoclose/generic_autoclosable/generic_autoclosable.dart';

/// represents pair of entities which should handled together to close them.
/// Good exaple is Listenable class from Flutter:
/// `listenable.addListener(listener);` has corresponding closing method `listenable.removeListener(listener);`
/// With autoclosable lib it rewrites to `listenable.addListenerWithCloser(closer, listener);`
abstract class SubAutoClosable<Closable, SubClosable>
    extends AutoClosable {
  final Closable closable;
  final SubClosable subClosable;
  @override
  final void Function()? onClose;

  SubAutoClosable(this.closable, this.subClosable, this.onClose);

  @override
  bool operator ==(dynamic other) =>
      other is SubAutoClosable &&
      closable == other.closable &&
      subClosable == other.subClosable;

  @override
  int get hashCode => Object.hash(closable, subClosable);
}
