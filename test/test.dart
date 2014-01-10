import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:redis_client/redis_client.dart';
import 'package:sqljocky/sqljocky.dart';

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

  IRedisHandlerPool redisPool = new IRedisHandlerPool();

  redisPool.init(store['redis'])
  .then((_) {
    List waitList = [];
    User user = new User()..setPK(1);
    RedisClient handler = new IRedisHandlerPool().getReaderHandler(UserRedisStore.store, user);
    /*
    waitList..add(UserRedisStore.get(1, 'u:1'))
            ..add(UserRedisStore.get(2, 'u:1'));
            */
    waitList
      ..add(handler.hmget('u:1:1', user.getMapAbb().keys).then((_) => print(1)))
      ..add(handler.hmget('u:1:2', user.getMapAbb().keys).then((_) => print(2)))
      ..add(handler.hmget('u:1:3', user.getMapAbb().keys).then((_) => print(3)))
      ..add(handler.hmget('u:1:4', user.getMapAbb().keys).then((_) => print(4)))
      ..add(handler.hmget('u:1:5', user.getMapAbb().keys).then((_) => print(5)))
    ;

    return Future.wait(waitList);
  })
  .then((List list) => print(list));
}

