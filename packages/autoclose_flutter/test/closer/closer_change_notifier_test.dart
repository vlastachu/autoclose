import 'package:autoclose/autoclose.dart';
import 'package:autoclose_flutter/closer/closer_change_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Flutter doc's suprisingly provides example where
// ChangeNotifier is mixin, so I must check this case too
class TestModel with ChangeNotifier, CloserChangeNotifier {
  Future<void> runNotification() async {
    await Future.delayed(Duration.zero);
    notifyListeners();
  }

  Future<void> runNotificationWithClose() async {
    await Future.delayed(Duration.zero).closeWith(this);
    notifyListeners();
  }
}

void main() {
  group('CloserChangeNotifier', () {
    test('CloserChangeNotifier disposes correctly', () async {
      final model = TestModel();
      var wasClosed = false;
      model.doOnClose(() => wasClosed = true);
      expect(wasClosed, false);
      model.dispose();
      expect(wasClosed, true);
    });
    test('runNotification works well without dispose', () async {
      final model = TestModel();
      final future = model.runNotification();
      await expectLater(future, completes);
    });
    test('runNotification should throw exception if disposed before completion',
        () async {
      final model = TestModel();
      final future = model.runNotification();
      // Dispose the model before the future completes
      model.dispose();
      await expectLater(future, throwsFlutterError);
    });
    test(
        'runNotificationWithClose should handle its future and abort the future (does not complete)',
        () async {
      final model = TestModel();
      final future = model.runNotificationWithClose();
      // Dispose the model before the future completes
      model.dispose();
      await expectLater(future, doesNotComplete);
    });
  });
}
