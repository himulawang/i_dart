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
  var a = int.parse('112400000000');
  print(a);
  print(a is int);
  print(a is num);
}

