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
  group('Test list rdb store', () {

    group('set', () {

      setUp(() => flushdb());

      test('invalid list should throw exception', () {
        RoomList roomList = new RoomList(1);

        expect(
            () => UserListRedisStore.set(roomList),
            throwsA(predicate((e) => e is IStoreException && e.code == 20040))
        );
      });

      setUp(() {});

      test('first add 2 child successfully', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList(1);
        userList..add(user1)..add(user2);

        UserListRedisStore.set(userList)
        .then(expectAsync1((UserList userList) {
          expect(userList.length, equals(2));
          expect(userList.getToAddList().length, equals(0));
        }));
      });

      test('set child successfully', () {
        UserListRedisStore.get(1)
        .then((UserList userList) {
          User user1 = userList.get(1);
          user1.name = 'a';

          userList.set(user1);

          return UserListRedisStore.set(userList);
        })
        .then((_) => UserListRedisStore.get(1))
        .then(expectAsync1((UserList userList) {
          User user1 = userList.get(1);
          expect(user1.name, equals('a'));
        }));
      });

    });

  });
}
