library orm;

Map orm = {
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
};
