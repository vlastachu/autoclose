import 'package:autoclose/autoclosable/dart/closable_future.dart';
import 'package:autoclose/test_utils/test_closer.dart';
import 'package:leak_tracker/leak_tracker.dart';
import 'package:test/test.dart';

final List<WeakReference> refsThatShouldBeCleared = [];

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

  static WeakReference<FutureTestCloser> createAndInit() {
    // function used to not hold the hard link to closer
    final closer = FutureTestCloser();
    closer.futureWeakRef = WeakReference(closer.init());
    closer.close();
    return WeakReference(closer);
  }
}

void testClosableFuture() {
  group('ClosableFuture', () {
    test('closer.close remove all references by subcription', () async {
      final closerWeakRef = FutureTestCloser.createAndInit();
      refsThatShouldBeCleared.add(closerWeakRef);

      closerWeakRef.target?.close();
      await forceGC();
      expect(closerWeakRef.target?.futureWeakRef.target, isNull);
    });
    test('closer ref was closed after previos test closure closed', () async {
      await forceGC();
      expect(refsThatShouldBeCleared, isNotEmpty);
      for (final ref in refsThatShouldBeCleared) {
        expect(ref.target, isNull);
      }
    });
  });
}
