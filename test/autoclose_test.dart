import 'autoclosable/closable_future.dart';
import 'autoclosable/closable_subscription.dart';
import 'autoclosable/closable_timer.dart';
import 'autoclosable/do_on_close.dart';

void main() async {
  testClosableTimer();
  testDoOnClose();
  testClosableSubscription();
  testClosableFuture();
}
