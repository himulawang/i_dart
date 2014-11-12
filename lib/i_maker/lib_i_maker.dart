/**
 * This library generates all I Dart components
 *
 * * Generate Models from orm configuration
 * * Generate Stores from orm store configuration
 *
 *     import 'i_maker/lib_i_maker.dart';
 *     import 'i_model_config/orm.dart';
 *
 *     void main() {
 *       IModelMaker modelMaker = new IModelMaker(deploy, orm);
 *       modelMaker.makeServer();
 *
 *       IStoreMaker storeMaker = new IStoreMaker(deploy, orm);
 *       storeMaker.makeServer();
 *
 *       IRouteMaker routeMaker = new IRouteMaker(deploy);
 *       routeMaker.makeServer();
 *
 *       ILibraryMaker libMaker = new ILibraryMaker(deploy);
 *       libMaker.makeServer();
 *     }
 */
library i_maker;

import 'dart:io';
import 'dart:convert';

part 'i_maker.dart';
part 'i_model_maker.dart';
part 'i_store_maker.dart';
part 'i_rdb_store_maker.dart';
part 'i_mdb_store_maker.dart';
part 'i_idb_store_maker.dart';
part 'i_srv_combined_store_maker.dart';

part 'i_route_maker.dart';
part 'i_lib_maker.dart';
