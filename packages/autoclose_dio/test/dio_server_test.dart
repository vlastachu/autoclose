import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:autoclose_dio/autoclose_dio.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

import 'autoclose_dio_test.dart';

void main() {
  late HttpServer server;
  late Uri serverUrl;

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    serverUrl = Uri.parse('http://${server.address.host}:${server.port}');

    server.listen((HttpRequest req) async {
      req.response.statusCode = 200;
      req.response.headers.contentType = ContentType.text;
      for (var i = 0; i < 10000; i++) {
        req.response.write('chunk $i\n');
        await req.response.flush();
        await Future.delayed(const Duration(microseconds: 100));
      }
      await req.response.close();
    });
  });

  tearDown(() async {
    await server.close(force: true);
  });

  test('dio request is actually cancelled', () async {
    final dio = Dio();
    final hasCloser = TestHasCloser();

    final future = dio.getUri(
      serverUrl,
      cancelToken: hasCloser.getCancelToken(),
      options: Options(responseType: ResponseType.stream),
    );

    Future.delayed(const Duration(milliseconds: 100), hasCloser.close);

    try {
      final response = await future;
      await for (final chunk in utf8.decoder
          // ignore: avoid_dynamic_calls
          .bind(response.data.stream)
          .transform(const LineSplitter())) {
        // ignore: avoid_print
        print('received: $chunk');
      }
      fail('Request should have been cancelled');
    } on DioException catch (e) {
      expect(e.type, DioExceptionType.cancel);
    }
  });
}
