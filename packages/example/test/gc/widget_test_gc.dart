import 'dart:io';

import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

class TestWidget extends StatefulWidget {
  final TextEditingController? controller;
  const TestWidget({super.key, this.controller});

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget>
    with CloserWidgetState<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: TextField(controller: widget.controller)));
  }
}

WeakReference? shouldBeNull;
WeakReference? shouldBeNotNull;

void main() {
  group('Widget GC tests', () {
    tearDownAll(() {
      exit(0);
    });
    testWidgets('GC will release the reg to widget if handled by closeWith',
        (widgetTester) async {
      final widgetWeakRef = await createWidgetAndSubscribeToChangeNotifier(
          widgetTester,
          andClose: true);
          shouldBeNull = widgetWeakRef;
      // expect(widgetWeakRef, isNull);
    });
    testWidgets(
        'GC will keep the ref to widget if connected to change notifier',
        (widgetTester) async {
      final widgetWeakRef = await createWidgetAndSubscribeToChangeNotifier(
          widgetTester,
          andClose: false);
          shouldBeNotNull = widgetWeakRef;
      // expect(widgetWeakRef, isNotNull);
    });
    test('Check our weak refs', () async {
      await forceGC();
      expect(shouldBeNotNull, isNotNull);
      expect(shouldBeNotNull?.target, isNotNull);
      expect(shouldBeNull, isNotNull);
      expect(shouldBeNull?.target, isNull);
    });
  });
}

Future<WeakReference<Widget>> createWidgetAndSubscribeToChangeNotifier(
    WidgetTester widgetTester,
    {required bool andClose}) async {
  // expect_lint: change_notifier_assignment_unhandled
  final controller = TextEditingController();
  final widget = TestWidget(controller: controller);
  
  await widgetTester.pumpWidget(widget);
  final widgetWeakRef = WeakReference(widgetTester.widget(find.byType(TextField).first));
  final TestWidgetState state = widgetTester.state(find.byWidget(widget));

  // controller.addListener(() {
  //   // ignore: invalid_use_of_protected_member
  //   state.setState(() {});
  // });

  if (andClose) {
    controller.closeWith(state, doOnClose: () => print('pomogite'),);
  }
  await widgetTester.pumpWidget(Container());
  return widgetWeakRef;
}
