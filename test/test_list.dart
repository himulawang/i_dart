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

    group('constructor initFromMap', () {
      test('first input argument is not num should throw exception', () {
        expect(() => new RoomList.initFromMap('aa', {}), throwsA(predicate((e) => e is IModelException && e.code == 10011)));
      });

      test('some child of map data is not instance of model should be filtered', () {
        Map dataList = {
          '1': new Room([1, '1']),
          '2': new Room([2, '2']),
          '3': new User(),
        };

        RoomList roomList = new RoomList.initFromMap(1, dataList);
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

        RoomList roomList = new RoomList.initFromMap(1, dataList);
        Map e = {
            '1': {'i': 1, 'n': '1'},
        };
        expect(roomList.toAbb(), equals(e));
      });
    });

    group('constructor initFromList', () {
      test('first input argument is not num should throw exception', () {
        expect(() => new RoomList.initFromList('aa', []), throwsA(predicate((e) => e is IModelException && e.code == 10011)));
      });

      test('some child of list data is not instance of model should be filtered', () {
        List dataList = [
          new Room([1, '1']),
          new Room([2, '2']),
          new User(),
        ];

        RoomList roomList = new RoomList.initFromList(1, dataList);
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

        RoomList roomList = new RoomList.initFromList(1, dataList);
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
        RoomList roomList = new RoomList.initFromList(1, dataList);
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
        RoomList roomList = new RoomList.initFromList(1, dataList);
        Map list = roomList.getList();
        expect(identical(list['1'], room1), equals(true));
        expect(identical(list['2'], room2), equals(true));
        expect(list.length, equals(2));
      });
    });
  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
