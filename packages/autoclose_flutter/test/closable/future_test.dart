// ignore_for_file: avoid_print

import 'package:autoclose/autoclose.dart';
import 'package:autoclose_flutter/closer/closer_widget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidget extends StatefulWidget {
  final TextEditingController? controller;
  const TestWidget({super.key, this.controller});

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget>
    with CloserWidgetState<TestWidget> {
  @override
  void initState() {
    super.initState();
    longCall().closeWith(this);
  }

  Future<void> longCall() async {
    print('start delay');
    await Future.delayed(const Duration(seconds: 2));
    print('complete delay');
    setState(() {});
  }

  @override
  void dispose() {
    print('disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TextField(controller: widget.controller),
      ),
    );
  }
}

void main() {
  group('Future', () {
    testWidgets('but gracefully handled by `closeWith`', (widgetTester) async {
      // TODO test shows future closable behavior but doesn't actually test anything
      await widgetTester.runAsync(() async {
        const widget = TestWidget();
        await widgetTester.pumpWidget(widget);
        await widgetTester.pumpWidget(Container());
        await Future.delayed(const Duration(seconds: 4));
        print('complete test');
      });
    });
  });
}
