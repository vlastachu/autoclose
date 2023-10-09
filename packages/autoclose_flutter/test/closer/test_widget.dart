import 'package:autoclose_flutter/closer/closer_widget_state.dart';
import 'package:flutter/material.dart';

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
    return TextField(controller: widget.controller);
  }
}
