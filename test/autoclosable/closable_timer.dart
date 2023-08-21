
import 'dart:async';

import 'package:autoclose/autoclosable/dart/closable_timer.dart';
import 'package:autoclose/test_utils/test_closer.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<Timer>()])
import 'closable_timer.mocks.dart';

void testClosableTimer() {
  group('ClosableTimer', () {
    test('closer.close calls `cancel`', () async {
      final closer = TestCloser();
      final timer = MockTimer();
      when(timer.isActive).thenReturn(true);
      
      timer.closeWith(closer);
      closer.close();
      verify(timer.cancel()).called(1);
    });
    test('closer.close doesn\'t call `cancel` on closed timer', () async {
      final closer = TestCloser();
      final timer = MockTimer();
      when(timer.isActive).thenReturn(false);
      
      timer.closeWith(closer);
      closer.close();
      verifyNever(timer.cancel());
    });
    test('multiple closer.close calls `cancel` once', () async {
      final closer1 = TestCloser();
      final closer2 = TestCloser();
      final timer = MockTimer();
      when(timer.isActive).thenReturn(true);
      
      timer.closeWith(closer1);
      timer.closeWith(closer2);
      closer1.close();
      closer2.close();
      verify(timer.cancel()).called(1);
    });
  });
}