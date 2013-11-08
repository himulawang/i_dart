library orm;

List orm =
[
  {
    'name': 'Connection',
    'list': 'ConnectionList',
    'pk': 0,
    'pkAutoIncrement': true,
    'abb': 'c',
    'column': [
      'id',
      'name',
      'host',
      'toAddFilter',
      'toAddFilt',
    ],
    'toAddFilter': [0],
    'toUpdateFilter': [1],
    'toArrayFilter': [],
    'toAbbFilter': [2],
    'toListFilter': [],
    // store
    'sharding': true,
    'shardKey': 0,
    'readWriteSeparate': true,
    'storeOrder': ['Redis', 'MariaDB'],
    'rdbWriter': 'GameCache',
    'rdbReader': 'GameCacheSlave',
    'mdbWriter': 'GameDB',
    'mdbReader': 'GameDBSlave',
  }
];