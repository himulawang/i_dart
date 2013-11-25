library orm;

List orm =
[
  {
    'name': 'Connection',
    'listName': 'ConnectionList',
    'pk': 0,
    'abb': 'c',
    'column': [
      'id',
      'name',
      'host',
      'toAddFilter',
      'toAddFilt',
    ],
    'toAddFilter': [],
    'toSetFilter': [0, 3, 4],
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
        'mode': 'Atom' // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
      },
      {
        'type': 'mariaDB',
        'readWriteSeparate': true,
        'shardMethod': 'CRC32',
        'master': 'GameDB',
        'slave': 'GameDBSlave',
      },
    ],
  },
];