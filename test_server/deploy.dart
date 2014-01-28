import 'i_config/deploy.dart';
//import 'i_config/deploy_home.dart';
import '../bin/i_maker/lib_i_maker.dart';
import 'i_config/orm.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(deploy, orm);
  modelMaker.make();

  IStoreMaker storeMaker = new IStoreMaker(deploy, orm);
  storeMaker.makeServer();

  IUtilMaker utilMaker = new IUtilMaker(deploy);
  utilMaker.make();

  ILibraryMaker libMaker = new ILibraryMaker(deploy);
  libMaker.makeServer();
}
