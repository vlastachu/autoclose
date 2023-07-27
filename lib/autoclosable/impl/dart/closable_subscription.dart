import 'dart:async';

import 'package:autoclose/autoclosable/autoclosable.dart';
import 'package:autoclose/closer/closer.dart';

class ClosableSubscription implements AutoClosable {
  final StreamSubscription subscription;

  ClosableSubscription(this.subscription);

  @override
  Future<void> close() {
    return subscription.cancel();
  }
  
  @override
  bool? get isClosed => null;
}

extension SubscriptionClose on StreamSubscription {
  void closeWith(Closer closer) {
    closer.addClosable(ClosableSubscription(this));
  }
}
