import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../closer/test_widget.dart';

@GenerateNiceMocks([MockSpec<ChangeNotifier>()])
import 'change_notifier.mocks.dart';

void main() {
  group('ChangeNotifier (SingleAutoClosable)', () {
    test(
        'ChangeNotifier disposed twice throws an exception',
        () => expect(() {
              final controller = TextEditingController();
              controller.dispose();
              controller.dispose();
            }, throwsFlutterError));

    testWidgets('but gracefully handled by `closeWith`', (widgetTester) async {
      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      final controller = TextEditingController();
      controller.closeWith(state);
      controller.closeWith(state);

      expect(() async {
        // Dispose the widget
        await widgetTester.pumpWidget(Container());
      }, returnsNormally);
    });
    testWidgets('we can see on mock that dispose called once',
        (widgetTester) async {
      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      final controller = MockChangeNotifier();
      controller.closeWith(state);
      controller.closeWith(state);

      await widgetTester.pumpWidget(Container());
      verify(controller.dispose()).called(1);
    });
    testWidgets('but still throws error if we dispose from outside',
        (widgetTester) async {
      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      final controller = TextEditingController();
      controller.closeWith(state);

      // Dispose the widget
      await widgetTester.pumpWidget(Container());
      expect(() async {
        controller.dispose();
      }, throwsFlutterError);
    });
  });
}
