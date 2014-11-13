import 'package:unittest/unittest.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_test_server_store.dart';

void main() {
  num startTimestamp;
  num endTimestamp;
  startTimestamp = new DateTime.now().millisecondsSinceEpoch;

  group('Test IMariaDBSQLPrepare', () {
    group('makeAdd', () {
      test('toAddMap length is 0 throw exception', () {
        UserToAddLengthZero u = new UserToAddLengthZero(new List.filled(2, 1));
        expect(() => IMariaDBSQLPrepare.makeAdd(UserToAddLengthZeroMariaDBStore.table, u.getMapFull(), u.getColumns()), throwsA(predicate((e) => e is IStoreException && e.code == 21030)));
      });

      test('return the right SQL', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        String eSQL = 'INSERT INTO `User` (`id`, `name`, `userName`, `uniqueName`, `underworldName`, `underworldName1`, `underworldName2`, `thisIsABitLongerAttribute`, `testSetFilterColumn1`, `testSetFilterColumn2`, `testFullFilterColumn1`, `testFullFilterColumn2`, `testAbbFilterColumn1`, `testAbbFilterColumn2`, `testListFilterColumn1`, `testListFilterColumn2`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);';
        expect(IMariaDBSQLPrepare.makeAdd(UserMariaDBStore.table, user.getMapFull(), user.getColumns()), equals(eSQL));
      });
    });

    group('makeSet', () {
      test('toSetMap length is 0 throw exception', () {
        UserToSetLengthZero u = new UserToSetLengthZero(new List.filled(2, 1));
        expect(() => IMariaDBSQLPrepare.makeSet(UserToSetLengthZeroMariaDBStore.table, u), throwsA(predicate((e) => e is IStoreException && e.code == 21031)));
      });

      test('return the right SQL', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        user.name = 'ila';
        user.userName = 'ParaNoidz';
        user.testSetFilterColumn1 = 2;
        user.testSetFilterColumn2 = 3;
        String eSQL = 'UPDATE `User` SET `name` = ?, `userName` = ? WHERE `id` = ?;';
        expect(IMariaDBSQLPrepare.makeSet(UserMariaDBStore.table, user), equals(eSQL));
      });
    });

    group('makeGet', () {
      test('return the right SQL', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        expect(IMariaDBSQLPrepare.makeGet(UserMariaDBStore.table, user), equals('SELECT `id`, `name`, `userName`, `uniqueName`, `underworldName`, `underworldName1`, `underworldName2`, `thisIsABitLongerAttribute`, `testAddFilterColumn1`, `testAddFilterColumn2`, `testSetFilterColumn1`, `testSetFilterColumn2`, `testFullFilterColumn1`, `testFullFilterColumn2`, `testAbbFilterColumn1`, `testAbbFilterColumn2`, `testListFilterColumn1`, `testListFilterColumn2` FROM `User` WHERE `id` = ?;'));
      });
    });

    group('makeDel', () {

      test('return the right SQL', () {
        User user = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        expect(IMariaDBSQLPrepare.makeDel(UserMariaDBStore.table, user), equals('DELETE FROM `User` WHERE `id` = ?;'));
      });

    });

    group('makeListGet', () {

      test('return the right SQL', () {
        UserSingle u = new UserSingle(new List.filled(4, 1));
        expect(IMariaDBSQLPrepare.makeListGet(UserSingleListMariaDBStore.table, u), equals('SELECT `id`, `name`, `userName`, `uniqueName` FROM `UserSingle` WHERE `id` = ?'));
      });

      test('multiple pk: return the right SQL', () {
        Multiple m = new Multiple(new List.filled(5, 1));
        expect(IMariaDBSQLPrepare.makeListGet(MultipleListMariaDBStore.table, m), equals('SELECT `id`, `name`, `gender`, `uniqueName`, `value` FROM `Multiple` WHERE `id` = ? AND `name` = ?'));
      });
    });

  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
