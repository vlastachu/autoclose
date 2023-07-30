import 'package:autoclose/autoclose.dart';
import 'package:bloc/bloc.dart';

mixin CloserBloc<T> on BlocBase<T> implements HasCloser {
  @override
  final closer = GeneralCloser();

  @override
  Future<void> close() {
    closer.onClose();
    return super.close();
  }
}
ß