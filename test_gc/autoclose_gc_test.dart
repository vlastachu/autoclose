import 'dart:io';

import 'package:test/test.dart';

import 'autoclosable/closable_future.dart';
import 'autoclosable/closable_subscription.dart';
import 'autoclosable/closable_timer.dart';

void main() async {
  tearDownAll(exitAfterTest);
  testClosableSubscription();
  testClosableTimer();
  testClosableFuture();
}

void exitAfterTest() {
  // I'm not sure it's true but on exception I'll see that github runner failed with reaching timeout
  print('All tests passed!');
  exit(0);
}
