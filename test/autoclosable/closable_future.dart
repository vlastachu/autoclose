import 'dart:async';

import 'package:autoclose/autoclose.dart';
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
      Future<void> future() async {
        await Future.delayed(const Duration(milliseconds: 1)).closeWith(closer);
        mocked.someMethod();
      }

      unawaited(future());

      await untilCalled(mocked.someMethod());
      verify(mocked.someMethod()).called(1);
      expect(closer.close, returnsNormally);
    });
    test('code after closed future doesnt executes', () async {
      final closer = TestCloser();
      final mocked = MockSomeClass();
      Future<void> future() async {
        await Future.delayed(const Duration(milliseconds: 1)).closeWith(closer);
        mocked.someMethod();
      }

      future();
      closer.close();
      await Future.delayed(const Duration(milliseconds: 100));
      verifyNever(mocked.someMethod());
    });
    // BAD well it is possibly a bad behavior
    // probably need to add isClosed flag to closer and immidiately close all new closables.
    // On the other hand, this case is not expected: The library is designed in such a way that
    // closer creates it's own closables inside of own lifecycle
    test('calling close before future execution doesn\'t affects', () async {
      final closer = TestCloser();
      final mocked = MockSomeClass();
      Future<void> future() async {
        await Future.delayed(const Duration(milliseconds: 1)).closeWith(closer);
        mocked.someMethod();
      }

      closer.close();
      await future();
      verify(mocked.someMethod()).called(1);
    });

    test('doOnClose will not be called if future completes normally', () async {
      final closer = TestCloser();
      bool completed = false;
      bool doOnCloseCalled = false;
      Future<void> future() async {
        await Future.delayed(const Duration(milliseconds: 1)).closeWith(closer, doOnClose: () {
          doOnCloseCalled = true;
        },);
        completed = true;
      }
      await future();
      expect(completed, isTrue);
      expect(doOnCloseCalled, isFalse);
      expect(closer.close, returnsNormally);
      expect(completed, isTrue);
      expect(doOnCloseCalled, isFalse);
    });
    test('doOnClose will be called if future is cancelled by closer', () async {
      final closer = TestCloser();
      bool completed = false;
      bool doOnCloseCalled = false;
      Future<void> future() async {
        await Future.delayed(const Duration(milliseconds: 1)).closeWith(closer, doOnClose: () {
          doOnCloseCalled = true;
        },);
        completed = true;
      }
      unawaited(future());
      expect(closer.close, returnsNormally);
      expect(completed, isFalse);
      expect(doOnCloseCalled, isFalse); // close is async function
      await Future.delayed(const Duration(milliseconds: 100));
      expect(completed, isFalse);
      expect(doOnCloseCalled, isTrue);
    });
  });
}
