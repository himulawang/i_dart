library idb_upgrade;

import 'dart:indexed_db';

/*

Model

ObjectStore objectStore = db.createObjectStore('UserSingle', keyPath: '_pk');

PK
one objStore can hold all pks
ObjectStore objectStore = db.createObjectStore('PK', keyPath: '_pk');

List
ObjectStore objectStore = db.createObjectStore('SingleList', keyPath: '_pk');
objectStore.createIndex("_index", "_index", unique: false );

*/

/* example
Map idbUpgrade = {
  'GameIDB': {
      '1': (Database db) {
        ObjectStore objectStore = db.createObjectStore('UserMultiple', keyPath: '_pk');
      },
      '7': (Database db) {
        ObjectStore objectStore = db.createObjectStore('UserSingle', keyPath: '_pk');
      },
      '8': (Database db) {
        ObjectStore objectStore = db.createObjectStore('PK', keyPath: '_pk');
      },
      '9': (Database db) {
        ObjectStore objectStore = db.createObjectStore('UserSingleList', keyPath: '_pk');
        objectStore.createIndex("_index", "_index", unique: false );
      },
      '10': (Database db) {
        ObjectStore objectStore = db.createObjectStore('SingleList', keyPath: '_pk');
        objectStore.createIndex("_index", "_index", unique: false );
        db.deleteObjectStore('UserSingleList');
      },
      '12': (Database db) {
        ObjectStore objectStore = db.createObjectStore('MultipleList', keyPath: '_pk');
        objectStore.createIndex("_index", "_index", unique: false );
      },
  },
};
*/

Map idbUpgrade = {
};
