import 'dart:io';
main() {
  //print('\aaabb'.replaceAll(new RegExp(r'\\'), '/'));
  //var b = new B.fromText(1);
  var collection = [0, 2, 2];
  for (var x in collection) {
    print(x);
  }
  collection.forEach((int a, int b) {
    print(a);
    print(b);
  });

}

class A {
  num _pk;
  A(num pk) {
    _pk = pk;
  }

  A.fromNum(num pk);
}

class B extends A {
  B(num pk) : super(pk) {}

  B.fromNum(num pk): super(pk) {
    _pk = pk;
  }
  B.fromText(num pk): super(pk) {
    _pk = pk;
  }
}

