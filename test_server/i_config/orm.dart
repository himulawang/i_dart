library orm;

Map orm = {
    'User': {
        'Model': {
            'pk': [0],
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
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'u',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'User',
                },
            ],
        },
        'PK': {
            'className': 'UserPK',
        },
        'PKStore': {
            'backupStep': 5, // 0 means do not use backup
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'shardMethod': 'NONE',
                    'master': 'SingleCache',
                    'slave': 'SingleCacheSlave',
                    'abb': 'u',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'shardMethod': 'NONE',
                    'master': 'SingleDB',
                    'slave': 'SingleDBSlave',
                    'abb': 'u',
                    'table': 'PK',
                },
            ],
        },
        'List': {
            'className': 'UserList',
            'pk': [0],
            'childPK': [1],
        },
        'ListStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'u',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'User',
                },
            ],
        },
    },
    'UserSingle': {
        'Model': {
            'pk': [0, 1],
            'column': [
                'id',
                'name',
                'userName',
                'uniqueName',
            ],
            'toAddFilter': [],
            'toSetFilter': [],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
        'List': {
            'className': 'UserSingleList',
            'pk': [0],
            'childPK': [1],
        },
        'ListStore': {
            'storeOrder': [
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'UserSingle',
                },
            ],
        },
    },
    'UserMulti': {
        'Model': {
            'pk': [0, 1, 3],
            'column': [
                'id',
                'name',
                'gender',
                'uniqueName',
            ],
            'toAddFilter': [],
            'toSetFilter': [],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [0],
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'um',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'UserMulti',
                },
            ],
        },
        'List': {
            'className': 'UserMultiList',
            'pk': [0, 1],
            'childPK': [2, 3],
        },
    },
    'Room': {
        'Model': {
            'pk': [0],
            'column': [
                'id',
                'name',
            ],
            'toAddFilter': [],
            'toSetFilter': [],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'r',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'Room',
                },
            ],
        },
        'PK': {
            'className': 'RoomPK',
        },
        'PKStore': {
            'backupStep': 0, // 0 means do not use backup
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'shardMethod': 'NONE',
                    'master': 'SingleCache',
                    'slave': 'SingleCacheSlave',
                    'abb': 'r',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'shardMethod': 'NONE',
                    'master': 'SingleDB',
                    'slave': 'SingleDBSlave',
                    'abb': 'r',
                    'table': 'PK',
                },
            ],
        },
        'List': {
            'className': 'RoomList',
            'pk': [0],
            'childPK': [1],
        },
    },
    'UserToAddLengthZero': {
        'Model': {
            'pk': [0],
            'column': [
                'id',
                'name',
            ],
            'toAddFilter': [0, 1],
            'toSetFilter': [],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'utalz',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'UserToAddLengthZero',
                },
            ],
        },
    },
    'UserToSetLengthZero': {
        'Model': {
            'pk': [0],
            'column': [
                'id',
                'name',
            ],
            'toAddFilter': [],
            'toSetFilter': [0, 1],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'utslz',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'UserToSetLengthZero',
                },
            ],
        },
    },
    'UserForever': {
        'Model': {
            'pk': [0],
            'column': [
                'id',
                'name',
                'userName',
            ],
            'toAddFilter': [],
            'toSetFilter': [],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 0,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'uf',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'UserForever',
                },
            ],
        },
    },
    'Multiple': {
        'Model': {
            'pk': [0, 1, 3],
            'column': [
                'id',
                'name',
                'gender',
                'uniqueName',
                'value',
            ],
            'toAddFilter': [],
            'toSetFilter': [],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [0],
        },
        'List': {
            'className': 'MultipleList',
            'pk': [0, 1],
            'childPK': [2, 3],
        },
        'ListStore': {
            'storeOrder': [
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'Multiple',
                },
            ],
        },
    },
};
