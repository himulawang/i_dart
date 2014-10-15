import 'i_config/deploy_test_route.dart';
//import 'i_config/deploy_home.dart';
import '../bin/i_maker/lib_i_maker.dart';
import 'i_config/orm.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(deploy, orm);
  modelMaker.make();

  IStoreMaker storeMaker = new IStoreMaker(deploy, orm);
  storeMaker.makeClient();

  IUtilMaker utilMaker = new IUtilMaker(deploy);
  utilMaker.make();

  IRouteMaker routeMaker = new IRouteMaker(deploy);
  routeMaker.makeClient();

  ILibraryMaker libMaker = new ILibraryMaker(deploy);
  libMaker.makeClient();
}
