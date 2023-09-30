import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/subautoclosable/subautoclosable.dart';

/// contains collection of AutoClosable instances
/// and handle their close with its own lifecycle period
abstract class Closer {
  void addClosable(AutoClosable closable);
  void addSubClosable(SubAutoClosable closable);
  void onClose();
}
