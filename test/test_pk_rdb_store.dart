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

    group('common pk', () {

      setUp(() => flushdb());

      test('pk not exist should get pk with value 0', () {
        UserPKRedisStore.get()
        .then(expectAsync1((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(0));
        }));
      });

      setUp(() {});

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

      test('set unchanged pk should do nothing', () {
        UserPK pk = new UserPK();
        UserPKRedisStore.set(pk)
        .then(expectAsync1((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
        }));
      });

      test('get successfully', () {
        UserPKRedisStore.get()
        .then(expectAsync1((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(3));
        }));
      });

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

  });
}
