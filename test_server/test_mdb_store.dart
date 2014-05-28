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

DROP TABLE IF EXISTS `UserMulti`;
CREATE TABLE IF NOT EXISTS `UserMulti` (
  `id` bigint(20) NOT NULL,
  `name` varchar(16) NOT NULL,
  `gender` int(11) NOT NULL,
  `uniqueName` varchar(12) NOT NULL,
  PRIMARY KEY (`id`, `name`, `uniquename`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `UserSingle`;
CREATE TABLE IF NOT EXISTS `UserSingle` (
  `id` bigint(20) NOT NULL,
  `name` varchar(16) NOT NULL,
  `userName` varchar(32) NOT NULL,
  `uniqueName` varchar(32) NOT NULL,
  PRIMARY KEY (`id`, `name`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `Multiple`;
CREATE TABLE IF NOT EXISTS `Multiple` (
  `id` bigint(20) NOT NULL,
  `name` varchar(16) NOT NULL,
  `gender` int(11) NOT NULL,
  `uniqueName` varchar(32) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`, `name`, `gender`, `uniqueName`)
) ENGINE=InnoDB;

 */
import 'dart:async';
import 'dart:convert';

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
      waitList.add(
        pool.query('TRUNCATE TABLE `UserMulti`;')
      );
    });
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test mdb store', () {

    group('store', () {
      test('should equal store in store.dart', () {
        expect(UserMariaDBStore.store, equals(orm['User']['ModelStore']['storeOrder'][1]));
      });
    });

    group('table', () {
      test('should equal table in orm.dart', () {
        expect(UserMariaDBStore.table, equals(orm['User']['ModelStore']['storeOrder'][1]['table']));
      });
    });

    group('add', () {
      test('model is invalid', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        expect(
            () => RoomMariaDBStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21023))
        );
      });

      test('pk is null should throw exception', () {
        User user = new User();
        expect(
            () => UserMariaDBStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21024))
        );
      });

      test('toAddAbb return list length is 0 should throw exception', () {
        UserToAddLengthZero user = new UserToAddLengthZero(new List.filled(orm['UserToAddLengthZero']['Model']['column'].length, 1));
        expect(
            () => UserToAddLengthZeroMariaDBStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21035))
        );
      });

      test('add successfully', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1))
        ..name = '2';
        UserMariaDBStore.add(user)
        .then(expectAsync((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('add duplicated pk model should throw exception', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        UserMariaDBStore.add(user)
        .catchError(expectAsync((e) {
          expect(e is IStoreException, isTrue);
          expect(e.code, equals(21028));
        }));
      });

      test('multiple pk: pk contains null should throw exception', () {
        UserMulti um = new UserMulti();
        expect(
            () => UserMultiMariaDBStore.add(um),
            throwsA(predicate((e) => e is IStoreException && e.code == 21024))
        );
      });

      test('multiple pk: add successfully', () {
        UserMulti um = new UserMulti()
          ..id = 1
          ..name = '2'
          ..gender = 2
          ..uniqueName = 'aaa'
          ;
        UserMultiMariaDBStore.add(um)
        .then(expectAsync((UserMulti userMulti) {
          expect(userMulti is UserMulti, isTrue);
        }));
      });

    });

    group('set', () {

      test('model is invalid', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        expect(
            () => RoomMariaDBStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21026))
        );
      });

      test('pk is null should throw exception', () {
        User user = new User()..name = 2;
        expect(
            () => UserMariaDBStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21027))
        );
      });

      test('toSetAbb return list length is 0 should get warning', () {
        UserToSetLengthZero user = new UserToSetLengthZero(new List.filled(orm['UserToSetLengthZero']['Model']['column'].length, 1));
        user.name = '3';
        UserToSetLengthZeroMariaDBStore.set(user)
        .then(expectAsync((UserToSetLengthZero user) {
          expect(user is UserToSetLengthZero, isTrue);
        }));
      });

      test('no record affected should get warning', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 2));
        user..name = 'b'
            ..underworldName = 'c';
        UserMariaDBStore.set(user)
        .then(expectAsync((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('set successfully', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        user..name = 'b'
            ..underworldName = 'c';
        UserMariaDBStore.set(user)
        .then(expectAsync((User user) {
          expect(user is User, isTrue);
        }));
      });

      test('multiple pk: pk contains null should throw exception', () {
        UserMulti um = new UserMulti();
        um.id = 1;
        expect(
            () => UserMultiMariaDBStore.set(um),
            throwsA(predicate((e) => e is IStoreException && e.code == 21027))
        );
      });

      test('multiple pk: set successfully', () {
        UserMulti um = new UserMulti()
          ..id = 1
          ..name = '2'
          ..gender = 3
          ..uniqueName = 'aaa'
        ;
        UserMultiMariaDBStore.set(um)
        .then(expectAsync((UserMulti userMulti) {
          expect(userMulti is UserMulti, isTrue);
        }));
      });

    });

    group('get', () {

      test('model not exist in mdb should return model with !isExist', () {
        UserMariaDBStore.get(9)
        .then(expectAsync((User user) {
          expect(user.isExist(), equals(false));
        }));
      });

      test('get model successfully', () {
        UserMariaDBStore.get(1)
        .then(expectAsync((User user) {
          expect(user.isExist(), equals(true));
          expect(user.name, equals('b'));
        }));
      });

      test('multiple pk: get model successfully', () {
        UserMultiMariaDBStore.get(1, '2', 'aaa')
        .then(expectAsync((UserMulti um) {
          expect(um.isExist(), equals(true));
          expect(um.name, equals('2'));
        }));
      });

    });

    group('del', () {

      test('input model invalid', () {
        expect(
            () => UserMariaDBStore.del([]),
            throwsA(predicate((e) => e is IStoreException && e.code == 21034))
        );

        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        expect(
            () => RoomMariaDBStore.del(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 21034))
        );
      });

      test('del successfully', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        UserMariaDBStore.del(user)
        .then(expectAsync((affectedRows) {
          expect(affectedRows, equals(1));
        }));
      });

      tearDown(() {
        endTimestamp = new DateTime.now().millisecondsSinceEpoch;
        print('cost ${endTimestamp - startTimestamp} ms');
      });

      test('multiple pk: del successfully', () {
        UserMulti um = new UserMulti()
          ..id = 1
          ..name = 2
          ..gender = 3
          ..uniqueName = 'aaa'
        ;
        UserMultiMariaDBStore.del(um)
        .then(expectAsync((affectedRows) {
          expect(affectedRows, equals(1));
        }));
      });

    });
  });
}
