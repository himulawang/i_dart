/**
 * This library generates all I Dart components
 *
 * * Generate Models from orm configuration
 * * Generate Stores from orm store configuration
 * * Copy I core files to app directory
 *
 *     import 'i_maker/lib_i_maker.dart';
 *     import 'i_model_config/orm.dart';
 *
 *     void main() {
 *       IModelMaker modelMaker = new IModelMaker(orm);
 *       modelMaker.make('/home/ila/project/i_dart/out');
 *
 *       IStoreMaker storeMaker = new IStoreMaker(orm);
 *       storeMaker.make('/home/ila/project/i_dart/out');
 *     }
 */
library i_maker;

import 'dart:io';
import 'dart:convert';

part 'i_maker.dart';
part 'i_model_maker.dart';
part 'i_store_maker.dart';
part 'i_util_maker.dart';
part 'i_lib_maker.dart';
