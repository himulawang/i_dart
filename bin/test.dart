import 'dart:async';

import '../out/lib_i_model.dart';

var redisHandlerPool;
void main() {
  redisHandlerPool = new IRedisHandlerPool(store['redis']);



  /*
  RedisClient rdb;
  String connectionString = 'localhost:6379';
  RedisClient.connect(connectionString)
    .then((RedisClient client) {
      rdb = client;
      client.set('test', 'ila')
        .then((_) => client.get('test'))
        .then((value) => print(value))
        .then((_) => client.close())
        .then((_) => print('rdb closed;'))
      ;
    });
    */
  new Timer(new Duration(seconds: 1), aa);
}

void aa() {
  var c = new Connection();
  c.id = 20;
  c.name = 'ila';
  c.host = 'localhost';
  c.toAddFilter = 'localhost';
  c.toAddFilt= 'localhost';

  var store = new ConnectionStore();
  store.add(c).then((result) => print(result));
  //store.retrieve(1).then((result) => print(result.isExist()));
}
