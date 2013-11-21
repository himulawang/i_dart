import 'dart:io';
main() {

  var I = Instance;
  print(CONFIG.abb['name']);
  //var ii = new I();

}

class CONFIG {
  static const String name = 'ila';
  static const Map abb = const {'name': const {'name': 'ila'}};
  //const String abb = 'a';
}

class Instance {
  String name;
  Map abb;

  Instance() {
    name = CONFIG.name;
    abb = CONFIG.abb;
  }
}
