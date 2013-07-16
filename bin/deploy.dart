import 'vendor/i/src/model/lib_model_maker.dart';
import 'config/orm.dart';

void main() {
  IMaker maker = new IMaker(orm);
  maker.make('/home/ila/dart/test/bin/vendor/i/src/model/', '/home/ila/dart/test/bin/model/');  
}