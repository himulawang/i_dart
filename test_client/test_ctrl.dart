import 'dart:html';
import 'dart:async';

import 'package:logging/logging.dart';
//import 'package:unittest/unittest.dart';
//import 'package:unittest/html_enhanced_config.dart';
import 'package:paper_elements/core_animated_pages.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_checkbox.dart';
import 'package:paper_elements/paper_dialog.dart';
import 'package:paper_elements/paper_dialog_transition.dart';
import 'package:paper_elements/paper_fab.dart';
import 'package:paper_elements/paper_focusable.dart';
import 'package:paper_elements/paper_icon_button.dart';
import 'package:paper_elements/paper_ink.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:paper_elements/paper_item.dart';
import 'package:paper_elements/paper_menu_button.dart';
import 'package:paper_elements/paper_menu_button_overlay.dart';
import 'package:paper_elements/paper_menu_button_transition.dart';
import 'package:paper_elements/paper_progress.dart';
import 'package:paper_elements/paper_radio_button.dart';
import 'package:paper_elements/paper_radio_group.dart';
import 'package:paper_elements/paper_ripple.dart';
import 'package:paper_elements/paper_shadow.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_tab.dart';
import 'package:paper_elements/paper_tabs.dart';
import 'package:paper_elements/paper_toast.dart';
import 'package:paper_elements/paper_toggle_button.dart';
import 'package:paper_elements/roboto.dart';

import 'lib_test.dart';
import './i_config/orm.dart';
import './i_config/store.dart';


void main() {
  //useHtmlEnhancedConfiguration();

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

}

