import 'dart:async';

import '../out/lib_i_model.dart';

IRedisHandlerPool redisHandlerPool;
IMariaDBHandlerPool mariaDBHandlerPool;

void main() {
  redisHandlerPool = new IRedisHandlerPool(store['redis']);
  mariaDBHandlerPool = new IMariaDBHandlerPool(store['mariaDB']);

  new Timer(new Duration(seconds: 1), aa);
}

void aa() {
  var c = new Connection();
  c.id = 20;
  c.name = 'dya';
  c.host = 'local';
  c.toAddFilter = 'localhost';
  c.toAddFilt= 'localhost';

  /*
  var store = new ConnectionStore();
  store.set(c).then((result) => print(result));
  var handler = mariaDBHandlerPool.getWriteHandler(c);

  var aa = handler.prepare("SELECT * FROM `Connection` WHERE name = ?;").then((query) {
    query.execute([1]).then((Results results) {
      results.toList().then((list) {
        print(list);
        var row = list[0];
        print(row);
      });
    });
  });
  */
  //handler.query("INSERT INTO `dartTest` VALUES (1, 'ila');").then((result) => print(result));

  //ConnectionStore.get(1).then((list) => print(list));
  ConnectionStore.set(c).then((Connection model) => print(model.toAbb()));
}
