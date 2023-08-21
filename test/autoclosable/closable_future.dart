import 'dart:async';

import 'package:autoclose/autoclosable/dart/closable_future.dart';
import 'package:autoclose/test_utils/test_closer.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<SomeClass>()])
import 'closable_future.mocks.dart';

class SomeClass {
  void someMethod() {}
}

void testClosableFuture() {
  group('ClosableFuture', () {
    test('closer close normally if future already done', () async {
      final closer = TestCloser();
      final mocked = MockSomeClass();
      future() async {
        await Future.delayed(Duration(milliseconds: 1)).closeWith(closer);
        mocked.someMethod();
      }

      future();

      await untilCalled(mocked.someMethod());
      verify(mocked.someMethod()).called(1);
      expect(() {
        closer.close();
      }, returnsNormally);
    });
    test('code after closed future doesnt executes', () async {
      final closer = TestCloser();
      final mocked = MockSomeClass();
      future() async {
        await Future.delayed(Duration(milliseconds: 1)).closeWith(closer);
        mocked.someMethod();
      }

      future();
      closer.close();
      // TODO bad design of test
      await Future.delayed(Duration(milliseconds: 100));
      verifyNever(mocked.someMethod());
    });
    // TODO well it is possibly a bad behavior
    // probably need to add isClosed flag to closer and immidiately close all new closables.
    // On the other hand, this case is not expected: The library is designed in such a way that
    // closer creates it's own closables inside of own lifecycle
    test('calling close before future execution doesn\'t affects', () async {
      final closer = TestCloser();
      final mocked = MockSomeClass();
      future() async {
        await Future.delayed(Duration(milliseconds: 1)).closeWith(closer);
        mocked.someMethod();
      }

      closer.close();
      future();
      // TODO bad design of test
      await Future.delayed(Duration(milliseconds: 100));
      verify(mocked.someMethod()).called(1);
    });
  });
}
