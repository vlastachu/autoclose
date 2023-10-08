import 'package:autoclose/test_utils/force_gc.dart';
import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../closer/test_widget.dart';

void main() {
  testWidgets('GC will keep link to widget if connected to change notifier', (widgetTester) async {
    final widgetWeakRef = await createWidgetAndSubscribeToChangeNotifier(widgetTester, andClose: false);
    expect(widgetWeakRef, isNotNull);
  });
}

Future<WeakReference<Widget>> createWidgetAndSubscribeToChangeNotifier(
    WidgetTester widgetTester,
    {required bool andClose}) async {
  final controller = TextEditingController();
  final widget = TestWidget(controller: controller);
  final widgetWeakRef = WeakReference(widget);
  await widgetTester.pumpWidget(widget);
  final TestWidgetState state = widgetTester.state(find.byWidget(widget));

  // controller.addListener(() {
  //   // ignore: invalid_use_of_protected_member
  //   state.setState(() {});
  // });

  if (andClose) {
    controller.closeWith(state);
  }
  await widgetTester.pumpWidget(Container());
  await forceGC();
  return widgetWeakRef;
}
