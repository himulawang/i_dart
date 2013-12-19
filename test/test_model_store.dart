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
    IRedisHandlerPool redisHandlerPool;
    redisHandlerPool = new IRedisHandlerPool(store['redis']);
    //IMariaDBHandlerPool mariaDBHandlerPool;
    //mariaDBHandlerPool = new IMariaDBHandlerPool(store['mariaDB']);
  });
  tearDown(() {
  });

  group('Test rdb store', () {
    group('add', () {
      test('model is invalid', () {
        User user = new User(new List.filled(orm[0]['column'].length, 1));
        expect(() => RoomRedisStore.add(user), throwsA(predicate((e) => e is IStoreException && e.code == 20022)));
      });

    });
  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
