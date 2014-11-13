/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */
library lib_test_model;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:i_redis/i_redis.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:logging/logging.dart';
import 'package:i_dart/i_dart_srv.dart';

part './i_config/server_route.dart';
part './i_config/orm.dart';
part './i_config/store.dart';

// model
part './model/user.dart';
part './model/user_pk.dart';
part './model/user_single_list.dart';
part './model/room_list.dart';
part './model/room.dart';
part './model/room_pk.dart';
part './model/user_multi_list.dart';
part './model/user_multi.dart';
part './model/user_list.dart';
part './model/user_single.dart';
// store
// route
part './route/example_route_logic.dart';
