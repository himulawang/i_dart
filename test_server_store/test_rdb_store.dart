import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:i_redis/i_redis.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_test_server_store.dart';
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
    group.forEach((IRedis redisClient) => waitList.add(redisClient.flushdb()));
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test rdb store', () {

    group('store', () {
      test('should equal store in store.dart', () {
        expect(UserRedisStore.store, equals(orm['User']['ModelStore']['storeOrder'][0]));
      });
    });

    group('abb', () {
      test('should equal abb in orm.dart', () {
        expect(UserRedisStore.abb, equals(orm['User']['ModelStore']['storeOrder'][0]['abb']));
      });
    });

    group('add', () {

      setUp(() => flushdb());

      test('pk is null should throw exception', () {
        Room user = new Room();
        expect(
            () => RoomRedisStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20042))
        );
      });

      setUp(() {});

      test('toAddAbb return list length is 0 should throw exception', () {
        UserToAddLengthZero user = new UserToAddLengthZero(new List.filled(orm['UserToAddLengthZero']['Model']['column'].length, 1));
        expect(
            () => UserToAddLengthZeroRedisStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20032))
        );
      });

      test('add expire model successfully', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        user.underworldName = '2';
        UserRedisStore.add(user).then(expectAsync((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('add no expire model successfully', () {
        UserForever user = new UserForever(new List.filled(orm['UserForever']['Model']['column'].length, 1));
        user.name = '2';
        UserForeverRedisStore.add(user).then(expectAsync((UserForever user) {
          expect(user is UserForever, isTrue);
        }));
      });

      test('model exist should throw exception', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        UserRedisStore.add(user).catchError(expectAsync((e) {
          expect(e is IStoreException, equals(true));
          expect(e.code, equals(20024));
        }));
      });

      test('multiple pk: pk contains null should throw exception', () {
        UserMulti um = new UserMulti()
          ..id = 1
        ;
        expect(
            () => UserMultiRedisStore.add(um),
            throwsA(predicate((e) => e is IStoreException && e.code == 20042))
        );
      });

      test('multiple pk: add model successfully', () {
        UserMulti um = new UserMulti()
          ..id = 10
          ..name = 'aa'
          ..gender = 1
          ..uniqueName = 'bb'
        ;

        UserMultiRedisStore.add(um).then(expectAsync((UserMulti userMulti) {
          expect(userMulti is UserMulti, isTrue);
        }));
      });

    });

    group('set', () {

      test('pk is null should throw exception', () {
        Room user = new Room();
        expect(
            () => RoomRedisStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 20042))
        );
      });

      test('toSetAbb return list length is 0 should get warning', () {
        UserToSetLengthZero user = new UserToSetLengthZero(new List.filled(orm['UserToSetLengthZero']['Model']['column'].length, 1));
        UserToSetLengthZeroRedisStore.add(user)
        .then(expectAsync((UserToSetLengthZero user) {
          user.name = '2';
          return UserToSetLengthZeroRedisStore.set(user);
        }))
        .then(expectAsync((UserToSetLengthZero user) {
          expect(user is UserToSetLengthZero, isTrue);
        }));
      });

      test('set expire model successfully', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        user.name = '2';
        UserRedisStore.set(user).then(expectAsync((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('set expire model successfully', () {
        UserForever user = new UserForever(new List.filled(orm['UserForever']['Model']['column'].length, 1));
        user.name = '2';
        UserForeverRedisStore.set(user).then(expectAsync((UserForever user) {
          expect(user is UserForever, isTrue);
        }));
      });

      test('multiple pk: pk contains null should throw exception', () {
        UserMulti um = new UserMulti()
          ..id = 1
        ;
        expect(
            () => UserMultiRedisStore.set(um),
            throwsA(predicate((e) => e is IStoreException && e.code == 20042))
        );
      });

      test('multiple pk: set model successfully', () {
        UserMulti um = new UserMulti([10, 'aa', 1, 'bb', 'cc'])
          ..gender = 200
        ;
        UserMultiRedisStore.set(um).then(expectAsync((UserMulti userMulti) {
          expect(userMulti is UserMulti, isTrue);
        }));
      });

      setUp(() => flushdb());

      test('model not exist should throw exception', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        user.name = '2';
        UserRedisStore.set(user).catchError(expectAsync((e) {
          expect(e is IStoreException, equals(true));
          expect(e.code, equals(20028));
        }));
      });

      setUp(() {});

    });

    group('get', () {

      test('model does not exist in redis return model', () {
        UserRedisStore.get(22).then(expectAsync((User user) {
          expect(user.isExist(), equals(false));
        }));
      });

      test('get success', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        UserRedisStore
        .add(user)
        .then((_) => UserRedisStore.get(1))
        .then(expectAsync((User gotUser) {
          expect(gotUser.getPK(), '1');
          expect(gotUser.name, '1');
        }));
      });

      test('multiple pk: get success', () {
        UserMulti um = new UserMulti([2, 'aa', 3, 'bb', 'cc']);
        UserMultiRedisStore
        .add(um)
        .then((_) => UserMultiRedisStore.get(2, 'aa', 'bb'))
        .then(expectAsync((UserMulti gotUM) {
          expect(gotUM.isExist(), isTrue);
          expect(gotUM.getPK(), equals(['2', 'aa', 'bb']));
          expect(gotUM.name, equals('aa'));
        }));
      });

    });

    group('del', () {

      test('input is mode del success', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        UserRedisStore
        .del(user)
        .then(expectAsync((result) {
          expect(result, 1);
        }));
      });

      test('del model not exist return normally', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        UserRedisStore.del(user).then(expectAsync((result) {
          expect(result, 0);
        }));
      });

      tearDown(() {
        endTimestamp = new DateTime.now().millisecondsSinceEpoch;
        print('cost ${endTimestamp - startTimestamp} ms');
      });

      test('multiple pk: del success', () {
        UserMulti um = new UserMulti([2, 'aa', 200, 'bb', 'cc']);
        UserMultiRedisStore.del(um)
        .then(expectAsync((result) {
          expect(result, 1);
        }));
      });

    });
  });

}
