import 'dart:async';

import 'package:autoclose/autoclose.dart';
import 'package:autoclose_flutter/autoclose_flutter.dart';
import 'package:autoclose_flutter/subautoclosable/closable_listenable.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with CloserWidgetState {
  int _counter = 0;

  @override
  void initState() {
    const stream = Stream.empty();
    ScrollController().addListenerWithCloser(this, () {});
    // final bom = stream.listen((event) {}); //.closeWith(this);
    // final vom = bom;
    //// 1expect_lint: stream_subscription_assignment_unhandled
    // final vv = StreamSubscription();
    // final vv1 = vv ?? StreamSubscription()
    // ..closeWith(this);
    stream.listen((event) {}).closeWith(this);

    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
