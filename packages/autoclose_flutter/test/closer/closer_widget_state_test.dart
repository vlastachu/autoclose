import 'package:autoclose/autoclose.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_widget.dart';

void main() {
  group('CloserWidgetState', () {
    testWidgets('CloserWidgetState disposes correctly', (widgetTester) async {
      bool onCloseCalled = false;

      const widget = TestWidget();
      await widgetTester.pumpWidget(widget);
      final TestWidgetState state = widgetTester.state(find.byWidget(widget));

      state.doOnClose(() {
        onCloseCalled = true;
      });

      // Verify that onCloseCalled is initially false
      expect(onCloseCalled, false);

      // Dispose the widget
      await widgetTester.pumpWidget(Container());

      // Verify that onCloseCalled is now true, indicating that onClose was called
      expect(onCloseCalled, true);
    });
  });
}
