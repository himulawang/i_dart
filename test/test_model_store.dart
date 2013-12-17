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

  group('Test PK', () {
    group('constructor', () {
      test('no input value pk should be 0 & isUpdated is false', () {
        UserPK userPK = new UserPK();
        expect(userPK.get(), equals(0));
        expect(userPK.isUpdated(), equals(false));
      });

      test('has input value pk is right & isUpdated is false', () {
        UserPK userPK = new UserPK(777);
        expect(userPK.get(), equals(777));
        expect(userPK.isUpdated(), equals(false));
      });
    });
  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
