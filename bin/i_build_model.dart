import 'i_model_maker/lib_i_maker.dart';
import 'i_model_maker_orm/orm.dart';

void main() {
  IModelMaker maker = new IModelMaker(orm);
  maker.make('/home/ila/project/i_dart/out');
}