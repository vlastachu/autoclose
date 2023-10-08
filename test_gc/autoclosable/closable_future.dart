import 'package:autoclose/autoclosable/dart/closable_future.dart';
import 'package:autoclose/test_utils/force_gc.dart';
import 'package:autoclose/test_utils/test_closer.dart';
import 'package:test/test.dart';

class FutureTestCloser extends TestCloser {
  late WeakReference<Future<dynamic>> futureWeakRef;
  FutureTestCloser();

  // method to just catch reference on `this`
  void doAnything() {}

  Future<dynamic> init() async {
    final someValue = await Future.delayed(Duration(hours: 1)).closeWith(this);
    doAnything();
    return someValue;
  }
}

@pragma('vm:never-inline')
WeakReference<FutureTestCloser> createAndInit({required bool andClose}) {
  // function used to not hold the hard link to closer
  final closer = FutureTestCloser();
  closer.futureWeakRef = WeakReference(closer.init());
  if (andClose) {
    closer.close();
  }
  return WeakReference(closer);
}

void testClosableFuture() {
  group('ClosableFuture', () {
    test('waiting for the future prevents you from releasing the ref',
        () async {
      final closerWeakRef = createAndInit(andClose: false);
      await forceGC();
      expect(closerWeakRef.target, isNotNull);
    });
    test('closer.close cancels future waiting', () async {
      final closerWeakRef = createAndInit(andClose: true);

      // if you uncomment this line then closerWeakRef.target will be not null
      // closerWeakRef.target?.close();
      // that's brings up a lot of different thoughts
      await forceGC();
      expect(closerWeakRef.target, isNull);
    });
  });
}
