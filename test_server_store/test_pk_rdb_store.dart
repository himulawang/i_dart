import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:i_redis/i_redis.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_test_server_store.dart';
import 'i_config/store.dart';

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
    group.forEach((IRedis redisClient) => waitList.add(redisClient.flushdb()));
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
        .then(expectAsync((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
        }));
      });

      setUp(() {});

      test('set unchanged pk should do nothing', () {
        UserPK pk = new UserPK();
        UserPKRedisStore.set(pk)
        .then(expectAsync((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
        }));
      });

    });

    group('get', () {

      test('get successfully', () {
        UserPKRedisStore.get()
        .then(expectAsync((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(3));
        }));
      });

      test('pk not exist should get pk with value 0', () {
        RoomPKRedisStore.get()
        .then(expectAsync((RoomPK pk) {
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
        .then(expectAsync((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(0));
        }));
      });

      test('del pk not exist should get warning', () {
        UserPK pk = new UserPK();
        UserPKRedisStore.del(pk)
        .then(expectAsync((int result) {
          expect(result, 0);
        }));
      });

    });

    group('incr', () {

      test('incr successfully', () {
        UserPKRedisStore.incr()
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(1));
          return UserPKRedisStore.incr();
        }))
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(2));
          return UserPKRedisStore.incr();
        }))
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(3));
          return UserPKRedisStore.incr();
        }));
      });

    });

  });
}
