import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';

import 'lib_test.dart';
import 'i_config/store.dart';
import 'i_config/orm.dart';

void main() {
  group('Test Model', () {
    IRedisHandlerPool redisHandlerPool;
    IMariaDBHandlerPool mariaDBHandlerPool;
    setUp(() {
      // init
      //redisHandlerPool = new IRedisHandlerPool(store['redis']);
      //mariaDBHandlerPool = new IMariaDBHandlerPool(store['mariaDB']);
    });

    group('constructor', () {
      test('no argument input', () {
        User u = new User();
        expect(u.toFixedList(), equals(new List.filled(orm[0]['column'].length, null)));
      });

      test('input argument with wrong type', () {
        expect(
            () => new User({'a': 1}),
            throwsA(predicate((e) => e is IModelException && e.code == 10010))
        );
      });

      test('input argument with wrong length', () {
        expect(
            () => new User([1, 2, 3]),
            throwsA(predicate((e) => e is IModelException && e.code == 10009))
        );
      });

      test('construct with right parameters', () {
        expect(
            () => new User(new List.filled(orm[0]['column'].length, 1)),
            returnsNormally
        );
      });
    });

    group('getRedisStore', () {
      test('should equal store in store.dart', () {
        User u = new User();
        expect(u.getRedisStore(), equals(orm[0]['storeOrder'][0]));
      });
    });

    group('getMariaDBStore', () {
      test('should equal store in store.dart', () {
        User u = new User();
        expect(u.getMariaDBStore(), equals(orm[0]['storeOrder'][1]));
      });
    });

    group('getAbb', () {
      test('should equal abb in orm.dart', () {
        User u = new User();
        expect(u.getAbb(), equals(orm[0]['abb']));
      });
    });

    group('getName', () {
      test('should equal name in orm.dart', () {
        User u = new User();
        expect(u.getName(), equals(orm[0]['name']));
      });
    });

    group('getListName', () {
      test('should equal listName in orm.dart', () {
        User u = new User();
        expect(u.getListName(), equals(orm[0]['listName']));
      });
    });

    group('getPKName', () {
      test('should equal pk in orm.dart', () {
        User u = new User();
        expect(u.getPKName(), equals(orm[0]['column'][orm[0]['pk']]));
      });
    });

    group('getColumnCount', () {
      test('should equal column length in orm.dart', () {
        User u = new User();
        expect(u.getColumnCount(), equals(orm[0]['column'].length));
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

      test('setPK & getPK success', () {
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
        User u = new User(new List.filled(orm[0]['column'].length, 1));
        List r = u.toAddFixedList();
        expect(r, equals(new List.filled(orm[0]['column'].length, 1)));
      });

      test('filter on', () {
        User u = new User(new List.filled(orm[0]['column'].length, 1));
        List r = u.toAddFixedList(true);
        List expectR = new List.filled(orm[0]['column'].length, 1);
        expectR[8] = null;
        expectR[9] = null;
        expect(r, equals(expectR));
      });

      test('length of return list should not be changed', () {
        User u = new User(new List.filled(orm[0]['column'].length, 1));
        List r = u.toAddFixedList();
        expect(
          () => r.add(1),
          throwsA(predicate((e) => e is IModelException))
        );
      });
    });
  });
}
