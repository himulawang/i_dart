import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';

import 'lib_test.dart';
import 'i_config/store.dart';
import 'i_config/orm.dart';

void main() {
  num startTimestamp;
  num endTimestamp;
  startTimestamp = new DateTime.now().millisecondsSinceEpoch;

  group('Test IMariaDBSQLPrepare', () {
    group('makeAdd', () {
      test('toAddMap length is 0 throw exception', () {
        UserToAddLengthZero u = new UserToAddLengthZero(new List.filled(2, 1));
        expect(() => IMariaDBSQLPrepare.makeAdd(u), throwsA(predicate((e) => e is IStoreException && e.code == 21030)));
      });

      test('return the right SQL', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        String eSQL = 'INSERT INTO `User` (`id`, `name`, `userName`, `uniqueName`, `underworldName`, `underworldName1`, `underworldName2`, `thisIsABitLongerAttribute`, `testSetFilterColumn1`, `testSetFilterColumn2`, `testFullFilterColumn1`, `testFullFilterColumn2`, `testAbbFilterColumn1`, `testAbbFilterColumn2`, `testListFilterColumn1`, `testListFilterColumn2`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);';
        expect(IMariaDBSQLPrepare.makeAdd(user), equals(eSQL));
      });
    });
  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
