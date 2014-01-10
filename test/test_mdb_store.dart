/*
CREATE DATABASE `i_dart` COLLATE utf8_bin;
USE `i_dart`;

DROP TABLE IF EXISTS `User`;
CREATE TABLE IF NOT EXISTS `User` (
  `id` bigint(20) NOT NULL,
  `name` varchar(16) NOT NULL,
  `userName` varchar(16) NOT NULL,
  `uniqueName` varchar(16) NOT NULL,
  `underworldName` varchar(16) NOT NULL,
  `underworldName1` varchar(16) NOT NULL,
  `underworldName2` varchar(16) NOT NULL,
  `thisIsABitLongerAttribute` varchar(16) NOT NULL,
  `testAddFilterColumn1` varchar(16) NOT NULL,
  `testAddFilterColumn2` varchar(16) NOT NULL,
  `testSetFilterColumn1` varchar(16) NOT NULL,
  `testSetFilterColumn2` varchar(16) NOT NULL,
  `testFullFilterColumn1` varchar(16) NOT NULL,
  `testFullFilterColumn2` varchar(16) NOT NULL,
  `testAbbFilterColumn1` varchar(16) NOT NULL,
  `testAbbFilterColumn2` varchar(16) NOT NULL,
  `testListFilterColumn1` varchar(16) NOT NULL,
  `testListFilterColumn2` varchar(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `UserToSetLengthZero`;
CREATE TABLE IF NOT EXISTS `UserToSetLengthZero` (
  `id` bigint(20) NOT NULL,
  `name` varchar(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `PK`;
CREATE TABLE IF NOT EXISTS `PK` (
  `key` varchar(32) NOT NULL,
  `pk` bigint(20) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB;

 */
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
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

  IMariaDBHandlerPool pool = new IMariaDBHandlerPool()..init(store['mariaDB']);
  flushdb().then((_) => startTest());
}

Future flushdb() {
  // flushdb
  List waitList = [];
  IMariaDBHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((ConnectionPool pool) {
      waitList.add(
        pool.query('TRUNCATE TABLE `User`;')
      );
    });
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test mdb store', () {

    group('store', () {
      test('should equal store in store.dart', () {
        expect(UserMariaDBStore.store, equals(orm[0]['storeOrder'][1]));
      });
    });

    group('table', () {
      test('should equal table in orm.dart', () {
        expect(UserMariaDBStore.table, equals(orm[0]['storeOrder'][1]['table']));
      });
    });

    group('add', () {
      test('model is invalid', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        expect(
            () => RoomMariaDBStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21023))
        );
      });

      test('pk is not num', () {
        User user = new User(new List.filled(orm[0]['column'].length, '1'));
        expect(
            () => UserMariaDBStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21024))
        );
      });

      test('toAddAbb return list length is 0 should throw exception', () {
        UserToAddLengthZero user = new UserToAddLengthZero(new List.filled(orm[2]['column'].length, 1));
        expect(
            () => UserToAddLengthZeroMariaDBStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21035))
        );
      });

      test('add successfully', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1))
        ..name = '2';
        UserMariaDBStore.add(user)
        .then(expectAsync1((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('add duplicated pk model should throw exception', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        UserMariaDBStore.add(user)
        .catchError(expectAsync1((e) {
          expect(e is IStoreException, isTrue);
          expect(e.code, equals(21028));
        }));
      });

    });

    group('set', () {

      test('model is invalid', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        expect(
            () => RoomMariaDBStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21026))
        );
      });

      test('pk is not num', () {
        User user = new User(new List.filled(orm[0]['column'].length, '1'));
        expect(
            () => UserMariaDBStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21027))
        );
      });

      test('toSetAbb return list length is 0 should get warning', () {
        UserToSetLengthZero user = new UserToSetLengthZero(new List.filled(orm[2]['column'].length, 1));
        user.name = '3';
        UserToSetLengthZeroMariaDBStore.set(user)
        .then(expectAsync1((UserToSetLengthZero user) {
          expect(user is UserToSetLengthZero, isTrue);
        }));
      });

      test('no record affected should get warning', () {
        User user = new User(new List.filled(orm[0]['column'].length, 2));
        user..name = 'b'
            ..underworldName = 'c';
        UserMariaDBStore.set(user)
        .then(expectAsync1((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('set successfully', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        user..name = 'b'
            ..underworldName = 'c';
        UserMariaDBStore.set(user)
        .then(expectAsync1((User user) {
          expect(user is User, isTrue);
        }));
      });
    });

    group('get', () {

      test('pk is not num', () {
        expect(
            () => UserMariaDBStore.get('1'),
            throwsA(predicate((e) => e is IStoreException && e.code == 21021))
        );
      });

      test('model not exist in mdb should return model with !isExist', () {
        UserMariaDBStore.get(9)
        .then(expectAsync1((User user) {
          expect(user.isExist(), equals(false));
        }));
      });

      test('get model successfully', () {
        UserMariaDBStore.get(1)
        .then(expectAsync1((User user) {
          expect(user.isExist(), equals(true));
          expect(user.name, equals('b'));
        }));
      });

    });

    group('del', () {

      test('input is not num or model', () {
        expect(
            () => UserMariaDBStore.del('1'),
            throwsA(predicate((e) => e is IStoreException && e.code == 21034))
        );

        User user = new User(new List.filled(orm[0]['column'].length, 1));
        expect(
            () => RoomMariaDBStore.del(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21034))
        );
      });

      test('input is num del successfully', () {
        UserMariaDBStore.del(1)
        .then(expectAsync1((affectedRows) {
          expect(affectedRows, equals(1));
        }));
      });

      tearDown(() {
        endTimestamp = new DateTime.now().millisecondsSinceEpoch;
        print('cost ${endTimestamp - startTimestamp} ms');
      });

      test('input is model del successfully', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        UserMariaDBStore.add(user)
        .then((_) => UserMariaDBStore.del(user))
        .then(expectAsync1((affectedRows) {
          expect(affectedRows, equals(1));
        }));
      });

    });
  });
}
