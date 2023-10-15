import 'package:autoclose/single_autoclosable/autoclosable.dart';
import 'package:autoclose/subautoclosable/subautoclosable.dart';

/// contains collection of SingleAutoClosable instances
/// and handle their close with its own lifecycle period
abstract class Closer {
  void addClosable(SingleAutoClosable closable);
  void addSubClosable(SubAutoClosable closable);
  void onClose();
}
