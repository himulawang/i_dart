import 'model/lib_i_model.dart';
import 'dart:convert';
//import 'package:dartredisclient/redis_client.dart';
void main() {
  
  RedisClient client = new RedisClient("localhost:6379/0");
  
  client.info.then((info) {
    print("Redis Server info: $info");
    print("Redis Client info: ${client.raw.stats}");
  
  });

  var connectionList = new ConnectionList(1);
  
  var connection1 = new Connection();
  
  connection1.id = '1';
  connection1.name = 'ila';
  
  print(connection1.getPK());
  
  var connection2 = new Connection();
  
  connection2.id = '2';
  connection2.name = 'bb';
  
  connectionList.add(connection1);
  connectionList.add(connection2);
  
  print(connectionList.toArray());
  /*
  var model = new Model();
  
  model._pk = 1;
  print(model._pk);
  
  
  Map result = {};
  result['toAddList'] = connection1.toAddList();
  result['toAddFull'] = connection1.toAddFull();
  result['toAddAbb'] = connection1.toAddAbb();
  
  result['toUpdateList'] = connection1.toUpdateList();
  result['toUpdateFull'] = connection1.toUpdateFull();
  result['toUpdateAbb'] = connection1.toUpdateAbb();
  
  result['toList'] = connection1.toList();
  result['toFull'] = connection1.toArray();
  result['toAbb'] = connection1.toAbb();
  
  print(JSON.stringify(result));
  
  print(JSON.stringify(connectionList.toArray(false)));


  
  
  var man = new Man(1);
  
  print(man._pk);
*/  
}