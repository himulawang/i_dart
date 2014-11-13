import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:sqljocky/sqljocky.dart';
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

  IMariaDBHandlerPool pool = new IMariaDBHandlerPool()..init(store['mariaDB']);
  flushdb().then((_) => startTest());
}

Future flushdb() {
  // flushdb
  List waitList = [];
  IMariaDBHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((ConnectionPool pool) {
      waitList.add(
          pool.query('TRUNCATE TABLE `PK`;')
      );
    });
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test pk mdb store', () {

    group('set', () {

      setUp(() => flushdb());

      test('set successfully', () {
        UserPK pk = new UserPK();
        pk.incr();
        pk.incr();
        pk.incr();
        UserPKMariaDBStore.set(pk)
        .then(expectAsync((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
        }));
      });

      setUp(() {});

      test('set unchanged pk should do nothing', () {
        UserPK pk = new UserPK();
        UserPKMariaDBStore.set(pk)
        .then(expectAsync((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
        }));
      });

    });

    group('get', () {

      test('get successfully', () {
        UserPKMariaDBStore.get()
        .then(expectAsync((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(3));
        }));
      });

      test('pk not exist should get pk with value 0', () {
        RoomPKMariaDBStore.get()
        .then(expectAsync((RoomPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(0));
        }));
      });

    });

    group('del', () {

      test('del successfully', () {
        UserPK pk = new UserPK();
        UserPKMariaDBStore.del(pk)
        .then((_) => UserPKMariaDBStore.get())
        .then(expectAsync((UserPK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(0));
        }));
      });

      test('del pk not exist should get warning', () {
        UserPK pk = new UserPK();
        UserPKMariaDBStore.del(pk)
        .then(expectAsync((bool result) {
          expect(result, isFalse);
        }));
      });

    });

  });
}
