import 'dart:html';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'lib_test_route.dart';
import './i_config/orm.dart';
import './i_config/store.dart';


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

startTest(ws) {

  group('entrance', () {

    group('data integrity', () {

      test('receive blob', () {

      });

    });

  });

}

