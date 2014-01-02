import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';

import 'lib_test.dart';
import 'i_config/store.dart';
import 'i_config/orm.dart';

num startTimestamp;
num endTimestamp;

void main() {
  startTimestamp = new DateTime.now().millisecondsSinceEpoch;
  IRedisHandlerPool pool = new IRedisHandlerPool();
  pool.init(store['redis'])
  .then((_) => startTest());
}

Future flushdb() {
  // flushdb
  List waitList = [];
  IRedisHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((RedisClient redisClient) {
      waitList.add(redisClient.flushdb());
    });
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test rdb store', () {

    group('add', () {
      setUp(() => flushdb());
      test('model is invalid', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        expect(
            () => RoomRedisStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20022))
        );
      });
      setUp(() {});

      test('pk is not num', () {
        Room user = new Room(new List.filled(orm[1]['column'].length, '1'));
        expect(
            () => RoomRedisStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20023))
        );
      });

      test('toAddAbb return list length is 0 should throw exception', () {
        UserToAddLengthZero user = new UserToAddLengthZero(new List.filled(orm[2]['column'].length, 1));
        expect(
            () => UserToAddLengthZeroRedisStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20032))
        );
      });

      test('add success should reset updateList', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        UserRedisStore.add(user).then(expectAsync1((User user) {
          expect(user.isUpdated(), equals(false));
        }));
      });

      test('model exist should throw exception', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        UserRedisStore.add(user).catchError(expectAsync1((e) {
          expect(true, equals(e is IStoreException && e.code == 20024));
        }));
      });

    });

    group('set', () {
      setUp(() => flushdb());
      test('model is invalid', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        expect(
            () => RoomRedisStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20026))
        );
      });
      setUp(() {});

      test('pk is not num', () {
        Room user = new Room(new List.filled(orm[1]['column'].length, '1'));
        expect(
            () => RoomRedisStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20027))
        );
      });

      test('toSetAbb return list length is 0 should return model', () {
        UserToSetLengthZero user = new UserToSetLengthZero(new List.filled(orm[2]['column'].length, 1));
        expect(
            () => UserToSetLengthZeroRedisStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 25001))
        );
      });

      test('set success should reset updateList', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        user.name = '2';
        UserRedisStore.set(user).then(expectAsync1((User user) {
          expect(user.isUpdated(), equals(false));
        }));
      });

    });
  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
