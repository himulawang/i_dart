import 'i_maker/lib_i_maker.dart';
import 'i_model_config/orm.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(orm);
  modelMaker.make('/home/ila/project/i_dart/out');

  IStoreMaker storeMaker = new IStoreMaker(orm);
  storeMaker.make('/home/ila/project/i_dart/out');
}