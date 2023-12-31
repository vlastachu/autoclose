import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const TestWidget());
}

class StatelessTest extends StatelessWidget {
  const StatelessTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Stateless');
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget> {
  bool isClean = false;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    const Stream.empty().listen((event) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: isClean
                ? Container()
                : Column(
                    children: [
                      TextField(
                          controller: TextEditingController(text: 'some')),
                      ValueListenableBuilder(
                          valueListenable: ValueNotifier(3),
                          builder: (BuildContext context, int counterValue,
                              Widget? child) {
                            return Text("Counter: $counterValue");
                          }),
                      const StatelessTest(),
                      InkWell(
                        onTap: () => setState(() {
                          isClean = true;
                        }),
                        child: const Text('clean'),
                      )
                    ],
                  )));
  }
}
