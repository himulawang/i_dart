part of lib_test;

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
  },
};