import 'dart:io';
main() {
  List a = new List.filled(2, null);
  //List b = a.to
  try {
    a.add(1);
  } catch (e) {
    print(e);

  }
  print(a);



}

