import 'dart:developer';

// thanks to polina-c https://github.com/dart-lang/leak_tracker/blob/fa29ce4e02d63acc2439f97d94c881b3a8ba9760/pkgs/leak_tracker/lib/src/leak_tracking/helpers.dart#L29
// forceGC implementation from parent package doesn't work in 'flutter run _' environment because of WebSocketException

Future<void> forceGC() async {
  final int barrier = reachabilityBarrier;

  final List<List<int>> storage = <List<int>>[];

  void allocateMemory() {
    storage.add(List.generate(30000, (n) => n));
    if (storage.length > 100) {
      storage.removeAt(0);
    }
  }

  while (reachabilityBarrier < barrier + 2) {
    await Future<void>.delayed(Duration.zero);
    allocateMemory();
  }
}
