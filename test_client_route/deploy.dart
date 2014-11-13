import 'i_config/deploy.dart';
import 'package:i_dart/i_maker/lib_i_maker.dart';
import 'i_config/orm.dart';

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
