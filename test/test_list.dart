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
  setUp(() {
// init
//IRedisHandlerPool redisHandlerPool;
//IMariaDBHandlerPool mariaDBHandlerPool;
//redisHandlerPool = new IRedisHandlerPool(store['redis']);
//mariaDBHandlerPool = new IMariaDBHandlerPool(store['mariaDB']);
  });
  tearDown(() {
  });

  group('Test List', () {
    group('constructor', () {
      test('input argument is not num should throw exception', () {
        expect(() => new RoomList('aa'), throwsA(predicate((e) => e is IModelException && e.code == 10011)));
      });

      test('input argument is num', () {
        expect(() => new RoomList(1), returnsNormally);
      });
    });

    group('constructor filledMap', () {
      test('first input argument is not num should throw exception', () {
        expect(() => new RoomList.filledMap('aa', {}), throwsA(predicate((e) => e is IModelException && e.code == 10011)));
      });

      test('some child of map data is not instance of model should be filtered', () {
        Map dataList = {
          '1': new Room([1, '1']),
          '2': new Room([2, '2']),
          '3': new User(),
        };

        RoomList roomList = new RoomList.filledMap(1, dataList);
        Map e = {
          '1': {'i': 1, 'n': '1'},
          '2': {'i': 2, 'n': '2'},
        };
        expect(roomList.toAbb(), equals(e));
      });

      test('some child of map data has no pk should be filtered', () {
        Map dataList = {
          '1': new Room([1, '1']),
          '2': new Room([null, '2']),
        };

        RoomList roomList = new RoomList.filledMap(1, dataList);
        Map e = {
            '1': {'i': 1, 'n': '1'},
        };
        expect(roomList.toAbb(), equals(e));
      });
    });

    group('constructor filledList', () {
      test('first input argument is not num should throw exception', () {
        expect(() => new RoomList.filledList('aa', []), throwsA(predicate((e) => e is IModelException && e.code == 10011)));
      });

      test('some child of list data is not instance of model should be filtered', () {
        List dataList = [
          new Room([1, '1']),
          new Room([2, '2']),
          new User(),
        ];

        RoomList roomList = new RoomList.filledList(1, dataList);
        Map e = {
            '1': {'i': 1, 'n': '1'},
            '2': {'i': 2, 'n': '2'},
        };
        expect(roomList.toAbb(), equals(e));
      });

      test('some child of list data has no pk should be filtered', () {
        List dataList = [
          new Room([1, '1']),
          new Room([null, '2']),
        ];

        RoomList roomList = new RoomList.filledList(1, dataList);
        Map e = {
          '1': {'i': 1, 'n': '1'},
        };
        expect(roomList.toAbb(), equals(e));
      });
    });

    group('length', () {
      test('get the right length', () {
        List dataList = [
            new Room([1, '1']),
            new Room([2, '2']),
        ];
        RoomList roomList = new RoomList.filledList(1, dataList);
        expect(roomList.length, equals(2));
      });
    });

    group('getPK & setPK', () {
      test('getPK after setPK get the right value', () {
        RoomList roomList = new RoomList(1);
        roomList.setPK(777);
        expect(roomList.getPK(), equals(777));
      });
    });

    group('getList', () {
      test('get the right list', () {
        Room room1 = new Room([1, '1']);
        Room room2 = new Room([2, '2']);
        List dataList = [room1, room2];
        RoomList roomList = new RoomList.filledList(1, dataList);
        Map list = roomList.getList();
        expect(identical(list['1'], room1), equals(true));
        expect(identical(list['2'], room2), equals(true));
        expect(list.length, equals(2));
      });
    });

    group('getToAddList', () {
      test('get the right list', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList(1);
        roomList.add(room1);
        Map toAddList = roomList.getToAddList();
        Map list = roomList.getList();
        expect(identical(toAddList['1'], room1), equals(true));
        expect(list.length, equals(1));
      });
    });

    group('getToDelList', () {
      test('get the right list', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList(1);
        roomList.add(room1);
        roomList.del(room1);
        Map toAddList = roomList.getToAddList();
        Map toDelList = roomList.getToDelList();
        Map list = roomList.getList();
        expect(identical(toDelList['1'], room1), equals(true));
        expect(list.length, equals(0));
      });
    });

    group('getToSetList', () {
      test('get the right list', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        room1.name = '2';
        roomList.set(room1);
        Map toSetList = roomList.getToSetList();
        Map list = roomList.getList();
        expect(identical(toSetList['1'], room1), equals(true));
        expect(list.length, equals(1));
      });
    });

    group('get', () {
      test('get the right model', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        Room room2 = roomList.get(1);
        expect(identical(room2, room1), equals(true));
      });

      test('get model not exist should return null', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        Room room2 = roomList.get(2);
        expect(room2, equals(null));
      });
    });

    group('add', () {
      test('add model exists should throw exception', () {
        Room room1 = new Room([1, '1']);
        Room room2 = new Room([1, '2']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        expect(() => roomList.add(room2), throwsA(predicate((e) => e is IModelException && e.code == 10003)));
      });

      test('add success', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList(1);
        roomList.add(room1);
        expect(roomList.getToAddList(), equals({'1': room1}));
        expect(roomList.getList(), equals({'1': room1}));
      });
    });

    group('set', () {
      test('set model not exist should throw exception', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList(1);
        expect(() => roomList.set(room1), throwsA(predicate((e) => e is IModelException && e.code == 10005)));
      });

      test('model exists in toAddList should refresh the model', () {
        Room room1 = new Room([1, '1']);
        Room room2 = new Room([1, '2']);
        RoomList roomList = new RoomList(1);
        roomList.add(room1);
        roomList.set(room2);
        expect(roomList.getToAddList()['1'], equals(room2));
        expect(roomList.getList()['1'], equals(room2));
      });

      test('model exists in toSetList should refresh the model', () {
        Room room1 = new Room([1, '1']);
        Room room2 = new Room([1, '2']);
        Room room3 = new Room([1, '3']);
        RoomList roomList = new RoomList(1);
        roomList.add(room1);
        roomList.set(room2);
        roomList.set(room3);
        expect(roomList.getToSetList()['1'], equals(room3));
        expect(roomList.getList()['1'], equals(room3));
      });
    });

    group('del', () {
      test('del by index', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        roomList.del(1);
        expect(roomList.getToDelList()['1'], equals(room1));
        expect(roomList.length, equals(0));
      });

      test('del by model', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        roomList.del(room1);
        expect(roomList.getToDelList()['1'], equals(room1));
        expect(roomList.length, equals(0));
      });

      test('del model not exists in list should throw exception', () {
        RoomList roomList = new RoomList(1);
        expect(() => roomList.del(2), throwsA(predicate((e) => e is IModelException && e.code == 10004)));
      });

      test('model exists in toAddList should remove the model', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList(1);
        roomList.add(room1);
        roomList.del(room1);
        expect(roomList.getToDelList()['1'], equals(room1));
        expect(roomList.getToAddList().length, equals(0));
        expect(roomList.length, equals(0));
      });

      test('model exists in toSetList should remove the model', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        roomList.set(room1);
        roomList.del(room1);
        expect(roomList.getToDelList()['1'], equals(room1));
        expect(roomList.getToSetList().length, equals(0));
        expect(roomList.length, equals(0));
      });

      test('del success', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        roomList.del(room1);
        expect(roomList.getToDelList()['1'], equals(room1));
        expect(roomList.length, equals(0));
      });
    });

    group('toFixedList', () {
      test('filter off', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList.filledList(1, [user1, user2]);
        Map e = {
          '1' : new List.filled(orm[0]['column'].length, 1),
          '2' : new List.filled(orm[0]['column'].length, 2),
        };
        expect(userList.toFixedList(), equals(e));
      });

      test('filter on', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList.filledList(1, [user1, user2]);
        List e1 = new List.filled(orm[0]['column'].length, 1);
        List e2 = new List.filled(orm[0]['column'].length, 2);
        e1[16] = null;
        e1[17] = null;
        e2[16] = null;
        e2[17] = null;
        Map e = {
            '1' : e1,
            '2' : e2,
        };
        expect(userList.toFixedList(true), equals(e));
      });
    });

    group('toList', () {
      test('filter off', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList.filledList(1, [user1, user2]);
        Map e = {
            '1' : new List.filled(orm[0]['column'].length, 1),
            '2' : new List.filled(orm[0]['column'].length, 2),
        };
        expect(userList.toList(), equals(e));
      });

      test('filter on', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList.filledList(1, [user1, user2]);
        List e1 = new List.filled(orm[0]['column'].length - 2, 1);
        List e2 = new List.filled(orm[0]['column'].length - 2, 2);
        Map e = {
            '1' : e1,
            '2' : e2,
        };
        expect(userList.toList(true), equals(e));
      });
    });

    group('toFull', () {
      test('filter off', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList.filledList(1, [user1, user2]);
        Map e1 = {
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
        Map e2 = {
            'id': 2,
            'name': 2,
            'userName': 2,
            'uniqueName': 2,
            'underworldName': 2,
            'underworldName1': 2,
            'underworldName2': 2,
            'thisIsABitLongerAttribute': 2,
            'testAddFilterColumn1': 2,
            'testAddFilterColumn2': 2,
            'testSetFilterColumn1': 2,
            'testSetFilterColumn2': 2,
            'testFullFilterColumn1': 2,
            'testFullFilterColumn2': 2,
            'testAbbFilterColumn1': 2,
            'testAbbFilterColumn2': 2,
            'testListFilterColumn1': 2,
            'testListFilterColumn2': 2
        };
        Map e = {
            '1' : e1,
            '2' : e2,
        };
        expect(userList.toFull(), equals(e));
      });

      test('filter on', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList.filledList(1, [user1, user2]);
        Map e1 = {
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
        Map e2 = {
            'id': 2,
            'name': 2,
            'userName': 2,
            'uniqueName': 2,
            'underworldName': 2,
            'underworldName1': 2,
            'underworldName2': 2,
            'thisIsABitLongerAttribute': 2,
            'testAddFilterColumn1': 2,
            'testAddFilterColumn2': 2,
            'testSetFilterColumn1': 2,
            'testSetFilterColumn2': 2,
            'testAbbFilterColumn1': 2,
            'testAbbFilterColumn2': 2,
            'testListFilterColumn1': 2,
            'testListFilterColumn2': 2
        };
        Map e = {
            '1' : e1,
            '2' : e2,
        };
        expect(userList.toFull(true), equals(e));
      });
    });

    group('toAbb', () {
      test('filter off', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList.filledList(1, [user1, user2]);
        Map e1 = {
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
            'tlfc2': 1,
        };
        Map e2 = {
            'i': 2,
            'n': 2,
            'un': 2,
            'un1': 2,
            'un2': 2,
            'un3': 2,
            'un4': 2,
            'tiabla': 2,
            'tafc1': 2,
            'tafc2': 2,
            'tsfc1': 2,
            'tsfc2': 2,
            'tffc1': 2,
            'tffc2': 2,
            'tafc3': 2,
            'tafc4': 2,
            'tlfc1': 2,
            'tlfc2': 2,
        };
        Map e = {
            '1' : e1,
            '2' : e2,
        };
        expect(userList.toAbb(), equals(e));
      });

      test('filter on', () {
        User user1 = new User(new List.filled(orm[0]['column'].length, 1));
        User user2 = new User(new List.filled(orm[0]['column'].length, 2));

        UserList userList = new UserList.filledList(1, [user1, user2]);
        Map e1 = {
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
            'tlfc2': 1,
        };
        Map e2 = {
            'i': 2,
            'n': 2,
            'un': 2,
            'un1': 2,
            'un2': 2,
            'un3': 2,
            'un4': 2,
            'tiabla': 2,
            'tafc1': 2,
            'tafc2': 2,
            'tsfc1': 2,
            'tsfc2': 2,
            'tffc1': 2,
            'tffc2': 2,
            'tlfc1': 2,
            'tlfc2': 2,
        };
        Map e = {
            '1' : e1,
            '2' : e2,
        };
        expect(userList.toAbb(true), equals(e));
      });
    });

    group('fromList', () {
      test('wrong type', () {
        RoomList roomList = new RoomList(1);
        expect(() => roomList.fromList({}), throwsA(predicate((e) => e is IModelException && e.code == 10012)));
      });

      test('wrong input data length', () {
        RoomList roomList = new RoomList(1);
        expect(() => roomList.fromList([[1]]), throwsA(predicate((e) => e is IModelException && e.code == 10006)));
      });

      test('not change update list', () {
        RoomList roomList = new RoomList(1);
        roomList.fromList([[1, '1'], [2, '2']]);
        expect(roomList.getToAddList().length, equals(0));
        expect(roomList.getList().length, equals(2));
      });

      test('change update list', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        roomList.fromList([[1, '1'], [2, '2']], true);
        expect(roomList.getToAddList().length, equals(1));
        expect(roomList.getToSetList().length, equals(1));
        expect(roomList.getList().length, equals(2));
      });
    });

    group('fromFull', () {
      test('wrong type', () {
        RoomList roomList = new RoomList(1);
        expect(() => roomList.fromFull([]), throwsA(predicate((e) => e is IModelException && e.code == 10013)));
      });

      test('not change update list', () {
        RoomList roomList = new RoomList(1);
        roomList.fromFull({'1': {'id': 1, 'name': '1'}, '2': {'id': 2, 'name': '2'}});
        expect(roomList.getToAddList().length, equals(0));
        expect(roomList.getList().length, equals(2));
      });

      test('change update list', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        roomList.fromFull({'1': {'id': 1, 'name': '1'}, '2': {'id': 2, 'name': '2'}}, true);
        expect(roomList.getToAddList().length, equals(1));
        expect(roomList.getToSetList().length, equals(1));
        expect(roomList.getList().length, equals(2));
      });
    });

    group('fromAbb', () {
      test('wrong type', () {
        RoomList roomList = new RoomList(1);
        expect(() => roomList.fromAbb([]), throwsA(predicate((e) => e is IModelException && e.code == 10014)));
      });

      test('not change update list', () {
        RoomList roomList = new RoomList(1);
        roomList.fromAbb({'1': {'i': 1, 'n': '1'}, '2': {'i': 2, 'n': '2'}});
        expect(roomList.getToAddList().length, equals(0));
        expect(roomList.getList().length, equals(2));
      });

      test('change update list', () {
        Room room1 = new Room([1, '1']);
        RoomList roomList = new RoomList.filledList(1, [room1]);
        roomList.fromAbb({'1': {'i': 1, 'n': '1'}, '2': {'i': 2, 'n': '2'}}, true);
        expect(roomList.getToAddList().length, equals(1));
        expect(roomList.getToSetList().length, equals(1));
        expect(roomList.getList().length, equals(2));
      });
    });
  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
