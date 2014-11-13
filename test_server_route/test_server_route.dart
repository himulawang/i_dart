import 'dart:io';

import 'package:logging/logging.dart';
import 'package:http_server/http_server.dart';
import 'package:route/server.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_test_server_route.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  int port = 8080;

  var buildPath = Platform.script.resolve('/home/ila/project/i_dart/test_client_route').toFilePath();
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port).then((server) {
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

    var handler = new IWebSocketServerHandler(serverRoute);
    router.serve('/ws')
    .transform(new WebSocketTransformer())
    .listen(handler.onMessage);

    virDir.serve(router.defaultStream);

    ILog.info('WebSocket Server is running on http://${server.address.address}:${port}');
  });
}
