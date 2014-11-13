library lib_test_client_store;

import 'package:i_dart/i_maker/lib_i_maker.dart';

part 'i_config/deploy.dart';
part 'i_config/orm.dart';
part 'i_config/store.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(deploy, orm);
  modelMaker.make();

  IStoreMaker storeMaker = new IStoreMaker(deploy, orm);
  storeMaker.makeClient();

  IRouteMaker routeMaker = new IRouteMaker(deploy);
  routeMaker.makeClient();

  ILibraryMaker libMaker = new ILibraryMaker(deploy);
  libMaker.makeClient();
}
