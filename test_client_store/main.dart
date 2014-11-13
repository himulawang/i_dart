import 'dart:html';
import 'dart:indexed_db';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:i_dart/i_dart_clt.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'lib_test_client_store.dart';

void main() {
  useHtmlEnhancedConfiguration();

  Logger.root.level = Level.ALL;
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
  group('idb model store', () {

    group('add', () {
      setUp(() => flushdb());

      test('pk is null should throw exception', () {
        UserSingle us = new UserSingle();
        expect(
                () => UserSingleIndexedDBStore.add(us),
            throwsA(predicate((e) => e is IStoreException && e.code == 30006))
        );
      });

      setUp(() {});

      test('toAddAbb return list length is 0 should throw exception', () {
        UserSingleToAddLengthZero user = new UserSingleToAddLengthZero(new List.filled(orm['UserSingleToAddLengthZero']['Model']['column'].length, 1));
        expect(
                () => UserSingleToAddLengthZeroIndexedDBStore.add(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 30005))
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
        .catchError(expectAsync((e) {
          expect(e is IStoreException, isTrue);
          expect(e.code == 30007, isTrue);
        }));
      });

      test('multiple pk: pk contains null should throw exception', () {
        UserMulti um = new UserMulti();
        expect(
                () => UserMultiIndexedDBStore.add(um),
            throwsA(predicate((e) => e is IStoreException && e.code == 30006))
        );
      });

      test('multiple pk: add successfully', () {
        UserMulti um = new UserMulti(new List.filled(orm['UserMulti']['Model']['column'].length, 1));
        expect(
                () => UserMultiIndexedDBStore.add(um),
            returnsNormally
        );
      });

    });

    group('set', () {
      test('pk is null should throw exception', () {
        UserSingle us = new UserSingle();
        us.name = 'a';
        expect(
                () => UserSingleIndexedDBStore.set(us),
            throwsA(predicate((e) => e is IStoreException && e.code == 30006))
        );
      });

      test('toSetAbb return list length is 0 should throw exception', () {
        UserSingleToSetLengthZero user = new UserSingleToSetLengthZero(new List.filled(orm['UserSingleToSetLengthZero']['Model']['column'].length, 1));
        user.uniqueName = 'a';
        expect(
                () => UserSingleToSetLengthZeroIndexedDBStore.set(user),
            throwsA(predicate((e) => e is IStoreException && e.code == 30009))
        );
      });

      test('set successfully', () {
        UserSingle user = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 1));
        user.name = 'a';
        user.uniqueName = 'b';

        UserSingleIndexedDBStore.set(user)
        .then((UserSingle userSingle) {
          expect(identical(userSingle, user), isTrue);
          expect(user.isUpdated(), isFalse);
        });
      });

      test('model has no attribute to set, should get warning', () {
        UserSingle user = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 1));

        UserSingleIndexedDBStore.set(user)
        .then((UserSingle userSingle) {
          expect(identical(userSingle, user), isTrue);
          expect(user.isUpdated(), isFalse);
        });
      });

      test('multiple pk: pk contains null should throw exception', () {
        UserMulti um = new UserMulti();
        um.name = 'a';
        expect(
                () => UserMultiIndexedDBStore.set(um),
            throwsA(predicate((e) => e is IStoreException && e.code == 30006))
        );
      });

      test('multiple pk: set successfully', () {
        UserMulti um = new UserMulti(new List.filled(orm['UserMulti']['Model']['column'].length, 1));
        um.name = 'a';
        um.uniqueName = 'b';
        expect(
                () => UserMultiIndexedDBStore.set(um),
            returnsNormally
        );
      });

    });

    group('get', () {

      test('get successfully', () {
        UserSingleIndexedDBStore.get(1)
        .then(expectAsync((UserSingle user) {
          expect(user.isExist(), isTrue);
          expect(user.id, equals(1));
          expect(user.name, equals('a'));
          expect(user.uniqueName, equals('b'));
        }));
      });

      test('model does not exist in indexedDB return model', () {
        UserSingleIndexedDBStore.get(2)
        .then(expectAsync((UserSingle user) {
          expect(user.isExist(), isFalse);
          expect(user.id, equals(2));
        }));
      });

      test('multiple pk: get child successfully', () {
        UserMultiIndexedDBStore.get(1, 'a', 'b')
        .then(expectAsync((UserMulti user) {
          expect(user.isExist(), isTrue);
          expect(user.id, equals(1));
          expect(user.name, equals('a'));
          expect(user.uniqueName, equals('b'));
        }));
      });

    });

    group('del', () {

      test('del successfully', () {
        UserSingle user = new UserSingle(new List.filled(orm['UserSingle']['Model']['column'].length, 1));
        UserSingleIndexedDBStore.del(user).then((_) {
          return UserSingleIndexedDBStore.get(1);
        }).then(expectAsync((UserSingle u) {
          expect(u.isExist(), isFalse);
        }));
      });

      test('multiple pk: del successfully', () {
        UserMultiIndexedDBStore.get(1, 'a', 'b')
        .then((UserMulti u) {
          return UserMultiIndexedDBStore.del(u);
        })
        .then((_) {
          return UserMultiIndexedDBStore.get(1, 'a', 'b');
        }).then(expectAsync((UserMulti u) {
          expect(u.isExist(), isFalse);
        }));
      });

    });

  });

  group('idb pk store', () {

    group('set', () {

      test('set unchanged pk should get warning', () {
        UserSinglePK pk = new UserSinglePK();

        expect(
            () => UserSinglePKIndexedDBStore.set(pk),
            returnsNormally
        );
      });

      test('set successfully', () {
        UserSinglePK pk = new UserSinglePK();
        pk.incr();

        UserSinglePKIndexedDBStore.set(pk)
        .then(expectAsync((UserSinglePK pkNew) {
          expect(pkNew.isUpdated(), isFalse);
          expect(identical(pk, pkNew), isTrue);
          return UserSinglePKIndexedDBStore.get();
        }))
        .then(expectAsync((UserSinglePK pkCheck) {
          expect(pkCheck.isUpdated(), isFalse);
          expect(pkCheck.get(), equals(1));
        }));
      });

    });

    group('get', () {

      test('pk not exist should get pk with value 0', () {
        UserMultiPKIndexedDBStore.get()
        .then(expectAsync((UserMultiPK pk) {
          expect(pk.get(), isZero);
        }));
      });

      test('get successfully', () {
        UserSinglePKIndexedDBStore.get()
        .then(expectAsync((UserSinglePK pk) {
          expect(pk.isUpdated(), isFalse);
          expect(pk.get(), equals(1));
        }));
      });

    });

    group('del', () {

      test('del successfully', () {

        UserSinglePKIndexedDBStore.del()
        .then(expectAsync((_) => UserSinglePKIndexedDBStore.get()))
        .then(expectAsync((UserSinglePK pk) {
          expect(pk.get(), isZero);
        }));

      });

    });

  });

  group('idb list store', () {

    group('set', () {

      test('set not changed list should get warning', () {
        SingleList list = new SingleList(1);
        Future ft = SingleListIndexedDBStore.set(list);

        expect(ft is Future, isTrue);
      });

      test('add 2 children successfully', () {
        Single s1 = new Single(new List.filled(orm['Single']['Model']['column'].length, 1));
        Single s2 = new Single(new List.filled(orm['Single']['Model']['column'].length, 2));
        s2.id = 1;
        SingleList list = new SingleList(1);
        list..add(s1)..add(s2);

        SingleListIndexedDBStore.set(list)
        .then(expectAsync((SingleList newList) {
          expect(newList.getToAddList().length, isZero);
        }));
      });

      test('set successfully', () {
        Single s1 = new Single(new List.filled(orm['Single']['Model']['column'].length, 1));
        SingleList list = new SingleList.filledList(1, [s1]);

        s1.uniqueName = 'a';
        list.set(s1);

        SingleListIndexedDBStore.set(list)
        .then(expectAsync((SingleList newList) {
          expect(newList.getToSetList().length, isZero);
        }));
      });

      test('del successfully', () {
        Single s1 = new Single(new List.filled(orm['Single']['Model']['column'].length, 1));
        SingleList list = new SingleList.filledList(1, [s1]);

        list.del(s1);

        SingleListIndexedDBStore.set(list)
        .then(expectAsync((SingleList newList) {
          expect(newList.getToDelList().length, isZero);
        }));
      });

      test('multiple pk: add 2 children successfully', () {
        Multiple m1 = new Multiple();
        m1..id = 1
          ..name = 'a'
          ..gender = 1
          ..uniqueName = 1
          ..value = 'c';
        Multiple m2 = new Multiple();
        m2..id = 1
          ..name = 'a'
          ..gender = 2
          ..uniqueName = 2
          ..value = 'c';

        MultipleList list = new MultipleList(1, 'a');
        list..add(m1)..add(m2);

        MultipleListIndexedDBStore.set(list)
        .then(expectAsync((MultipleList newList) {
          expect(newList.getToAddList().length, isZero);
        }));
      });

      test('multiple pk: set children successfully', () {
        MultipleListIndexedDBStore.get(1, 'a')
        .then(expectAsync((MultipleList list) {
          Multiple m = list.get(2, 2);
          m.value = 'changed';
          list.set(m);
          return MultipleListIndexedDBStore.set(list);
        }))
        .then(expectAsync((MultipleList list) {
          Multiple m = list.get(2, 2);
          expect(m.value, equals('changed'));
        }));
      });

      test('multiple pk: del children successfully', () {
        MultipleListIndexedDBStore.get(1, 'a')
        .then(expectAsync((MultipleList list) {
          Multiple m = list.get(2, 2);
          list.del(m);
          return MultipleListIndexedDBStore.set(list);
        }))
        .then(expectAsync((MultipleList list) {
          expect(list.length, equals(1));
        }));
      });
    });

    group('get', () {

      test('get successfully', () {
        SingleListIndexedDBStore.get(1)
        .then(expectAsync((SingleList list) {
          expect(list.length, equals(1));
          Single s2 = list.get(2);
          expect(s2.name, equals(2));
        }));
      });

      test('get not exist list should return empty list', () {
        SingleListIndexedDBStore.get(2)
        .then(expectAsync((SingleList list) {
          expect(list.length, equals(0));
        }));
      });

      test('multiple pk: get successfully', () {
        MultipleListIndexedDBStore.get(1, 'a')
        .then(expectAsync((MultipleList list) {
          expect(list.length, equals(1));
        }));
      });

    });

    group('del', () {

      test('del successfully', () {
        SingleListIndexedDBStore.get(1)
        .then(expectAsync((SingleList list) {
          return SingleListIndexedDBStore.del(list);
        }))
        .then(expectAsync((_) {
          return SingleListIndexedDBStore.get(1);
        }))
        .then(expectAsync((SingleList list) {
          expect(list.length, isZero);
        }));
      });

      test('multiple pk: del successfully', () {
        MultipleListIndexedDBStore.get(1, 'a')
        .then(expectAsync((MultipleList list) {
          return MultipleListIndexedDBStore.del(list);
        }))
        .then(expectAsync((_) {
          return MultipleListIndexedDBStore.get(1, 'a');
        }))
        .then(expectAsync((MultipleList list) {
          expect(list.length, isZero);
        }));
      });

    });

  });
}

Future flushdb() {
  List waitList = [];
  Database db = IIndexedDBHandlerPool.dbs['GameIDB'];

  waitList
    ..add(clearTable(db, 'SingleList'))
    ..add(clearTable(db, 'MultipleList'))
    ..add(clearTable(db, 'UserMultiple'))
    ..add(clearTable(db, 'UserSingle'))
    ..add(clearTable(db, 'PK'));

  return Future.wait(waitList);
}

Future clearTable(Database db, String storeName) {
  Transaction tran = db.transaction(storeName, 'readwrite');
  ObjectStore store = tran.objectStore(storeName);
  return store.clear();
}
