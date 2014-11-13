part of lib_test_server_route;

/* example
Map orm = {
    'User': {
        'Model': {
            'pk': [0],
            'column': [
                'groupId',
                'id',
                'name',
                'email',
                'country',
                'city',
            ],
            'toAddFilter': [2],
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
                    'master': 'GameCache', // link to store.dart
                    'slave': 'GameCacheSlave', // link to store.dart
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'u',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB', // link to store.dart
                    'slave': 'GameDBSlave', // link to store.dart
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
};
*/

Map orm = {
};
