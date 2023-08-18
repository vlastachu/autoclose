import 'dart:async';

import 'package:autoclose/autoclosable/dart/closable_timer.dart';
import 'package:leak_tracker/leak_tracker.dart';
import 'package:test/test.dart';

import '../utils/test_closer.dart';

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
    closer.close();
    return WeakReference(closer);
  }
}

void testClosableTimer() {
  group('ClosableTimer', () {
    test('closer.close remove all references by subcription', () async {
      final closerWeakRef = TimerTestCloser.createAndInit();
      refsThatShouldBeCleared.add(closerWeakRef);

      closerWeakRef.target?.close();
      await forceGC();
      expect(closerWeakRef.target?.timerWeakRef.target, isNull);
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
