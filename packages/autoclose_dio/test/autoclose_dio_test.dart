import 'dart:async';

import 'package:autoclose/closer/general_closer.dart';
import 'package:autoclose/closer/has_closer.dart';
import 'package:autoclose_dio/autoclose_dio.dart';
import 'package:test/test.dart';

class TestHasCloser implements HasCloser {
  @override
  final closer = GeneralCloser();

  void close() {
    closer.onClose();
  }
}

void main() {
  group('HasCloserDioCancelToken', () {
    test('cancels request when HasCloser is closed', () async {
      final hasCloser = TestHasCloser();
      final token = hasCloser.getCancelToken();

      expect(token.isCancelled, isFalse);

      hasCloser.close();

      expect(token.isCancelled, isTrue);
    });

    test('cancels both requests in one HasCloser', () async {
      final hasCloser = TestHasCloser();
      final token1 = hasCloser.getCancelToken();
      final token2 = hasCloser.getCancelToken();

      expect(identical(token1, token2), isTrue);

      hasCloser.close();

      expect(token1.isCancelled, isTrue);
      expect(token2.isCancelled, isTrue);
    });

    test('calls both onClose callbacks', () async {
      final hasCloser = TestHasCloser();
      int onClose1 = 0;
      int onClose2 = 0;

      hasCloser.getCancelToken(
        onClose: () {
          onClose1++;
        },
      );
      hasCloser.getCancelToken(
        onClose: () {
          onClose2++;
        },
      );

      hasCloser.close();

      // Wait for microtasks
      await Future.delayed(Duration.zero);

      expect(onClose1, 1);
      expect(onClose2, 1);
    });
  });
}
