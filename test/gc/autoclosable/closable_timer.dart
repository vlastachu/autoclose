import 'dart:async';

import 'package:autoclose/autoclosable/dart/closable_timer.dart';
import 'package:autoclose/test_utils/force_gc.dart';
import 'package:autoclose/test_utils/test_closer.dart';
import 'package:test/test.dart';

import 'closable_subscription.dart';

final List<WeakReference> refsThatShouldBeCleared = [];

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
    return WeakReference(closer);
  }
}

void testClosableTimer() {
  group('ClosableTimer', () {
    test('timer keeps ref', () async {
      final closerWeakRef = TimerTestCloser.createAndInit();
      refsThatShouldBeCleared.add(closerWeakRef);

      await forceGC();
      expect(closerWeakRef.target, isNotNull);
    });
    test('closer.close cancels timer', () async {
      final closerWeakRef = TimerTestCloser.createAndInit();
      refsThatShouldBeCleared.add(closerWeakRef);

      indirectionalWeakRefClose(closerWeakRef);
      await forceGC();
      expect(closerWeakRef.target, isNull);
    });
  });
}
