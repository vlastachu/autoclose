
import 'dart:async';

import 'package:autoclose/autoclosable/dart/closable_subscription.dart';
import 'package:autoclose/autoclose.dart';
import 'package:test/test.dart';
import 'package:leak_tracker/leak_tracker.dart';

// import '../utils/force_gc.dart';

class ZAZAZA {}

abstract class _AbstractTestCloser {
  void close() {}
}

mixin _CloserAbstractTestCloser on _AbstractTestCloser implements HasCloser {
  Closer? _closer = GeneralCloser();

  Closer get closer => _closer ?? GeneralCloser();

  @override
  void close() {
    _closer?.onClose();
    _closer = null;
    super.close();
  }
}

class TestCloser extends _AbstractTestCloser with _CloserAbstractTestCloser {}


class SubscriptionTestCloser extends TestCloser {
  final Stream stream;
  SubscriptionTestCloser(this.stream);

  // method to just catch reference on `this`
  void doAnything(dynamic any) {}

  void init() {
    final z = ZAZAZA();
    stream.listen((e) {
      doAnything(e);
      z.toString();
  }).closeWith(this);
  }
}

StreamController streamController = StreamController.broadcast();
Stream stream = streamController.stream;

WeakReference<SubscriptionTestCloser> createAndInit(Stream stream) {
  // function used to not hold the hard link to closer
  final closer = SubscriptionTestCloser(stream);
  closer.init();
  return WeakReference(closer);
}

void testClosableSubscription() {

  group('ClosableSubscription', () {
    // test('GC cleanes weak refernce which not holded by anyone', () async {
    //   final closerWeakRef = WeakReference(SubscriptionTestCloser(stream));
    //   await forceGC();
    //   expect(streamController.hasListener, isFalse);
    //   expect(streamController.isClosed, isFalse);
    //   expect(closerWeakRef.target, isNull);
    // });

    // test('GC not cleanes weak refernce which holded by stream subscription', () async {
    //   // let's check the adequacy of our test: the reference to our closук object 
    //   // should not be cleared, as it was captured by the subscription
    //   // which expect to call **this**.doAnything() when event come to stream (actually never)

    //   final closerWeakRef = WeakReference(createAndInit());
    //   await forceGC();
    //   expect(closerWeakRef.target, isNotNull);
    // });

    test('closer.close remove all references by subcription', () async {
      
      final closerWeakRef = createAndInit(stream);
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
      print(await formattedRetainingPath(closerWeakRef));
      print(formattedRetainingPath(closerWeakRef));
    });
  });
}