import 'dart:async';
import 'package:autoclose/autoclose.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'do_on_close.mocks.dart';

@GenerateNiceMocks([MockSpec<Timer>()])
void testDoOnClose() {
  group('DoOnClose', () {
    test('closer.close executes onClose body', () async {
      final closer = TestCloser();
      final timer = MockTimer();

      closer.doOnClose(() {
        timer.cancel();
        timer.cancel();
      });

      closer.close();
      verify(timer.cancel()).called(2);
    });
  });
}
