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

  IMariaDBHandlerPool mariaDBPool = new IMariaDBHandlerPool()..init(store['mariaDB']);
  IRedisHandlerPool redisPool = new IRedisHandlerPool();

  redisPool.init(store['redis'])
  .then((_) => startTest());
}

Future flushdb() {
  // flushdb
  List waitList = [];
  IMariaDBHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((ConnectionPool pool) {
      waitList.add(
          pool.query('TRUNCATE TABLE `User`;')
      );
      waitList.add(
          pool.query('TRUNCATE TABLE `UserToSetLengthZero`;')
      );
    });
  });

  IRedisHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((RedisClient redisClient) => waitList.add(redisClient.flushdb()));
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test pk store', () {

    group('common pk', () {

      setUp(() => flushdb());

      test('set successfully', () {
        UserPK pk = new UserPK();
        user.name = 'c';
        UserStore.add(user)
        .then(expectAsync1((User user) {
          expect(user.isUpdated(), isFalse);
        }));
      });

      setUp(() {});

    });

  });
}
