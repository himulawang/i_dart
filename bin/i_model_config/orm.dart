library orm;

List orm =
[
  {
    'name': 'Connection',
    'listName': 'ConnectionList',
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
    'toSetFilter': [1],
    'toArrayFilter': [],
    'toAbbFilter': [2],
    'toListFilter': [],
    // store
    'sharding': true,
    'shardKey': 0,
    'storeOrder': [
      {
        'type': 'redis',
        'readWriteSeparate': true,
        'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
        'master': 'GameCache',
        'slave': 'GameCacheSlave',
        'expire': 86400,
      },
      {
        'type': 'mariaDB',
        'readWriteSeparate': true,
        'shardMethod': 'CRC32',
        'master': 'GameCache',
        'slave': 'GameCacheSlave',
      },
    ],
  },
];