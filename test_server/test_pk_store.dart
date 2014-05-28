import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:redis_client/redis_client.dart';
import 'package:sqljocky/sqljocky.dart';

import 'lib_test.dart';
import 'i_config/store.dart';
import 'i_config/orm.dart';

num startTimestamp;
num endTimestamp;

void main() {
  startTimestamp = new DateTime.now().millisecondsSinceEpoch;

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  IMariaDBHandlerPool mariaDBPool = new IMariaDBHandlerPool()..init(store['mariaDB']);
  IRedisHandlerPool redisPool = new IRedisHandlerPool();

  redisPool.init(store['redis'])
  .then((_) => startTest());
}

Future flushdb() {
  // flushdb
  List waitList = [];
  IMariaDBHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((ConnectionPool pool) {
      waitList.add(
          pool.query('TRUNCATE TABLE `PK`;')
      );
    });
  });

  IRedisHandlerPool.dbs.forEach((groupName, List group) {
    group.forEach((RedisClient redisClient) => waitList.add(redisClient.flushdb()));
  });
  return Future.wait(waitList);
}

startTest() {
  group('Test pk store', () {

    group('pk with backup', () {

      setUp(() => flushdb());

      test('pk not exist should get pk with value 0', () {
        UserPKStore.get()
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), isZero);
        }));
      });

      setUp(() {});

      test('first set should backup to mdb', () {
        UserPK pk = new UserPK();
        pk.incr();
        UserPKStore.set(pk)
        .then((_) => UserPKMariaDBStore.get())
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), 5);
        }))
        .then((_) => UserPKRedisStore.get())
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), 1);
        }));
      });

      test('should backup after to mdb', () {
        UserPKStore.get()
        .then((UserPK pk) {
          pk..incr()
            ..incr()
            ..incr()
            ..incr();
          return UserPKStore.set(pk);
        })
        .then((_) => UserPKMariaDBStore.get())
        .then((UserPK pk) {
          expect(pk.get(), 5);
          return UserPKStore.get();
        })
        .then((UserPK pk) {
          pk.incr();
          return UserPKStore.set(pk);
        })
        .then((_) => UserPKRedisStore.get())
        .then((UserPK pk) {
          expect(pk.get(), 6);
          return UserPKMariaDBStore.get();
        })
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), 10);
        }));
      });

      test('when rdb pk not exist get from mdb', () {
        UserPK pk = new UserPK();
        UserPKRedisStore.del(pk)
        .then((_) => UserPKStore.get())
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), 10);
        }));
      });

      test('del successfully', () {
        UserPK pk = new UserPK();
        UserPKStore.del(pk)
        .then(expectAsync((_) {
          expect(true, isTrue);
        }));
      });

      test('del pk not exist should get warning', () {
        UserPK pk = new UserPK();
        UserPKStore.del(pk)
        .then(expectAsync((_) {
          expect(true, isTrue);
        }));
      });

      test('incr not reach step', () {
        UserPKStore.incr()
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(1));
          return UserPKStore.incr();
        }))
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(2));
          return UserPKMariaDBStore.get();
        }))
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(5));
        }));
      });

      test('incr reach step', () {
        UserPKStore.incr()
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(3));
          return UserPKStore.incr();
        }))
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(4));
          return UserPKStore.incr();
        }))
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(5));
          return UserPKStore.incr();
        }))
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(6));
          return UserPKMariaDBStore.get();
        }))
        .then(expectAsync((UserPK pk) {
          expect(pk.get(), equals(10));
        }));
      });

    });

    group('pk without backup', () {

      test('pk not exist should get pk with value 0', () {
        RoomPKStore.get()
        .then(expectAsync((RoomPK pk) {
          expect(pk.get(), isZero);
        }));
      });

      test('set should not backup to mdb', () {
        RoomPK pk = new RoomPK();
        pk.incr();
        RoomPKStore.set(pk)
        .then((_) => RoomPKMariaDBStore.get())
        .then(expectAsync((RoomPK pk) {
          expect(pk.get(), 0);
        }))
        .then((_) => RoomPKRedisStore.get())
        .then(expectAsync((RoomPK pk) {
          expect(pk.get(), 1);
        }));
      });

      test('should not backup after incr', () {
        RoomPKStore.get()
        .then((RoomPK pk) {
          pk..incr()
            ..incr()
            ..incr()
            ..incr();
          return RoomPKStore.set(pk);
        })
        .then((_) => RoomPKMariaDBStore.get())
        .then(expectAsync((RoomPK pk) {
          expect(pk.get(), 0);
        }));
      });

      test('del successfully', () {
        RoomPK pk = new RoomPK();
        RoomPKStore.del(pk)
        .then(expectAsync((_) {
          expect(true, isTrue);
        }));
      });

      test('del pk not exist should get warning', () {
        RoomPK pk = new RoomPK();
        RoomPKStore.del(pk)
        .then(expectAsync((_) {
          expect(true, isTrue);
        }));
      });

      test('incr should not backup to mdb', () {
        RoomPKStore.incr()
        .then(expectAsync((RoomPK pk) {
          expect(pk.get(), equals(1));
          return RoomPKStore.incr();
        }))
        .then(expectAsync((RoomPK pk) {
          expect(pk.get(), equals(2));
          return RoomPKMariaDBStore.get();
        }))
        .then(expectAsync((RoomPK pk) {
          expect(pk.get(), equals(0));
        }));
      });

    });
  });
}
