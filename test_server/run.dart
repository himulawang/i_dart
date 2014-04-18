import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:http_server/http_server.dart';
import 'package:route/server.dart';

import 'lib_test.dart';
import 'i_config/store.dart';
import 'i_config/orm.dart';

num startTimestamp;
num endTimestamp;

void main() {
  startTimestamp = new DateTime.now().millisecondsSinceEpoch;

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var buildPath = Platform.script.resolve('/home/ila/project/i_dart/test_client').toFilePath();
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
    var router = new Router(server);

    var virDir = new VirtualDirectory(buildPath);
    virDir.jailRoot = false;
    virDir.allowDirectoryListing = true;
    /*
    virDir.directoryHandler = (dir, request) {
      print(dir.path);
      var indexUrl = new Uri.file(dir.path).resolve('index.html');
      virDir.serveFile(new File(indexUrl.toFilePath()), request);
    };
    */

    router.serve('/ws')
    .transform(new WebSocketTransformer())
    .listen(handleWebSocket);

    virDir.serve(router.defaultStream);
  });
}

void handleWebSocket(WebSocket webSocket) {
  webSocket
  .map((string) => JSON.decode(string))
  .listen((json) {
    var request = json['request'];
    switch (request) {
      case 'search':
        break;
    }
  }, onError: (error) => print(error));
}
