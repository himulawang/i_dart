library orm;

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
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'User',
                },
            ],
        },
        'PK': {
            'className': 'UserPK',
        },
        'PKStore': {
            'storeOrder': [
                {
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'PK',
                    'key': 'UserPK',
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
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'SingleList',
                },
            ],
        },
    },
};
*/

Map orm = {
};
