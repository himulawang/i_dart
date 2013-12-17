library orm;

List orm =
[
  {
    'name': 'User',
    'listName': 'UserList',
    'pk': 0,
    'abb': 'u',
    'column': [
      'id',
      'name',
      'userName',
      'uniqueName',
      'underworldName',
      'underworldName1',
      'underworldName2',
      'thisIsABitLongerAttribute',
      'testAddFilterColumn1',
      'testAddFilterColumn2',
      'testSetFilterColumn1',
      'testSetFilterColumn2',
      'testFullFilterColumn1',
      'testFullFilterColumn2',
      'testAbbFilterColumn1',
      'testAbbFilterColumn2',
      'testListFilterColumn1',
      'testListFilterColumn2',
    ],
    'toAddFilter': [8, 9],
    'toSetFilter': [10, 11],
    'toFullFilter': [12, 13],
    'toAbbFilter': [14, 15],
    'toListFilter': [16, 17],
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
  {
    'name': 'Room',
    'listName': 'RoomList',
    'pk': 0,
    'abb': 'r',
    'column': [
        'id',
        'name',
    ],
    'toAddFilter': [],
    'toSetFilter': [],
    'toFullFilter': [],
    'toAbbFilter': [],
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
  {
    'name': 'UserToAddLengthZero',
    'listName': 'UserToAddLengthZeroList',
    'pk': 0,
    'abb': 'utalz',
    'column': [
      'id',
      'name',
    ],
    'toAddFilter': [0, 1],
    'toSetFilter': [],
    'toFullFilter': [],
    'toAbbFilter': [],
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