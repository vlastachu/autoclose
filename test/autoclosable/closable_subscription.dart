import 'dart:async';

import 'package:autoclose/autoclosable/dart/closable_subscription.dart';
import 'package:autoclose/autoclose.dart';
import 'package:test/test.dart';
import 'package:leak_tracker/leak_tracker.dart';

import '../utils/test_closer.dart';

StreamController streamController = StreamController.broadcast();
Stream stream = streamController.stream;
final List<WeakReference> refsThatShouldBeCleared = [];

class SubscriptionTestCloser extends TestCloser {
  late WeakReference subcription;
  SubscriptionTestCloser();

  // method to just catch reference on `this`
  void doAnything(dynamic any) {}

  void init(Stream stream) {
    subcription = WeakReference( stream.listen(doAnything)..closeWith(this));
  }

  static WeakReference<SubscriptionTestCloser> createAndInit(Stream stream) {
    // function used to not hold the hard link to closer
    final closer = SubscriptionTestCloser();
    closer.init(stream);
    return WeakReference(closer);
  }
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

    test('closer.close remove all references by subcription', () async {
      final closerWeakRef = SubscriptionTestCloser.createAndInit(stream);
      
      // let's check the adequacy of our test: the reference to our closer object
      // should not be cleared, as it was captured by the subscription
      // which expect to call **this**.doAnything() when event come to stream (actually never)
      await forceGC();
      expect(streamController.hasListener, isTrue);
      expect(closerWeakRef.target, isNotNull);
      expect(closerWeakRef.target?.subcription.target, isNotNull);

      closerWeakRef.target?.close();
      await forceGC();
      expect(streamController.hasListener, isFalse);
      expect(streamController.isClosed, isFalse);
      expect(closerWeakRef.target?.subcription.target, isNull);
      refsThatShouldBeCleared.add(closerWeakRef);
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
