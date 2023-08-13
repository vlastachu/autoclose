import 'dart:async';

import 'package:autoclose/autoclosable/dart/closable_subscription.dart';
import 'package:autoclose/autoclosable/dart/closable_timer.dart';
import 'package:leak_tracker/leak_tracker.dart';
import 'package:test/test.dart';

import '../utils/test_closer.dart';

late WeakReference globalWeakReference;

class TimerTestCloser extends TestCloser {
  late WeakReference<Timer> timerWeakRef;
  TimerTestCloser();

  // method to just catch reference on `this`
  void doAnything() {}

  Timer init() {
    return Timer(Duration(hours: 1), doAnything)..closeWith(this);
  }

  static WeakReference<TimerTestCloser> createAndInit() {
    // function used to not hold the hard link to closer
    final closer = TimerTestCloser();
    closer.timerWeakRef = WeakReference(closer.init());
    closer.close();
    return WeakReference(closer);
  }
}

void testClosableTimer() {
  group('ClosableTimer', () {
    test('closer.close remove all references by subcription', () async {
      final closerWeakRef = TimerTestCloser.createAndInit();
      globalWeakReference = closerWeakRef;
      // expect(streamController.hasListener, isTrue);

      // let's check the adequacy of our test: the reference to our closук object
      // should not be cleared, as it was captured by the subscription
      // which expect to call **this**.doAnything() when event come to stream (actually never)
      // await forceGC();
      // expect(closerWeakRef.target, isNotNull);

      closerWeakRef.target?.close();
      await forceGC();
      // expect(streamController.hasListener, isFalse);
      // expect(streamController.isClosed, isFalse);
      // expect(closerWeakRef.target, isNull);
      if (closerWeakRef.target != null) {
        print(await formattedRetainingPath(closerWeakRef.target!.timerWeakRef));
      }
    });
    test('', () async {
      await forceGC();
      if (globalWeakReference.target != null) {
        print(1);
      }
    });
  });
}
