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

  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
