import 'package:autoclose/test_utils/test_closer.dart';

@pragma('vm:never-inline')
void indirectionalWeakRefClose(WeakReference<TestCloser> closer) {
  closer.target?.close();
}
