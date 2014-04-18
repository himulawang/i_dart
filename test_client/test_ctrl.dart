import 'dart:html';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'lib_test.dart';
import './i_config/orm.dart';
import './i_config/store.dart';

void main() {
  useHtmlEnhancedConfiguration();

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

}

