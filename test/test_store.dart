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
    });
  });

  IRedisHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((RedisClient redisClient) => waitList.add(redisClient.flushdb()));
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test store', () {

    group('add', () {
      setUp(() => flushdb());
      test('add successfully should reset updatedList', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        user.name = 'c';
        UserStore.add(user)
        .then(expectAsync1((User user) {
          expect(user.isUpdated(), isFalse);
        }));
      });
      setUp(() {});

    });

    group('set', () {
      test('set successfully should reset updatedList', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        user.name = 'a';
        UserStore.set(user)
        .then(expectAsync1((User user) {
          expect(user.isUpdated(), isFalse);
        }));
      });

      test('toSetAbb return list length is 0 should get 2 warnings', () {
        UserToSetLengthZero user = new UserToSetLengthZero(new List.filled(orm[2]['column'].length, 1));
        UserToSetLengthZeroStore.add(user)
        .then((UserToSetLengthZero user) {
          user.name = 'c';
          return UserToSetLengthZeroStore.set(user);
        })
        .then(expectAsync1((UserToSetLengthZero user) {
          expect(user.isUpdated(), isFalse);
        }));
      });

    });

  });

}
