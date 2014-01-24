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

    group('get & set', () {
      test('set new value & object is updated & get new value is right', () {
        UserPK userPK = new UserPK();
        userPK.set(888);
        expect(userPK.get(), equals(888));
        expect(userPK.isUpdated(), equals(true));
      });
    });

    group('incr', () {
      test('incr with no argument should incr 1 & object is updated', () {
        UserPK userPK = new UserPK();
        userPK.incr();
        expect(userPK.get(), equals(1));
        expect(userPK.isUpdated(), equals(true));
        userPK.incr();
        userPK.incr();
        userPK.incr();
        expect(userPK.get(), equals(4));
        expect(userPK.isUpdated(), equals(true));
      });

      test('incr with argument incr the right value & object is updated', () {
        UserPK userPK = new UserPK();
        userPK.incr(17);
        expect(userPK.get(), equals(17));
        expect(userPK.isUpdated(), equals(true));
        userPK.incr(3);
        expect(userPK.get(), equals(20));
        expect(userPK.isUpdated(), equals(true));
      });
    });

    group('reset', () {
      test('value should be 0 & object is updated', () {
        UserPK userPK = new UserPK();
        userPK.set(11);
        userPK.reset();
        expect(userPK.get(), equals(0));
        expect(userPK.isUpdated(), equals(true));
      });
    });

    group('setUpdated & isUpdated', () {
      test('set true', () {
        UserPK userPK = new UserPK();
        userPK.setUpdated(true);
        expect(userPK.isUpdated(), equals(true));
      });

      test('set false', () {
        UserPK userPK = new UserPK();
        userPK.incr();
        userPK.setUpdated(false);
        expect(userPK.isUpdated(), equals(false));
      });
    });

  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
