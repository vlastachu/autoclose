import 'dart:async';

import 'package:autoclose/single_autoclosable/autoclosable.dart';
import 'package:autoclose/closer/has_closer.dart';

class ClosableSubscription extends SingleAutoClosable<StreamSubscription> {
  ClosableSubscription(super.closable, super.onClose);

  @override
  Future<void> close() {
    return closable.cancel();
  }

  @override
  bool? get isClosed => null;
}

extension SubscriptionClose on StreamSubscription {
  void closeWith(HasCloser hasCloser, {void Function()? doOnClose}) {
    hasCloser.closer.addClosable(ClosableSubscription(this, doOnClose));
  }
}
