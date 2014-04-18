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
  .then((_) => startTest());
}

Future flushdb() {
  // flushdb
  List waitList = [];
  IRedisHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((RedisClient redisClient) => waitList.add(redisClient.flushdb()));
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test pk rdb store', () {

    group('set', () {

      setUp(() => flushdb());

      test('set successfully', () {
        UserPK pk = new UserPK();
        pk.incr();
        pk.incr();
        pk.incr();
        UserPKRedisStore.set(pk)
        .then(expectAsync1((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
        }));
      });

      setUp(() {});

      test('set unchanged pk should do nothing', () {
        UserPK pk = new UserPK();
        UserPKRedisStore.set(pk)
        .then(expectAsync1((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
        }));
      });

    });

    group('get', () {

      test('get successfully', () {
        UserPKRedisStore.get()
        .then(expectAsync1((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(3));
        }));
      });

      test('pk not exist should get pk with value 0', () {
        RoomPKRedisStore.get()
        .then(expectAsync1((RoomPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(0));
        }));
      });

    });

    group('del', () {

      test('del successfully', () {
        UserPK pk = new UserPK();
        UserPKRedisStore.del(pk)
        .then((_) => UserPKRedisStore.get())
        .then(expectAsync1((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(0));
        }));
      });

      test('del pk not exist should get warning', () {
        UserPK pk = new UserPK();
        UserPKRedisStore.del(pk)
        .then(expectAsync1((bool result) {
          expect(result, isFalse);
        }));
      });

    });

    group('incr', () {

      test('incr successfully', () {
        UserPKRedisStore.incr()
        .then(expectAsync1((UserPK pk) {
          expect(pk.get(), equals(1));
          return UserPKRedisStore.incr();
        }))
        .then(expectAsync1((UserPK pk) {
          expect(pk.get(), equals(2));
          return UserPKRedisStore.incr();
        }))
        .then(expectAsync1((UserPK pk) {
          expect(pk.get(), equals(3));
          return UserPKRedisStore.incr();
        }));
      });

    });

  });
}
