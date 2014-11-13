import 'dart:html';

import 'package:logging/logging.dart';
import 'package:i_dart/i_dart_clt.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'lib_test_client_route.dart';

void main() {
  useHtmlEnhancedConfiguration();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var ws = new IWebSocketClientHandler();
  ws.connect('ws://127.0.0.1:8080/ws')
  .then((_) {
    ILog.info('Connected To Server.');
    startTest(ws);
  });

}

startTest(IWebSocketClientHandler ws) {

  group('entrance', () {

    // i_dart don't have async sendBlobAsync & sendStringAsync, so if server not crash
    // we consider this group of test is passed
    group('data integrity', () {

      test('send blob', () {

        ws.ws.sendBlob(new Blob(['HelloWorld']));

      });

      test('send non-json', () {

        ws.ws.send('non-json');

      });

    });

    group('data format', () {

      test('json not satisify the rule of i_dart', () {

        ws.ws.send('{"b":1}');

      });

      test('api is not server route config', () {

        ws.reqAsync('NotExistAPI', {})
        .catchError(expectAsync((e) {
          expect(e.code, 50003);
          expect(e.message, 'Server error, api: onNotExistAPI, code: 40005, message: "Api NotExistAPI is invalid.".');
        }));

      });

    });

  });

}
