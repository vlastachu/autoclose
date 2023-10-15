import 'package:autoclose/single_autoclosable/dart/closable_future.dart';
import 'package:autoclose/test_utils/force_gc.dart';
import 'package:autoclose/test_utils/test_closer.dart';
import 'package:test/test.dart';

class FutureTestCloser extends TestCloser {
  FutureTestCloser();

  // method to just catch reference on `this`
  void doAnything() {}

  Future<dynamic> init(Future<dynamic> future) async {
    final someValue = await future.closeWith(this);
    doAnything();
    return someValue;
  }
}

@pragma('vm:never-inline')
(
  WeakReference<FutureTestCloser>,
  WeakReference<Future<dynamic>>,
  WeakReference<Future<dynamic>>
) createAndInit({required bool andClose}) {
  // function used to not hold the hard link to closer
  final outerFuture = Future.delayed(const Duration(hours: 1));
  final closer = FutureTestCloser();
  // ignore: discarded_futures
  final closerFuture = closer.init(outerFuture);
  if (andClose) {
    closer.close();
  }
  return (
    WeakReference(closer),
    WeakReference(closerFuture),
    WeakReference(outerFuture)
  );
}

void testClosableFuture() {
  group('ClosableFuture', () {
    test('waiting for the future prevents you from releasing the ref',
        () async {
      final (closerWeakRef, closerFutureWeakRef, outerFutureWeakRef) =
          createAndInit(andClose: false);
      await forceGC();
      expect(closerWeakRef.target, isNotNull);
      expect(closerFutureWeakRef.target, isNotNull);
      expect(outerFutureWeakRef.target, isNotNull);
    });
    test('closer.close cancels future waiting', () async {
      final (closerWeakRef, closerFutureWeakRef, outerFutureWeakRef) =
          createAndInit(andClose: true);

      // if you uncomment this line then closerWeakRef.target will be not null
      // closerWeakRef.target?.close();
      // that's brings up a lot of different thoughts

      await forceGC();
      expect(closerWeakRef.target, isNull);
      expect(closerFutureWeakRef.target, isNull);
      // we are not going to (and actually can not) cancel future from outside
      expect(outerFutureWeakRef.target, isNotNull);
    });
  });
}
