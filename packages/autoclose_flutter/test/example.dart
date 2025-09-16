import 'package:autoclose_flutter/autoclose_flutter.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Page { scrollListenerPage, justPage }

class _MyHomePageState extends State<MyHomePage> with CloserWidgetState {
  Page page = Page.scrollListenerPage;
  late final ScrollController _controller = ScrollController()..closeWith(this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Autoclose'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: Page.scrollListenerPage,
                  icon: Icon(Icons.cake_outlined),
                  label: Text('scroll listener'),
                ),
                ButtonSegment(
                  value: Page.justPage,
                  icon: Icon(Icons.breakfast_dining),
                  label: Text('just page'),
                ),
              ],
              selected: {page},
              onSelectionChanged: (p0) => setState(() {
                page = p0.first;
              }),
            ),
            const SizedBox(height: 16),
            if (page == Page.scrollListenerPage)
              ScrollListener(
                scrollController: _controller,
              )
            else
              const JustPage(),
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                controller: _controller,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Index: $index'),
                    visualDensity: VisualDensity.comfortable,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JustPage extends StatelessWidget {
  const JustPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Whatever',
    );
  }
}

class ScrollListener extends StatefulWidget {
  final ScrollController scrollController;
  const ScrollListener({super.key, required this.scrollController});

  @override
  State<ScrollListener> createState() => _ScrollListenerState();
}

class _ScrollListenerState extends State<ScrollListener>
    with CloserWidgetState {
  int offset = 0;

  @override
  void initState() {
    widget.scrollController.addListenerWithCloser(
      this,
      () => setState(() => offset = widget.scrollController.offset.round()),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'offset: $offset',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
