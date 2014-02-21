import 'dart:html';
import 'dart:indexed_db';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'lib_test.dart';
import './i_config/orm.dart';
import './i_config/store.dart';

void main() {
  useHtmlEnhancedConfiguration();

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  IIndexedDBHandlerPool indexedDBPool = new IIndexedDBHandlerPool();
  indexedDBPool.init(store['indexedDB'], idbUpgrade)
  .then((_) {
    startTest();
  });
}

startTest() {
  group('Test idb store', () {

    group('add', () {
      setUp(() => flushdb());

      test('model is invalid', () {
        UserMulti um = new UserMulti(new List.filled(orm['UserMulti']['Model']['column'].length, 1));
        expect(
            () => UserSingleIndexedDBStore.add(um),
            throwsA(predicate((e) => e is IStoreException && e.code == 22004))
        );
      });

      setUp(() {});

      test('pk is null should throw exception', () {
        UserSingle us = new UserSingle();
        expect(
            () => UserSingleIndexedDBStore.add(us),
            throwsA(predicate((e) => e is IStoreException && e.code == 22006))
        );
      });

      test('toAddAbb return list length is 0 should throw exception', () {
        UserSingleToAddLengthZero user = new UserSingleToAddLengthZero(new List.filled(orm['UserSingleToAddLengthZero']['Model']['column'].length, 1));
        expect(
            () => UserSingleToAddLengthZeroIndexedDBStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 22005))
        );
      });

      test('add successfully', () {
        UserSingle user = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 1));
        UserSingleIndexedDBStore.add(user)
        .then((UserSingle userSingle) {
          expect(identical(userSingle, user), isTrue);
        });
      });

      test('model exists should throw exception', () {
        UserSingle user = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 1));
        UserSingleIndexedDBStore.add(user)
        .then((UserSingle userSingle) {
          //expect(identical(userSingle, user), isTrue);
        });
      });

    });

  });
}

Future flushdb() {
  List waitList = [];
  Database db = IIndexedDBHandlerPool.dbs['GameIDB'];

  waitList
    ..add(clearTable(db, 'UserMultiple'))
    ..add(clearTable(db, 'UserSingle'));

  return Future.wait(waitList);
}

Future clearTable(Database db, String storeName) {
  Transaction tran = db.transaction(storeName, 'readwrite');
  ObjectStore store = tran.objectStore(storeName);
  return store.clear();
}
