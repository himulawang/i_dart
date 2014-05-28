import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:i_redis/i_redis.dart';
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
    group.forEach((IRedis redisClient) => waitList.add(redisClient.flushdb()));
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test list rdb store', () {

    group('set', () {

      setUp(() => flushdb());

      test('invalid list should throw exception', () {
        RoomList roomList = new RoomList(1);

        expect(
            () => UserSingleListRedisStore.set(roomList),
            throwsA(predicate((e) => e is IStoreException && e.code == 20040))
        );
      });

      setUp(() {});

      test('first add 2 child successfully', () {
        UserSingle us1 = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 1));
        UserSingle us2 = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 2));

        UserSingleList userSingleList = new UserSingleList(1);
        userSingleList..add(us1)..add(us2);

        UserSingleListRedisStore.set(userSingleList)
        .then(expectAsync((UserSingleList userSingleList) {
          expect(userSingleList.length, equals(2));
          expect(userSingleList.getToAddList().length, equals(0));
        }));
      });

      test('get success', () {
        UserSingleListRedisStore.get(1)
        .then(expectAsync((UserSingleList list) {
          var us1 = list.get(1);
          var us2 = list.get(2);

          expect(us1 is UserSingle, true);
          expect(us2 is UserSingle, true);
        }));

      });


      /*
      test('set not changed list should get warning', () {

      });
      test('set child successfully', () {
        UserMultiListRedisStore.get(1)
        .then((UserList userList) {
          User user1 = userList.get(1);
          user1.name = 'a';

          userList.set(user1);

          return UserMultiListRedisStore.set(userList);
        })
        .then((_) => UserMultiListRedisStore.get(1))
        .then(expectAsync((UserList userList) {
          User user1 = userList.get(1);
          expect(user1.name, equals('a'));
        }));
      });
      */

    });

  });
}
