//import 'dart:io';
import 'dart:io' show Platform;

main() {
  /*
  Map<String, String> envVars = Platform.environment;
  //print(envVars);
  envVars.forEach((k, a) {
    print('$k : $a');
  });
  //print(Platform.environment);
  */
  var a = new A();
  print(A is Object);
}

class A {
  static const _a = 1;
  static getA() => _a;
}
