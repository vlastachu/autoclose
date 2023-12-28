import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

class TestWidgetState extends State<TestWidget>
    with CloserWidgetState<TestWidget> {
  bool isClean = false;

  @override
  void initState() {
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

void main() {
  testWidgets('Test if views disappear when isClean is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TestWidget());

    // final textField = find.byType(TextField);
    // final valueListenableBuilder = find.byType(ValueListenableBuilder);
    // final statelessTest = find.byType(StatelessTest);
    final cleanButton = find.text('clean');

    // Verify that the widgets are initially present
    // expect(textField, findsOneWidget);
    // expect(valueListenableBuilder, findsOneWidget);
    // expect(statelessTest, findsOneWidget);

    await tester.tap(cleanButton);
    await tester.pumpAndSettle();

    // Verify that the widgets have disappeared
    // expect(textField, findsNothing);
    // expect(valueListenableBuilder, findsNothing);
    // expect(statelessTest, findsNothing);
    expect(cleanButton, findsNothing);
  });
}
