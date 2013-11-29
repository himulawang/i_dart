import 'dart:async';

import 'package:logging/logging.dart';

import '../out/lib_i_model.dart';
import '../bin/i_model_config/store.dart';

IRedisHandlerPool redisHandlerPool;
IMariaDBHandlerPool mariaDBHandlerPool;

void main() {
  // init
  redisHandlerPool = new IRedisHandlerPool(store['redis']);
  mariaDBHandlerPool = new IMariaDBHandlerPool(store['mariaDB']);

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });


/*
  Logger log = new Logger('I');

  log.warning('test');
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  */
  //ILog.warning('test');

  new Timer(new Duration(seconds: 1), aa);
}

void aa() {
  var c = new Connection();
  c.id = 28;
  c.name = 'bb';
  c.host = 'local';
  c.toAddFilter = 'localhost';
  c.toAddFilt = 'localhost';

  //ConnectionStore.set(c);
  ConnectionStore.get(2).then((c) => print(c.toAbb()));

}

