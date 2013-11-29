import '../bin/i_maker/lib_i_maker.dart';
import 'i_config/orm.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(orm);
  modelMaker.make('/home/ila/project/i_dart/test');

  IStoreMaker storeMaker = new IStoreMaker(orm);
  storeMaker.make('/home/ila/project/i_dart/test');

  IUtilMaker utilMaker = new IUtilMaker();
  utilMaker.make();

  ILibraryMaker libMaker = new ILibraryMaker();
}
