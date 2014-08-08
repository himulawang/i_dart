import 'dart:io';

main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040)
  .then((HttpServer server) {
    print('listening on localhost, port ${server.port}');
    server.listen((HttpRequest request) {
      request.response.write('Hello, world!');
      request.response.close();
    });
  }).catchError((e) => print(e.toString()));
}

