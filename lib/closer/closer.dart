import 'package:autoclose/autoclosable/autoclosable.dart';

/// contains collection of AutoClosable instances 
/// and handle their close with its own lifecycle period
abstract class Closer {
  void addClosable(AutoClosable closable);
}
