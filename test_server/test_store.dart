import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:i_redis/i_redis.dart';

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
      waitList..add(pool.query('TRUNCATE TABLE `User`;'))
              ..add(pool.query('TRUNCATE TABLE `UserToSetLengthZero`;'))
              ..add(pool.query('TRUNCATE TABLE `UserMulti`;'))
      ;
    });
  });

  IRedisHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((IRedis redisClient) => waitList.add(redisClient.flushdb()));
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test store', () {

    group('add', () {

      setUp(() => flushdb());

      test('add successfully should reset updatedList', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        user.name = 'c';
        UserStore.add(user)
        .then(expectAsync((User user) {
          expect(user.isUpdated(), isFalse);
        }));
      });

      setUp(() {});

    });

    group('set', () {

      test('set successfully should reset updatedList', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        user.name = 'a';
        UserStore.set(user)
        .then(expectAsync((User user) {
          expect(user.isUpdated(), isFalse);
        }));
      });

      test('toSetAbb return list length is 0 should get 2 warnings', () {
        UserToSetLengthZero user = new UserToSetLengthZero(new List.filled(orm['UserToSetLengthZero']['Model']['column'].length, 1));
        UserToSetLengthZeroStore.add(user)
        .then((UserToSetLengthZero user) {
          user.name = 'c';
          return UserToSetLengthZeroStore.set(user);
        })
        .then(expectAsync((UserToSetLengthZero user) {
          expect(user.isUpdated(), isFalse);
        }));
      });

    });

    group('get', () {

      test('get rdb model if model exists in rdb', () {
        UserStore.get(1)
        .then(expectAsync((User user) {
          expect(user.name, equals('a'));
        }));
      });

      test('get mdb model if model exists in mdb', () {
        User u = new User()..setPK(1);
        UserRedisStore.del(u)
        .then((_) => UserStore.get(1))
        .then(expectAsync((User user) {
          expect(user.name, equals('a'));
        }));
      });

      test('got model with !isExist if model not exists in both db', () {
        User u = new User()..setPK(1);
        UserStore.del(u)
        .then((_) => UserStore.get(1))
        .then(expectAsync((User user) {
          expect(user.isExist(), isFalse);
        }));
      });

    });

    group('del', () {

      tearDown(() {
        endTimestamp = new DateTime.now().millisecondsSinceEpoch;
        print('cost ${endTimestamp - startTimestamp} ms');
      });

      test('del successfully', () {
        UserToSetLengthZero u = new UserToSetLengthZero()..setPK(1);
        UserToSetLengthZeroStore.del(u)
        .then((_) => UserToSetLengthZeroStore.get(1))
        .then(expectAsync((UserToSetLengthZero user) {
          expect(user.isExist(), isFalse);
        }));
      });

    });

  });
}
