import 'dart:io';

import 'package:logging/logging.dart';
import 'package:http_server/http_server.dart';
import 'package:route/server.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_test_server_route.dart';
import 'i_config/deploy.dart';
import 'i_config/orm.dart';
import 'i_config/store.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  int port = 8080;
  final String rootPath = deploy['appPath'] + '/web';

  var buildPath = Platform.script.resolve(rootPath).toFilePath();
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port).then((server) {
    Router router = new Router(server);

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

    var handler = new IWebSocketServerHandler();
    router.serve('/ws')
    .transform(new WebSocketTransformer())
    .listen(handler.onMessage);

    virDir.serve(router.defaultStream);

    ILog.info('WebSocket Server is running on http://${server.address.address}:${port}');
  });
}
