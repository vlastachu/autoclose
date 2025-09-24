// ignore_for_file: discarded_futures

import 'dart:async';

import 'package:autoclose/closer/has_closer.dart';
import 'package:autoclose/single_autoclosable/single_autoclosable.dart';
import 'package:dio/dio.dart';

extension HasCloserDioCancelToken on HasCloser {
  /// Returns a shared CancelToken for this closer context.
  /// The token will be automatically cancelled when the closer is closed.
  CancelToken getCancelToken({void Function()? onClose}) {
    final existing = _tokenMap[this];
    if (existing != null) {
      if (onClose != null) {
        existing.whenCancel.then((_) => onClose());
      }
      return existing;
    }

    final token = CancelToken();
    closer.addClosable(
      _DioCancelTokenClosable(
        token,
        '$runtimeType$hashCode',
        onClose: onClose,
      ),
    );
    _tokenMap[this] = token;
    token.whenCancel.then((_) => _tokenMap.remove(this));
    return token;
  }
}

final Map<HasCloser, CancelToken> _tokenMap = {};

class _DioCancelTokenClosable extends SingleAutoClosable<CancelToken> {
  final String contextName;
  _DioCancelTokenClosable(
    CancelToken token,
    this.contextName, {
    void Function()? onClose,
  }) : super(token, null) {
    if (onClose != null) {
      token.whenCancel.then((_) => onClose());
    }
  }

  @override
  FutureOr<void> close() {
    closable.cancel(
      'Request cancelled by autoclose due to $contextName has been closed',
    );
  }

  @override
  bool? get isClosed => closable.isCancelled;
}
