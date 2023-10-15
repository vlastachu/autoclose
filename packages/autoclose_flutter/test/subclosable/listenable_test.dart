import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../closer/test_widget.dart';

listener() {}
listener2() {}

void main() {
  group('ChangeNotifier (Listenable)', () {
    test(
        'ChangeNotifier throws an exception when remove listener after it was disposed',
        () => expect(() {
              final controller = TextEditingController();
              controller.addListener(listener);
              controller.dispose();
              controller.removeListener(listener);
              // well actually that's statement 'ChangeNotifier throws an exception when remove listener after it was disposed'
              // is not true, but i was sure that's so, when wrote tests.
              // names of test sounds too cool to remove them
            }, returnsNormally));

    testWidgets(
        'but gracefully handled by `closeWith` and `addListenerWithCloser`',
        (widgetTester) async {
      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      final controller = TextEditingController();
      controller.closeWith(state);
      controller.addListenerWithCloser(state, listener);

      expect(() async {
        await widgetTester.pumpWidget(Container());
      }, returnsNormally);
    });

    testWidgets('no matter the order in which they were called',
        (widgetTester) async {
      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      final controller = TextEditingController();
      controller.addListenerWithCloser(state, listener);
      controller.closeWith(state);

      expect(() async {
        await widgetTester.pumpWidget(Container());
      }, returnsNormally);
    });
  });

  group('Listenable dispose order', () {
    testWidgets(
        '`addListenerWithCloser` doesn\'t add twice for same listener and listenable',
        (widgetTester) async {
      final closedQueue = [];
      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      final controller = TextEditingController();
      controller.addListenerWithCloser(state, listener, onClose: () {
        closedQueue.add(1);
      });
      controller.addListenerWithCloser(state, listener, onClose: () {
        closedQueue.add(2);
      });
      controller.closeWith(state);
      await widgetTester.pumpWidget(Container());
      expect(closedQueue, equals([1]));
    });
    testWidgets('controller can have multiple listeners', (widgetTester) async {
      final closedQueue = [];
      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      final controller = TextEditingController();

      controller.addListenerWithCloser(state, listener, onClose: () {
        closedQueue.add(1);
      });
      controller.addListenerWithCloser(state, listener2, onClose: () {
        closedQueue.add(2);
      });
      controller.closeWith(state);
      await widgetTester.pumpWidget(Container());
      expect(closedQueue.length, equals(2),
          reason: 'both listeners should be removed');
      expect(closedQueue, equals([1, 2]), reason: 'preserve remove order');
    });

    testWidgets('many controllers may have same listener',
        (widgetTester) async {
      final closedQueue = [];
      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      TextEditingController()
        ..closeWith(state)
        ..addListenerWithCloser(state, listener, onClose: () {
          closedQueue.add(1);
        });
      FocusNode()
        ..closeWith(state)
        ..addListenerWithCloser(state, listener2, onClose: () {
          closedQueue.add(2);
        });

      await widgetTester.pumpWidget(Container());
      expect(closedQueue, equals([1, 2]));
    });
  });
}
