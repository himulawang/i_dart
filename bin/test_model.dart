import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';

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

}
