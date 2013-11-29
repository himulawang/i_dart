import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';

import 'lib_i_model.dart';
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

    group('getRedisStore', () {
      test('should equal store in store.dart', () {
        User u = new User();
        expect(u.getRedisStore(), equals(orm[0]['storeOrder'][0]));
      });

    });
  });
}

