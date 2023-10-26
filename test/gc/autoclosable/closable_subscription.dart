import 'dart:async';

import 'package:autoclose/autoclose.dart';
import 'package:test/test.dart';

import '../../test_utils/force_gc.dart';
import '../../test_utils/test_closer.dart';
import '../utils/indirectional_weak_ref_close.dart';

StreamController streamController = StreamController.broadcast();
Stream stream = streamController.stream;

void updateStream() {
  unawaited(streamController.close());
  streamController = StreamController.broadcast();
  stream = streamController.stream;
}

final List<WeakReference> refsThatShouldBeCleared = [];

class SubscriptionTestCloser extends TestCloser {
  late WeakReference subcription;
  SubscriptionTestCloser();

  // method to just catch reference on `this`
  void doAnything(dynamic any) {}

  void init(Stream stream) {
    subcription = WeakReference(stream.listen(doAnything)..closeWith(this));
  }
}

@pragma('vm:never-inline')
WeakReference<SubscriptionTestCloser> createAndInit({required bool andClose}) {
  // function used to not hold the hard link to closer
  final closer = SubscriptionTestCloser();
  closer.init(stream);
  if (andClose) {
    closer.close();
  }
  return WeakReference(closer);
}

void testClosableSubscription() {
  group('ClosableSubscription', () {
    test('GC cleanes weak reference which not holded by anyone', () async {
      final closerWeakRef = WeakReference(SubscriptionTestCloser());
      await forceGC();
      expect(streamController.hasListener, isFalse);
      expect(streamController.isClosed, isFalse);
      expect(closerWeakRef.target, isNull);
    });
    test('subcription keep reference to SubscriptionTestCloser', () async {
      final closerWeakRef = createAndInit(andClose: false);

      // let's check the adequacy of our test: the reference to our closer object
      // should not be cleared, as it was captured by the subscription
      // which expect to call **this**.doAnything() when event come to stream (actually never)
      await forceGC();
      expect(streamController.hasListener, isTrue);
      expect(closerWeakRef.target, isNotNull);

      // clear before next test
      updateStream();
      await forceGC();
      expect(streamController.hasListener, isFalse);
      expect(closerWeakRef.target, isNotNull);

      // just check my observation how dart GC works:
      // closer.target?.close(); // <-- uncomment will cause keeping reference by ... whatever ... compiler optimizations
      indirectionalWeakRefClose(closerWeakRef);
      await forceGC();
      expect(closerWeakRef.target, isNull);
    });

    test('closer.close remove all references by subcription', () async {
      final closerWeakRef = createAndInit(andClose: true);

      await forceGC();
      expect(streamController.hasListener, isFalse);
      expect(closerWeakRef.target, isNull);
    });
  });
}
