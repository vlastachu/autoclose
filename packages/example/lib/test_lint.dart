// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';

const counterStream = Stream<int>.empty();

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  // expect_lint: change_notifier_variable_declaration_list_unclosed
  late final controller = TextEditingController(text: '0');
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    // expect_lint: change_notifier_expression_unclosed
    FocusNode();
    // expect_lint: change_notifier_assignment_expression_unclosed
    focusNode = FocusNode();

    // expect_lint: stream_subscription_variable_declaration_list_unclosed
    final a = 1, b = counterStream.listen((n) {});

    // expect_lint: timer_variable_declaration_list_unclosed
    final a1 = Timer.periodic(Duration.zero, (timer) { });
    
    // expect_lint: stream_subscription_expression_unclosed
    counterStream.listen((n) {
      controller.text = '$n';
    });

    // expect_lint: listenable_add_listener_unclosed
    focusNode?.addListener(() { });
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
      );
}
