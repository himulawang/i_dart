import 'dart:html';
import 'dart:indexed_db';
import 'dart:async';
import 'lib_test.dart';

void main() {
  Database idb;
  var el = query('#Test');
  if (!IdbFactory.supported) {
    el.innerHtml = 'Unsupport';
    return;
  }

  el.innerHtml = 'Support';

  open()
  .then((Database db) => idb = db)
  .then((_) {
    Transaction tran = idb.transaction('Item', 'readwrite');
    ObjectStore store = tran.objectStore('Item');

    store.add({'i': 1, 'ti': 2, 'n': 'red bottle', 'q': 200})
    .then((addKey) {
      print(addKey);
    }).catchError((e) {
      print(e);
    });

  });
}

Future open() {
  return window.indexedDB.open('GameDB', version: 2, onUpgradeNeeded: upgrade)
  ;
}

void upgrade(VersionChangeEvent e) {
  Database db = (e.target as Request).result;

  db.deleteObjectStore('Item');

  /*
  * id
  * typeId
  * name
  * quantity
  * */
  ObjectStore objectStore = db.createObjectStore('Item', keyPath: 'pk', autoIncrement: true);
  objectStore.createIndex('id', 'i');
  objectStore.createIndex('typeId', 'ti');
}

