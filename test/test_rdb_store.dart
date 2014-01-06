import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:redis_client/redis_client.dart';

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

      test('add expire model successfully', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        user.underworldName = '2';
        UserRedisStore.add(user).then(expectAsync1((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('add no expire model successfully', () {
        UserForever user = new UserForever(new List.filled(orm[4]['column'].length, 1));
        user.name = '2';
        UserForeverRedisStore.add(user).then(expectAsync1((UserForever user) {
          expect(user is UserForever, isTrue);
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

      test('toSetAbb return list length is 0 should get warning', () {
        UserToSetLengthZero user = new UserToSetLengthZero(new List.filled(orm[2]['column'].length, 1));
        UserToSetLengthZeroRedisStore.add(user)
        .then((UserToSetLengthZero user) {
          user.name = '2';
          return UserToSetLengthZeroRedisStore.set(user);
        })
        .then(expectAsync1((UserToSetLengthZero user) {
          expect(user is UserToSetLengthZero, isTrue);
        }));
      });

      test('set expire model successfully', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        user.name = '2';
        UserRedisStore.set(user).then(expectAsync1((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('set expire model successfully', () {
        UserForever user = new UserForever(new List.filled(orm[4]['column'].length, 1));
        user.name = '2';
        UserForeverRedisStore.set(user).then(expectAsync1((UserForever user) {
          expect(user is UserForever, isTrue);
        }));
      });

      setUp(() => flushdb());
      test('model not exist should throw exception', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        user.name = '2';
        UserRedisStore.set(user).catchError(expectAsync1((e) {
          expect(e is IStoreException, equals(true));
          expect(e.code, equals(20028));
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

      tearDown(() {
        endTimestamp = new DateTime.now().millisecondsSinceEpoch;
        print('cost ${endTimestamp - startTimestamp} ms');
      });
      test('del model not exist return normally', () {
        UserRedisStore.del(1).then(expectAsync1((result) {
          expect(result, equals(false));
        }));
      });

    });
  });

}
