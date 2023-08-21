import 'dart:developer';
import 'dart:isolate';
import 'package:vm_service/vm_service_io.dart';

Future<void> forceGC() async {
  final serverUri = (await Service.getInfo()).serverUri;

  if (serverUri == null) {
    print('Please run the application with the --observe parameter!');
    return;
  }

  final isolateId = Service.getIsolateID(Isolate.current)!;
  final vmService = await vmServiceConnectUri(_toWebSocket(serverUri));
  await vmService.getAllocationProfile(isolateId, gc: true);
}

List<String> _cleanupPathSegments(Uri uri) {
  final pathSegments = <String>[];
  if (uri.pathSegments.isNotEmpty) {
    pathSegments.addAll(uri.pathSegments.where(
      (s) => s.isNotEmpty,
    ));
  }
  return pathSegments;
}

String _toWebSocket(Uri uri) {
  final pathSegments = _cleanupPathSegments(uri);
  pathSegments.add('ws');
  return uri.replace(scheme: 'ws', pathSegments: pathSegments).toString();
}
