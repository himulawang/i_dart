import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_test_model.dart';
import 'i_config/orm.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  num startTimestamp;
  num endTimestamp;
  startTimestamp = new DateTime.now().millisecondsSinceEpoch;

  group('Test Model', () {
    group('constructor', () {
      test('no argument input', () {
        User u = new User();
        expect(u.toFixedList(), equals(new List.filled(orm['User']['Model']['column'].length, null)));
      });

      test('input argument with wrong length', () {
        expect(
            () => new User([1, 2, 3]),
            throwsA(predicate((e) => e is IModelException && e.code == 10009))
        );
      });

      test('construct with right parameters', () {
        expect(
            () => new User(new List.filled(orm['User']['Model']['column'].length, 1)),
            returnsNormally
        );
      });
    });

    group('getName', () {
      test('should equal name in orm.dart', () {
        User user = new User();
        expect(user.getName(), equals('User'));
      });
    });

    group('getColumnCount', () {
      test('should equal column length in orm.dart', () {
        User user = new User();
        expect(user.getColumnCount(), equals(orm['User']['Model']['column'].length));
      });
    });

    group('getColumns', () {
      test('should equal column create from IModelMaker', () {
        User u = new User();
        expect(u.getColumns(), equals(
          [
            {
                'i': 0,
                'full': 'id',
                'abb': 'i',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 1,
                'full': 'name',
                'abb': 'n',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 2,
                'full': 'userName',
                'abb': 'un',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 3,
                'full': 'uniqueName',
                'abb': 'un1',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 4,
                'full': 'underworldName',
                'abb': 'un2',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 5,
                'full': 'underworldName1',
                'abb': 'un3',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 6,
                'full': 'underworldName2',
                'abb': 'un4',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 7,
                'full': 'thisIsABitLongerAttribute',
                'abb': 'tiabla',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 8,
                'full': 'testAddFilterColumn1',
                'abb': 'tafc1',
                'toAdd': true,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 9,
                'full': 'testAddFilterColumn2',
                'abb': 'tafc2',
                'toAdd': true,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 10,
                'full': 'testSetFilterColumn1',
                'abb': 'tsfc1',
                'toAdd': false,
                'toSet': true,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 11,
                'full': 'testSetFilterColumn2',
                'abb': 'tsfc2',
                'toAdd': false,
                'toSet': true,
                'toAbb': false,
                'toFull': false,
                'toList': false
            },
            {
                'i': 12,
                'full': 'testFullFilterColumn1',
                'abb': 'tffc1',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': true,
                'toList': false
            },
            {
                'i': 13,
                'full': 'testFullFilterColumn2',
                'abb': 'tffc2',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': true,
                'toList': false
            },
            {
                'i': 14,
                'full': 'testAbbFilterColumn1',
                'abb': 'tafc3',
                'toAdd': false,
                'toSet': false,
                'toAbb': true,
                'toFull': false,
                'toList': false
            },
            {
                'i': 15,
                'full': 'testAbbFilterColumn2',
                'abb': 'tafc4',
                'toAdd': false,
                'toSet': false,
                'toAbb': true,
                'toFull': false,
                'toList': false
            },
            {
                'i': 16,
                'full': 'testListFilterColumn1',
                'abb': 'tlfc1',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': true
            },
            {
                'i': 17,
                'full': 'testListFilterColumn2',
                'abb': 'tlfc2',
                'toAdd': false,
                'toSet': false,
                'toAbb': false,
                'toFull': false,
                'toList': true
            }
          ]
        ));
      });
    });

    group('getMapAbb', () {
      test('should equal abb create from IModelMaker', () {
        User u = new User();
        expect(u.getMapAbb(), equals({
            'i': 0,
            'n': 1,
            'un': 2,
            'un1': 3,
            'un2': 4,
            'un3': 5,
            'un4': 6,
            'tiabla': 7,
            'tafc1': 8,
            'tafc2': 9,
            'tsfc1': 10,
            'tsfc2': 11,
            'tffc1': 12,
            'tffc2': 13,
            'tafc3': 14,
            'tafc4': 15,
            'tlfc1': 16,
            'tlfc2': 17
        }));
      });
    });

    group('getMapFull', () {
      test('should equal abb create from IModelMaker', () {
        User u = new User();
        expect(u.getMapFull(), equals( {
          'id': 0,
          'name': 1,
          'userName': 2,
          'uniqueName': 3,
          'underworldName': 4,
          'underworldName1': 5,
          'underworldName2': 6,
          'thisIsABitLongerAttribute': 7,
          'testAddFilterColumn1': 8,
          'testAddFilterColumn2': 9,
          'testSetFilterColumn1': 10,
          'testSetFilterColumn2': 11,
          'testFullFilterColumn1': 12,
          'testFullFilterColumn2': 13,
          'testAbbFilterColumn1': 14,
          'testAbbFilterColumn2': 15,
          'testListFilterColumn1': 16,
          'testListFilterColumn2': 17
        }));
      });
    });

    group('setter & getter', () {
      test('set to undefined attribute', () {
        User u = new User();
        expect(
            () => u.ids = 1,
            throwsA(predicate((e) => e is NoSuchMethodError)));
      });

      test('set & get success', () {
        User u = new User();
        num value = 128;
        u.id = value;
        expect(u.id, equals(value));
      });
    });

    group('setExist & isExist', () {
      test('default isExist value should be false', () {
        User u = new User();
        expect(u.isExist(), equals(false));
      });

      test('setExist with default value', () {
        User u = new User();
        u.setExist();
        expect(u.isExist(), equals(true));
      });

      test('setExist with false value', () {
        User u = new User();
        u.setExist(false);
        expect(u.isExist(), equals(false));
      });
    });

    group('setPK & getPK', () {
      test('default PK should be null', () {
        User u = new User();
        expect(u.getPK(), equals(null));
      });

      test('setPK & getPK single success', () {
        User u = new User();
        num value = 209;
        u.setPK(value);
        expect(u.getPK(), equals(value));
      });

      test('use getter id get value should equal pk', () {
        User u = new User();
        num value = 209;
        u.setPK(value);
        expect(u.id, equals(value));
      });

      test('setPK & getPK multiple success', () {
        UserMulti u = new UserMulti();
        u.setPK(1, 'name', 'uniqueName');
        expect(u.getPK(), equals([1, 'name', 'uniqueName']));
        expect(u.id, equals(1));
        expect(u.name, equals('name'));
        expect(u.uniqueName, equals('uniqueName'));
      });
    });

    group('isUpdated', () {
      test('default isUpdated should be false', () {
        User u = new User();
        expect(u.isUpdated(), equals(false));
      });

      test('any attribute changes, isUpdated should be true', () {
        User u1 = new User();
        u1.id = 1;
        expect(u1.isUpdated(), equals(true));
        u1.name = 'ila';
        expect(u1.isUpdated(), equals(true));

        User u2 = new User();
        u2.name = 'ila';
        expect(u2.isUpdated(), equals(true));
      });
    });

    group('setUpdatedList', () {
      test('setUpdatedList to true', () {
        User u = new User();
        u.setUpdatedList(true);
        expect(u.isUpdated(), equals(true));
      });

      test('setUpdatedList to false', () {
        User u = new User();
        u.setUpdatedList(true);
        u.setUpdatedList(false);
        expect(u.isUpdated(), equals(false));
      });
    });

    group('toAddFixedList', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toAddFixedList();
        expect(r, equals(new List.filled(orm['User']['Model']['column'].length, 1)));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toAddFixedList(true);
        List expectR = new List.filled(orm['User']['Model']['column'].length, 1);
        expectR[8] = null;
        expectR[9] = null;
        expect(r, equals(expectR));
      });

      test('length of return list should not be changed', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toAddFixedList();
        expect(
          () => r.add(1),
          throwsA(new isInstanceOf<UnsupportedError>())
        );
      });
    });

    group('toAddList', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toAddList();
        expect(r, equals(new List.filled(orm['User']['Model']['column'].length, 1)));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toAddList(true);
        List expectR = new List.filled(orm['User']['Model']['column'].length - 2, 1);
        expect(r, equals(expectR));
      });

      test('length of return list can be changed', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toAddList();
        expect(() => r.add(1), returnsNormally);
      });
    });

    group('toAddFull', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        Map r = u.toAddFull();
        Map e = {
            'id': 1,
            'name': 1,
            'userName': 1,
            'uniqueName': 1,
            'underworldName': 1,
            'underworldName1': 1,
            'underworldName2': 1,
            'thisIsABitLongerAttribute': 1,
            'testAddFilterColumn1': 1,
            'testAddFilterColumn2': 1,
            'testSetFilterColumn1': 1,
            'testSetFilterColumn2': 1,
            'testFullFilterColumn1': 1,
            'testFullFilterColumn2': 1,
            'testAbbFilterColumn1': 1,
            'testAbbFilterColumn2': 1,
            'testListFilterColumn1': 1,
            'testListFilterColumn2': 1,
        };
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        Map r = u.toAddFull(true);
        Map e = {
            'id': 1,
            'name': 1,
            'userName': 1,
            'uniqueName': 1,
            'underworldName': 1,
            'underworldName1': 1,
            'underworldName2': 1,
            'thisIsABitLongerAttribute': 1,
            'testSetFilterColumn1': 1,
            'testSetFilterColumn2': 1,
            'testFullFilterColumn1': 1,
            'testFullFilterColumn2': 1,
            'testAbbFilterColumn1': 1,
            'testAbbFilterColumn2': 1,
            'testListFilterColumn1': 1,
            'testListFilterColumn2': 1
        };
        expect(r, equals(e));
      });
    });

    group('toAddAbb', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        Map r = u.toAddAbb();
        Map e = {
            'i': 1,
            'n': 1,
            'un': 1,
            'un1': 1,
            'un2': 1,
            'un3': 1,
            'un4': 1,
            'tiabla': 1,
            'tafc1': 1,
            'tafc2': 1,
            'tsfc1': 1,
            'tsfc2': 1,
            'tffc1': 1,
            'tffc2': 1,
            'tafc3': 1,
            'tafc4': 1,
            'tlfc1': 1,
            'tlfc2': 1
        };
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        Map r = u.toAddAbb(true);
        Map e = {
            'i': 1,
            'n': 1,
            'un': 1,
            'un1': 1,
            'un2': 1,
            'un3': 1,
            'un4': 1,
            'tiabla': 1,
            'tsfc1': 1,
            'tsfc2': 1,
            'tffc1': 1,
            'tffc2': 1,
            'tafc3': 1,
            'tafc4': 1,
            'tlfc1': 1,
            'tlfc2': 1
        };
        expect(r, equals(e));
      });
    });

    group('toSetFixedList', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        u.testSetFilterColumn2 = 'd';
        List r = u.toSetFixedList();

        List e =  new List.filled(orm['User']['Model']['column'].length, null);
        e[1] = 'a';
        e[2] = 'b';
        e[10] = 'c';
        e[11] = 'd';
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        u.testSetFilterColumn2 = 'd';
        List r = u.toSetFixedList(true);

        List e = new List.filled(orm['User']['Model']['column'].length, null);
        e[1] = 'a';
        e[2] = 'b';
        expect(r, equals(e));
      });

      test('length of return list should not be changed', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        List r = u.toSetFixedList();
        expect(() => r.add(1), throwsA(new isInstanceOf<UnsupportedError>()));
      });
    });

    group('toSetList', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        u.testSetFilterColumn2 = 'd';
        List r = u.toSetList();

        List e = ['a', 'b', 'c', 'd'];
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        u.testSetFilterColumn2 = 'd';
        List r = u.toSetList(true);

        List e = ['a', 'b'];
        expect(r, equals(e));
      });

      test('length of return list can be changed', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        List r = u.toSetList();
        expect(() => r.add(1), returnsNormally);
      });
    });

    group('toSetFull', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        u.testSetFilterColumn2 = 'd';
        Map r = u.toSetFull();
        Map e = {
            'name': 'a',
            'userName': 'b',
            'testSetFilterColumn1': 'c',
            'testSetFilterColumn2': 'd',
        };
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        u.testSetFilterColumn2 = 'd';
        Map r = u.toSetFull(true);
        Map e = {
            'name': 'a',
            'userName': 'b',
        };
        expect(r, equals(e));
      });
    });

    group('toSetAbb', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        u.testSetFilterColumn2 = 'd';
        Map r = u.toSetAbb();
        Map e = {
            'n': 'a',
            'un': 'b',
            'tsfc1': 'c',
            'tsfc2': 'd',
        };
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        u.name = 'a';
        u.userName = 'b';
        u.testSetFilterColumn1 = 'c';
        u.testSetFilterColumn2 = 'd';
        Map r = u.toSetAbb(true);
        Map e = {
            'n': 'a',
            'un': 'b',
        };
        expect(r, equals(e));
      });
    });

    group('toFixedList', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toFixedList();
        List e = new List.filled(orm['User']['Model']['column'].length, 1);
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toFixedList(true);
        List e = new List.filled(orm['User']['Model']['column'].length, 1);
        e[16] = null;
        e[17] = null;
        expect(r, equals(e));
      });

      test('length of return list should not be changed', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toFixedList();
        expect(() => r.add(1), throwsA(new isInstanceOf<UnsupportedError>()));
      });
    });

    group('toList', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toList();
        List e = new List.filled(orm['User']['Model']['column'].length, 1);
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toList(true);
        List e = new List.filled(orm['User']['Model']['column'].length - 2, 1);
        expect(r, equals(e));
      });

      test('length of return list can be changed', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        List r = u.toList();
        expect(() => r.add(1), returnsNormally);
      });
    });

    group('toFull', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        Map r = u.toFull();
        Map e = {
            'id': 1,
            'name': 1,
            'userName': 1,
            'uniqueName': 1,
            'underworldName': 1,
            'underworldName1': 1,
            'underworldName2': 1,
            'thisIsABitLongerAttribute': 1,
            'testAddFilterColumn1': 1,
            'testAddFilterColumn2': 1,
            'testSetFilterColumn1': 1,
            'testSetFilterColumn2': 1,
            'testFullFilterColumn1': 1,
            'testFullFilterColumn2': 1,
            'testAbbFilterColumn1': 1,
            'testAbbFilterColumn2': 1,
            'testListFilterColumn1': 1,
            'testListFilterColumn2': 1
        };
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        Map r = u.toFull(true);
        Map e = {
            'id': 1,
            'name': 1,
            'userName': 1,
            'uniqueName': 1,
            'underworldName': 1,
            'underworldName1': 1,
            'underworldName2': 1,
            'thisIsABitLongerAttribute': 1,
            'testAddFilterColumn1': 1,
            'testAddFilterColumn2': 1,
            'testSetFilterColumn1': 1,
            'testSetFilterColumn2': 1,
            'testAbbFilterColumn1': 1,
            'testAbbFilterColumn2': 1,
            'testListFilterColumn1': 1,
            'testListFilterColumn2': 1
        };
        expect(r, equals(e));
      });
    });

    group('toAbb', () {
      test('filter off', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        Map r = u.toAbb();
        Map e = {
            'i': 1,
            'n': 1,
            'un': 1,
            'un1': 1,
            'un2': 1,
            'un3': 1,
            'un4': 1,
            'tiabla': 1,
            'tafc1': 1,
            'tafc2': 1,
            'tsfc1': 1,
            'tsfc2': 1,
            'tffc1': 1,
            'tffc2': 1,
            'tafc3': 1,
            'tafc4': 1,
            'tlfc1': 1,
            'tlfc2': 1
        };
        expect(r, equals(e));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm['User']['Model']['column'].length, 1));
        Map r = u.toAbb(true);
        Map e = {
            'i': 1,
            'n': 1,
            'un': 1,
            'un1': 1,
            'un2': 1,
            'un3': 1,
            'un4': 1,
            'tiabla': 1,
            'tafc1': 1,
            'tafc2': 1,
            'tsfc1': 1,
            'tsfc2': 1,
            'tffc1': 1,
            'tffc2': 1,
            'tlfc1': 1,
            'tlfc2': 1
        };
        expect(r, equals(e));
      });
    });

    group('fromList', () {
      test('wrong input data length', () {
        User u = new User();
        List data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
        expect(() => u.fromList(data), throwsA(predicate((e) => e is IModelException && e.code == 10006)));
      });

      test('not change update list', () {
        User u = new User();
        List data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
        u.fromList(data);

        List toList = u.toFixedList();

        expect(toList, equals(data));
        expect(u.isUpdated(), equals(false));
      });

      test('change update list', () {
        User u = new User();
        List data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
        u.fromList(data, true);

        List toList = u.toFixedList();

        expect(toList, equals(data));
        expect(u.isUpdated(), equals(true));
      });
    });

    group('fromFull', () {
      test('not change update list', () {
        User u = new User([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]);
        Map data = {'name': 'name'};
        u.fromFull(data);

        List toList = u.toFixedList();
        List e = [0, 'name', 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

        expect(toList, equals(e));
        expect(u.isUpdated(), equals(false));
      });

      test('change update list', () {
        User u = new User([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]);
        Map data = {'name': 'name'};
        u.fromFull(data, true);

        List toList = u.toFixedList();
        List e = [0, 'name', 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

        expect(toList, equals(e));
        expect(u.isUpdated(), equals(true));
      });
    });

    group('fromAbb', () {
      test('not change update list', () {
        User u = new User([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]);
        Map data = {'n': 'n'};
        u.fromAbb(data);

        List toList = u.toFixedList();
        List e = [0, 'n', 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

        expect(toList, equals(e));
        expect(u.isUpdated(), equals(false));
      });

      test('change update list', () {
        User u = new User([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]);
        Map data = {'n': 'n'};
        u.fromAbb(data, true);

        List toList = u.toFixedList();
        List e = [0, 'n', 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

        expect(toList, equals(e));
        expect(u.isUpdated(), equals(true));
      });
    });

    group('getUnitedPK', () {
      test('single pk get success', () {
        User u = new User();
        u.setPK(1);
        expect(u.getUnitedPK(), equals('1'));
      });

      test('multpile pk get success', () {
        UserMulti u = new UserMulti();
        u.setPK(1, 'aa', 'bb');
        String delimiter = ':';
        expect(u.getUnitedPK(), equals('1${delimiter}aa${delimiter}bb'));
      });

      test('single pk not set should throw exception', () {
        User u = new User();
        expect(() => u.getUnitedPK(), throwsA(predicate((e) => e is IModelException && e.code == 10015)));;
      });

      test('multiple pk not set should throw exception', () {
        UserMulti u = new UserMulti();
        expect(() => u.getUnitedPK(), throwsA(predicate((e) => e is IModelException && e.code == 10016)));;
      });
    });

    group('getUnitedChildPK', () {
      test('single child pk get success', () {
        UserSingle u = new UserSingle();
        u.setPK(1, 'ila');
        expect(u.getUnitedChildPK(), equals('ila'));
      });

      test('multiple child pk get success', () {
        UserMulti u = new UserMulti([1, 2, 'aa', 'bb', 'cc']);
        String delimiter = ':';
        expect(u.getUnitedChildPK(), equals('aa${delimiter}bb'));
      });

      test('single child pk not set should throw exception', () {
        UserSingle u = new UserSingle();
        expect(() => u.getUnitedChildPK(), throwsA(predicate((e) => e is IModelException && e.code == 10018)));;
      });

      test('multiple child pk not set should throw exception', () {
        UserMulti u = new UserMulti();
        expect(() => u.getUnitedChildPK(), throwsA(predicate((e) => e is IModelException && e.code == 10018)));;
      });
    });
  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
