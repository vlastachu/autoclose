import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:flutter/material.dart';

class _ExampleState extends State<Example> with CloserWidgetState {
  late final controller = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    counterStream.listen((n) {
      controller.text = '$n';
    });
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
      );
}

const counterStream = Stream<int>.empty();
// final a = 1, b = counterStream.listen((n) {});

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}
