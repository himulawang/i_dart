import 'dart:async';
import 'dart:math';
import 'dart:convert';

/*
import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:sqljocky/sqljocky.dart';

import 'lib_test.dart';
import 'i_config/store.dart';
import 'i_config/orm.dart';
*/

num startTimestamp;
num endTimestamp;

void main() {
  /*
  startTimestamp = new DateTime.now().millisecondsSinceEpoch;

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  */


  var a = '''
  // ila
{
  "a":1
}

''';
  print(JSON.decode(a));


}

