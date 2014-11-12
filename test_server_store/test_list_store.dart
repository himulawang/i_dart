import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:sqljocky/sqljocky.dart';
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

  IMariaDBHandlerPool mariaDBPool = new IMariaDBHandlerPool()..init(store['mariaDB']);
  IRedisHandlerPool redisPool = new IRedisHandlerPool();

  redisPool.init(store['redis'])
  .then((_) => flushdb())
  .then((_) => startTest());
}

Future flushdb() {
  // flushdb
  List waitList = [];
  IMariaDBHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((ConnectionPool pool) {
      waitList
        ..add(pool.query('TRUNCATE TABLE `UserSingle`;'))
        ..add(pool.query('TRUNCATE TABLE `Multiple`;'))
      ;
    });
  });

  IRedisHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((IRedis redisClient) => waitList.add(redisClient.flushdb()));
  });
  return Future.wait(waitList);
}

startTest() {

  group('Test list store', () {

    group('set', () {

      test('set no changed list should get warning', () {
        UserSingleList list = new UserSingleList(1);

        expect(
            () => UserSingleListStore.set(list),
            returnsNormally
        );

      });

      test('add 2 children successfully', () {
        UserSingleList list = new UserSingleList(1);
        UserSingle u1 = new UserSingle()
          ..id = 1
          ..name = 'ila'
          ..userName = 'ila'
          ..uniqueName = 'Empire';
        UserSingle u2 = new UserSingle()
          ..id = 1
          ..name = 'Dya'
          ..userName = 'Dya'
          ..uniqueName = 'Empire';

        list..add(u1)..add(u2);

        UserSingleListStore.set(list)
        .then(expectAsync((UserSingleList newList) {
          expect(identical(list, newList), isTrue);
          return UserSingleListMariaDBStore.get(1);
        }))
        .then(expectAsync((UserSingleList checkList) {
          UserSingle u1 = checkList.get('ila');
          expect(u1.id, equals(1));
          expect(u1.name, equals('ila'));
          expect(u1.uniqueName, equals('Empire'));

          UserSingle u2 = checkList.get('Dya');
          expect(u2.id, equals(1));
          expect(u2.name, equals('Dya'));
          expect(u2.uniqueName, equals('Empire'));
          return UserSingleListRedisStore.get(1);
        }))
        .then(expectAsync((UserSingleList checkList) {
          UserSingle u1 = checkList.get('ila');
          expect(u1.id, equals('1'));
          expect(u1.name, equals('ila'));
          expect(u1.uniqueName, equals('Empire'));

          UserSingle u2 = checkList.get('Dya');
          expect(u2.id, equals('1'));
          expect(u2.name, equals('Dya'));
          expect(u2.uniqueName, equals('Empire'));
        }));
      });

      test('set child successfully', () {
        UserSingleListStore.get(1)
        .then(expectAsync((UserSingleList list) {
          UserSingle u = list.get('ila');
          u.uniqueName = 'New Empire';

          list.set(u);

          return UserSingleListStore.set(list);
        }))
        .then((_) => UserSingleListMariaDBStore.get(1))
        .then(expectAsync((UserSingleList checkList) {
          UserSingle u1 = checkList.get('ila');
          expect(u1.id, equals(1));
          expect(u1.name, equals('ila'));
          expect(u1.uniqueName, equals('New Empire'));

          UserSingle u2 = checkList.get('Dya');
          expect(u2.id, equals(1));
          expect(u2.name, equals('Dya'));
          expect(u2.uniqueName, equals('Empire'));
          return UserSingleListRedisStore.get(1);
        }))
        .then(expectAsync((UserSingleList checkList) {
          UserSingle u1 = checkList.get('ila');
          expect(u1.id, equals('1'));
          expect(u1.name, equals('ila'));
          expect(u1.uniqueName, equals('New Empire'));

          UserSingle u2 = checkList.get('Dya');
          expect(u2.id, equals('1'));
          expect(u2.name, equals('Dya'));
          expect(u2.uniqueName, equals('Empire'));
        }));
      });

      test('del child successfully', () {
        UserSingleListStore.get(1)
        .then(expectAsync((UserSingleList list) {
          UserSingle u = list.get('Dya');

          list.del(u);
          return UserSingleListStore.set(list);
        }))
        .then((_) => UserSingleListMariaDBStore.get(1))
        .then(expectAsync((UserSingleList checkList) {
          UserSingle u1 = checkList.get('ila');
          expect(u1.id, equals(1));
          expect(u1.name, equals('ila'));
          expect(u1.uniqueName, equals('New Empire'));

          UserSingle u2 = checkList.get('Dya');
          expect(u2, null);
          return UserSingleListRedisStore.get(1);
        }))
        .then(expectAsync((UserSingleList checkList) {
          UserSingle u1 = checkList.get('ila');
          expect(u1.id, equals('1'));
          expect(u1.name, equals('ila'));
          expect(u1.uniqueName, equals('New Empire'));

          UserSingle u2 = checkList.get('Dya');
          expect(u2, null);
        }));
      });

      test('multiple pk: add 2 children successfully', () {
        MultipleList list = new MultipleList(1, 'ila');
        Multiple m1 = new Multiple()
          ..id = 1
          ..name = 'ila'
          ..gender = 0
          ..uniqueName = 'Empire'
          ..value = 100;

        Multiple m2 = new Multiple()
          ..id = 1
          ..name = 'ila'
          ..gender = 1
          ..uniqueName = 'ParaNoidz'
          ..value = 200;

        list..add(m1)..add(m2);

        MultipleListStore.set(list)
        .then(expectAsync((MultipleList newList) {
          expect(identical(list, newList), isTrue);
          return MultipleListMariaDBStore.get(1, 'ila');
        }))
        .then(expectAsync((MultipleList checkList) {
          Multiple m1 = checkList.get(0, 'Empire');
          expect(m1.id, equals(1));
          expect(m1.name, equals('ila'));
          expect(m1.gender, equals(0));
          expect(m1.uniqueName, equals('Empire'));
          expect(m1.value, equals(100));

          Multiple m2 = checkList.get(1, 'ParaNoidz');
          expect(m2.id, equals(1));
          expect(m2.name, equals('ila'));
          expect(m2.gender, equals(1));
          expect(m2.uniqueName, equals('ParaNoidz'));
          expect(m2.value, equals(200));

          return MultipleListRedisStore.get(1, 'ila');
        }))
        .then(expectAsync((MultipleList checkList) {
          Multiple m1 = checkList.get(0, 'Empire');
          expect(m1.id, equals('1'));
          expect(m1.name, equals('ila'));
          expect(m1.gender, equals('0'));
          expect(m1.uniqueName, equals('Empire'));
          expect(m1.value, equals('100'));

          Multiple m2 = checkList.get(1, 'ParaNoidz');
          expect(m2.id, equals('1'));
          expect(m2.name, equals('ila'));
          expect(m2.gender, equals('1'));
          expect(m2.uniqueName, equals('ParaNoidz'));
          expect(m2.value, equals('200'));
        }));
      });

      test('multiple pk: set child successfully', () {
        MultipleListStore.get(1, 'ila')
        .then(expectAsync((MultipleList list) {
          Multiple m1 = list.get(0, 'Empire');
          m1.value = 300;

          list.set(m1);

          return MultipleListStore.set(list);
        })).then(expectAsync((MultipleList checkList) {
          return MultipleListMariaDBStore.get(1, 'ila');
        }))
        .then(expectAsync((MultipleList list) {
          Multiple m1 = list.get(0, 'Empire');
          expect(m1.id, equals(1));
          expect(m1.name, equals('ila'));
          expect(m1.gender, equals(0));
          expect(m1.uniqueName, equals('Empire'));
          expect(m1.value, equals(300));

          Multiple m2 = list.get(1, 'ParaNoidz');
          expect(m2.id, equals(1));
          expect(m2.name, equals('ila'));
          expect(m2.gender, equals(1));
          expect(m2.uniqueName, equals('ParaNoidz'));
          expect(m2.value, equals(200));
          return MultipleListRedisStore.get(1, 'ila');
        }))
        .then(expectAsync((MultipleList list) {
          Multiple m1 = list.get(0, 'Empire');
          expect(m1.id, equals('1'));
          expect(m1.name, equals('ila'));
          expect(m1.gender, equals('0'));
          expect(m1.uniqueName, equals('Empire'));
          expect(m1.value, equals('300'));

          Multiple m2 = list.get(1, 'ParaNoidz');
          expect(m2.id, equals('1'));
          expect(m2.name, equals('ila'));
          expect(m2.gender, equals('1'));
          expect(m2.uniqueName, equals('ParaNoidz'));
          expect(m2.value, equals('200'));
        }));
      });

      test('multiple pk: del child successfully', () {

        MultipleListStore.get(1, 'ila')
        .then(expectAsync((MultipleList list) {
          Multiple m1 = list.get(0, 'Empire');

          list.del(m1);

          return MultipleListStore.set(list);
        })).then(expectAsync((MultipleList checkList) {
          return MultipleListMariaDBStore.get(1, 'ila');
        }))
        .then(expectAsync((MultipleList list) {
          Multiple m1 = list.get(0, 'Empire');
          expect(m1, isNull);

          Multiple m2 = list.get(1, 'ParaNoidz');
          expect(m2.id, equals(1));
          expect(m2.name, equals('ila'));
          expect(m2.gender, equals(1));
          expect(m2.uniqueName, equals('ParaNoidz'));
          expect(m2.value, equals(200));

          return MultipleListRedisStore.get(1, 'ila');
        }))
        .then(expectAsync((MultipleList list) {
          Multiple m1 = list.get(0, 'Empire');
          expect(m1, isNull);

          Multiple m2 = list.get(1, 'ParaNoidz');
          expect(m2.id, equals('1'));
          expect(m2.name, equals('ila'));
          expect(m2.gender, equals('1'));
          expect(m2.uniqueName, equals('ParaNoidz'));
          expect(m2.value, equals('200'));

          return MultipleListRedisStore.get(1, 'ila');
        }));

      });

    });

    group('get', () {

      test('get successfully', () {

        UserSingleListStore.get(1)
        .then(expectAsync((UserSingleList checkList) {
          UserSingle u1 = checkList.get('ila');
          expect(u1.id, equals('1'));
          expect(u1.name, equals('ila'));
          expect(u1.uniqueName, equals('New Empire'));

          UserSingle u2 = checkList.get('Dya');
          expect(u2, null);
        }));

      });

      test('get non-exist list should return empty list', () {

        UserSingleListStore.get(10)
        .then(expectAsync((UserSingleList checkList) {
          expect(checkList.isExist(), false);
        }));

      });

      test('multiple pk: get successfully', () {

        MultipleListStore.get(1, 'ila')
        .then(expectAsync((MultipleList list) {
          Multiple m1 = list.get(0, 'Empire');
          expect(m1, isNull);

          Multiple m2 = list.get(1, 'ParaNoidz');
          expect(m2.id, equals('1'));
          expect(m2.name, equals('ila'));
          expect(m2.gender, equals('1'));
          expect(m2.uniqueName, equals('ParaNoidz'));
          expect(m2.value, equals('200'));
        }));

      });

    });

    group('del', () {

      test('del successfully', () {
        UserSingleListStore.get(1)
        .then(expectAsync((UserSingleList list) {
          return UserSingleListStore.del(list);
        }))
        .then(expectAsync((_) {
          return UserSingleListStore.get(1);
        }))
        .then(expectAsync((UserSingleList list) {
          expect(list.isExist(), false);
        }));
      });

      test('multiple pk: del successfully', () {
        MultipleListStore.get(1, 'ila')
        .then(expectAsync((MultipleList list) {
          return MultipleListStore.del(list);
        }))
        .then(expectAsync((_) {
          return MultipleListStore.get(1, 'ila');
        }))
        .then(expectAsync((MultipleList list) {
          expect(list.isExist(), false);
        }));
      });

    });

  });

}
