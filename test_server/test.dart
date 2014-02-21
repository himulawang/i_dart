import 'dart:async';
import 'dart:math';

import 'package:http/http.dart' as http;
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
  Map test = {'1': 1, '2': 2};
  print(test.keys.toList());
  print(test.keys.map((value) => int.parse(value)).toList().reduce(max));
  /*

  IRedisHandlerPool redisPool = new IRedisHandlerPool();

  redisPool.init(store['redis'])
  .then((_) {
    List waitList = [];
    User user = new User()..setPK(1);
    RedisClient handler = new IRedisHandlerPool().getReaderHandler(UserRedisStore.store, user);
    /*
    waitList..add(UserRedisStore.get(1, 'u:1'))
            ..add(UserRedisStore.get(2, 'u:1'));
    waitList
      ..add(handler.hmget('u:1:1', user.getMapAbb().keys).then((_) => print(1)))
      ..add(handler.hmget('u:1:2', user.getMapAbb().keys).then((_) => print(2)))
      ..add(handler.hmget('u:1:3', user.getMapAbb().keys).then((_) => print(3)))
      ..add(handler.hmget('u:1:4', user.getMapAbb().keys).then((_) => print(4)))
      ..add(handler.hmget('u:1:5', user.getMapAbb().keys).then((_) => print(5)))
    ;
    */
    waitList
      ..add(handler.hmget('u:1:1', ['a', 'b']).then((_) => print(1)))
      ..add(handler.hmget('u:1:2', ['a', 'b']).then((_) => print(2)))
      ..add(handler.hmget('u:1:3', ['a', 'b']).then((_) => print(3)))
      ..add(handler.hmget('u:1:4', ['a', 'b']).then((_) => print(4)))
      ..add(handler.hmget('u:1:5', ['a', 'b']).then((_) => print(5)))
      ..add(handler.hmget('u:1:6', ['a', 'b']).then((_) => print(6)))
      ..add(handler.hmget('u:1:7', ['a', 'b']).then((_) => print(7)))
    ;
    /*
    waitList
      ..add(handler.smembers('u:1:1').then((_) => print(1)))
      ..add(handler.smembers('u:1:2').then((_) => print(2)))
      ..add(handler.smembers('u:1:3').then((_) => print(3)))
      ..add(handler.smembers('u:1:4').then((_) => print(4)))
      ..add(handler.smembers('u:1:5').then((_) => print(5)))
    ;
    */

    return Future.wait(waitList);
  })
  .then((List list) => print(list));
  */

}

