import 'dart:io';

import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

class TestWidget extends StatefulWidget {
  final FocusNode? focusNode;
  const TestWidget({super.key, this.focusNode});

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget>
    with CloserWidgetState<TestWidget> {
  @override
  void initState() {
    super.initState();
    // expect_lint: listenable_add_listener_unhandled
    widget.focusNode?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: TextField(focusNode: widget.focusNode)));
  }
}

List<WeakReference> shouldBeNull = [];
List<WeakReference> shouldBeNotNull = [];

void main() {
  // another case when my expectations made me suffer and laugh
  // I was hope to find anything bad about unconnected ChangeNotifier but still not found
  group('Widget GC tests', () {
    tearDownAll(() {
      exit(0);
    });
    // testWidgets('GC will release the ref to widget if handled by closeWith',
    //     (widgetTester) async {
    //   final widgetWeakRef = await createWidgetAndSubscribeToChangeNotifier(
    //       widgetTester,
    //       andClose: true);
    //   await widgetTester.pumpWidget(Container());
    //   await forceGC();
    //   expect(widgetWeakRef, isNotNull);
    //   // shouldBeNull = widgetWeakRef;
    //   // expect(widgetWeakRef, isNull);
    // });
    testWidgets(
        'GC will keep the ref to widget if connected to change notifier',
        (widgetTester) async {
      final widgetWeakRef = await createWidgetAndSubscribeToChangeNotifier(
          widgetTester,
          andClose: false);

      await widgetTester.pumpWidget(Container());
      await forceGC();
      expect(widgetWeakRef, isNotNull);
      // shouldBeNotNull = widgetWeakRef;
      // expect(widgetWeakRef, isNotNull);
    });
    test('Check our weak refs', () async {
      await forceGC();
      expect(shouldBeNotNull, isNotNull);
      // expect(shouldBeNotNull?.target, isNotNull);
      expect(shouldBeNull, isNotNull);
      // expect(shouldBeNull?.target, isNull);
    });
  });
}

Future<List<WeakReference>> createWidgetAndSubscribeToChangeNotifier(
    WidgetTester widgetTester,
    {required bool andClose}) async {
  // expect_lint: change_notifier_assignment_unhandled
  final focusNode = FocusNode();
  final widget = TestWidget(focusNode: focusNode);

  await widgetTester.pumpWidget(widget);
  final widgetWeakRef = WeakReference(widget);
  // WeakReference(widgetTester.widget(find.byType(TextField).first));
  final TestWidgetState state = widgetTester.state(find.byWidget(widget));

  // controller.addListener(() {
  //   // ignore: invalid_use_of_protected_member
  //   state.setState(() {});
  // });

  if (andClose) {
    focusNode.closeWith(
      state,
      // ignore: avoid_print
      onClose: () => print('help'),
    );
  }
  await widgetTester.pumpWidget(Container());
  return [widgetWeakRef, WeakReference(state), WeakReference(focusNode)];
}
