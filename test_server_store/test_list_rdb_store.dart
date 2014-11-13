import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:i_redis/i_redis.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_test_server_store.dart';

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
  group('Test list rdb store', () {

    group('set', () {

      setUp(() => flushdb());

      test('first add 2 child successfully', () {

        UserSingle us1 = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 1));
        UserSingle us2 = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 2));

        UserSingleList userSingleList = new UserSingleList(1);
        userSingleList..add(us1)..add(us2);

        UserSingleListRedisStore.set(userSingleList)
        .then(expectAsync((UserSingleList userSingleList) {
          return UserSingleListRedisStore.get(1);
        }))
        .then(expectAsync((UserSingleList list) {
          var us1 = list.get(1);
          var us2 = list.get(2);

          expect(us1 is UserSingle, true);
          expect(us2 is UserSingle, true);
        }));

      });

      setUp(() {});

      test('set not changed list should get warning', () {

        UserSingleListRedisStore.get(1)
        .then(expectAsync((UserSingleList list) {
          var us1 = list.get(1);
          var us2 = list.get(2);

          expect(us1 is UserSingle, true);
          expect(us2 is UserSingle, true);

          return UserSingleListRedisStore.set(list);
        }))
        .then(expectAsync((UserSingleList list) {
          var us1 = list.get(1);
          var us2 = list.get(2);

          expect(us1 is UserSingle, true);
          expect(us2 is UserSingle, true);
        }));

      });

      test('set child successfully', () {

        UserSingleListRedisStore.get(1)
        .then(expectAsync((UserSingleList list) {
          var us1 = list.get(1);
          var us2 = list.get(2);

          expect(us1 is UserSingle, true);
          expect(us2 is UserSingle, true);

          us1.userName = 'aa';
          list.set(us1);

          return UserSingleListRedisStore.set(list);
        }))
        .then(expectAsync((_) => UserSingleListRedisStore.get(1)))
        .then(expectAsync((UserSingleList list) {
          var us1 = list.get(1);
          var us2 = list.get(2);

          expect(us1.userName, 'aa');
          expect(us2 is UserSingle, true);
        }));

      });

      test('del child successfully', () {

        UserSingleListRedisStore.get(1)
        .then(expectAsync((UserSingleList list) {
          var us1 = list.get(1);
          var us2 = list.get(2);

          expect(us1 is UserSingle, true);
          expect(us2 is UserSingle, true);

          list.del(us1);

          return UserSingleListRedisStore.set(list);
        }))
        .then(expectAsync((_) => UserSingleListRedisStore.get(1)))
        .then(expectAsync((UserSingleList list) {
          var us1 = list.get(1);
          var us2 = list.get(2);

          expect(us1, null);
          expect(us2 is UserSingle, true);
        }));

      });

      test('multiple pk: add 2 child successfully', () {

        UserMulti um1 = new UserMulti(new List.filled(orm['UserMulti']['Model']['column'].length, 1));
        UserMulti um2 = new UserMulti(new List.filled(orm['UserMulti']['Model']['column'].length, 2));

        UserMultiList userMultiList = new UserMultiList(1, 1);
        userMultiList..add(um1)..add(um2);

        UserMultiListRedisStore.set(userMultiList)
        .then(expectAsync((UserMultiList userMultiList) {
          return UserMultiListRedisStore.get(1, 1);
        }))
        .then(expectAsync((UserMultiList list) {
          var um1 = list.get(1, 1);
          var um2 = list.get(2, 2);

          expect(um1 is UserMulti, true);
          expect(um2 is UserMulti, true);
        }));

      });

      test('multiple pk: set 2 child successfully', () {

        UserMultiListRedisStore.get(1, 1)
        .then(expectAsync((UserMultiList list) {
          var um1 = list.get(1, 1);
          var um2 = list.get(2, 2);

          expect(um1 is UserMulti, true);
          expect(um2 is UserMulti, true);

          um1.value = 'aa';
          um2.value = 'bb';

          list..set(um1)..set(um2);

          return UserMultiListRedisStore.set(list);
        }))
        .then((UserMultiList list) {
          return UserMultiListRedisStore.get(1, 1);
        })
        .then(expectAsync((UserMultiList list) {
          var um1 = list.get(1, 1);
          var um2 = list.get(2, 2);

          expect(um1.value, 'aa');
          expect(um2.value, 'bb');
        }));

      });

      test('multiple pk: del child successfully', () {

        UserMultiListRedisStore.get(1, 1)
        .then(expectAsync((UserMultiList list) {
          var um1 = list.get(1, 1);
          var um2 = list.get(2, 2);

          expect(um1 is UserMulti, true);
          expect(um2 is UserMulti, true);

          list.del(um1);

          return UserMultiListRedisStore.set(list);
        }))
        .then(expectAsync((_) => UserMultiListRedisStore.get(1, 1)))
        .then(expectAsync((UserMultiList list) {
          var um1 = list.get(1, 1);
          var um2 = list.get(2, 2);

          expect(um1, null);
          expect(um2 is UserMulti, true);
        }));

      });

      test('add child with no expire', () {

        UserSingleNoExpire usne1 = new UserSingleNoExpire(new List.filled(orm['UserSingle']['Model']['column'].length, 1));
        UserSingleNoExpire usne2 = new UserSingleNoExpire(new List.filled(orm['UserSingle']['Model']['column'].length, 2));

        UserSingleNoExpireList list = new UserSingleNoExpireList(1);
        list..add(usne1)..add(usne2);

        UserSingleNoExpireListRedisStore.set(list)
        .then(expectAsync((UserSingleNoExpireList usneList) {
          return UserSingleNoExpireListRedisStore.get(1);
        }))
        .then(expectAsync((UserSingleNoExpireList list) {
          var usne1 = list.get(1);
          var usne2 = list.get(2);

          expect(usne1 is UserSingleNoExpire, true);
          expect(usne2 is UserSingleNoExpire, true);
        }));

      });

      test('set child with no expire', () {

        UserSingleNoExpireListRedisStore.get(1)
        .then(expectAsync((UserSingleNoExpireList list) {
          var usne1 = list.get(1);
          var usne2 = list.get(2);

          expect(usne1 is UserSingleNoExpire, true);
          expect(usne2 is UserSingleNoExpire, true);

          usne1.userName = 'aa';
          usne2.userName = 'bb';

          list..set(usne1)..set(usne2);

          return UserSingleNoExpireListRedisStore.set(list);
        }))
        .then(expectAsync((_) {
          return UserSingleNoExpireListRedisStore.get(1);
        }))
        .then(expectAsync((UserSingleNoExpireList list) {
          var usne1 = list.get(1);
          var usne2 = list.get(2);

          expect(usne1 is UserSingleNoExpire, true);
          expect(usne2 is UserSingleNoExpire, true);
          expect(usne1.userName, 'aa');
          expect(usne2.userName, 'bb');
        }));

      });

    });

    group('get', () {

      test('get successfully', () {

        UserSingleListRedisStore.get(1)
        .then(expectAsync((UserSingleList list) {
          var us = list.get(2);
          expect(us is UserSingle, true);
        }));

      });

      test('get not exist list should return empty list', () {

        UserSingleListRedisStore.get(2)
        .then(expectAsync((UserSingleList list) {
          expect(list.isExist(), false);
        }));

      });

      test('multiple pk: get successfully', () {

        UserMultiListRedisStore.get(1, 1)
        .then(expectAsync((UserMultiList list) {
          var um = list.get(2, 2);
          expect(um is UserMulti, true);
        }));

      });

    });

    group('del', () {

      test('del list', () {

        UserSingleListRedisStore.get(1)
        .then(expectAsync((UserSingleList list) {
          return UserSingleListRedisStore.del(list);
        }))
        .then(expectAsync((_) => UserSingleListRedisStore.get(1)))
        .then(expectAsync((UserSingleList list) {
          expect(list.length, 0);
        }));

      });

      test('multiple pk: del list', () {

        UserMultiListRedisStore.get(1, 1)
        .then(expectAsync((UserMultiList list) {
          return UserMultiListRedisStore.del(list);
        }))
        .then(expectAsync((_) => UserMultiListRedisStore.get(1, 1)))
        .then(expectAsync((UserMultiList list) {
          expect(list.length, 0);
        }));

      });

    });


  });
}
