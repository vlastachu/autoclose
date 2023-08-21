
import 'dart:async';

import 'package:autoclose/autoclosable/dart/closable_subscription.dart';
import 'package:autoclose/test_utils/test_closer.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<StreamSubscription>()])
import 'closable_subscription.mocks.dart';

void testClosableSubscription() {
  group('ClosableSubscription', () {
    test('closer.close calls `cancel`', () async {
      final closer = TestCloser();
      final subscription = MockStreamSubscription();
      
      subscription.closeWith(closer);
      closer.close();
      verify(subscription.cancel()).called(1);
    });
    test('calling `cancel` twice doesn\'t produce exceptions', () async {
      expect(() {
        final closer = TestCloser();
        final subscription = Stream<int>.periodic(const Duration(seconds: 1), (x) => x).listen((event) { });
        
        subscription.closeWith(closer);
        subscription.cancel();
        closer.close();
      }, returnsNormally);
    });
    test('multiple closer.close calls `cancel` once', () async {
      final closer1 = TestCloser();
      final closer2 = TestCloser();
      final subscription = MockStreamSubscription();
      
      subscription.closeWith(closer1);
      subscription.closeWith(closer2);
      closer1.close();
      closer2.close();
      verify(subscription.cancel()).called(1);
    });
  });
}