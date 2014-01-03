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
    group.forEach((RedisClient redisClient) => waitList.add(redisClient.flushdb()));
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
          expect(e is IStoreException, equals(true));
          expect(e.code, equals(20024));
        }));
      });

    });

    group('set', () {
      test('model is invalid', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        expect(
            () => RoomRedisStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20026))
        );
      });

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

      setUp(() => flushdb());
      test('model not exist should throw exception', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        user.name = '2';
        UserRedisStore.set(user).catchError(expectAsync1((e) {
          expect(e is IStoreException, equals(true));
          expect(e.code, equals(20033));
        }));
      });

    });

    group('get', () {
      test('pk is not num', () {
        expect(
            () => RoomRedisStore.get('1'),
            throwsA(predicate((e) => e is IStoreException && e.code == 20021))
        );
      });

      test('model does not exist in redis return model', () {
        UserRedisStore.get(22).then(expectAsync1((User user) {
          expect(user.isExist(), equals(false));
        }));
      });

      test('get success', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        UserRedisStore
        .add(user)
        .then((_) => UserRedisStore.get(1))
        .then(expectAsync1((User gotUser) {
          expect(gotUser.getPK(), equals(1));
          expect(gotUser.name, equals(1));
        }));
      });

    });

    group('del', () {
      test('input is not model or num', () {
        expect(
            () => UserRedisStore.del('a'),
            throwsA(predicate((e) => e is IStoreException && e.code == 20030))
        );
      });

      test('input is num del success', () {
        UserRedisStore.del(1).then(expectAsync1((result) {
          expect(result, equals(true));
        }));
      });

      test('input is mode del success', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        UserRedisStore
        .add(user)
        .then((_) => UserRedisStore.del(user))
        .then(expectAsync1((result) {
          expect(result, equals(true));
        }));
      });

      test('del model not exist return normally', () {
        UserRedisStore.del(1).then(expectAsync1((result) {
          expect(result, equals(false));
        }));
      });

    });
  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
