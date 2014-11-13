part of lib_test_client_store;

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
    'UserSingle': {
        'Model': {
            'pk': [0],
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
        'PK': {
            'className': 'UserSinglePK',
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'UserSingle',
                },
            ],
        },
        'PKStore': {
            'storeOrder': [
                {
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'PK',
                    'key': 'UserSinglePK',
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
        'List': {
            'className': 'UserMultiList',
            'pk': [0, 1],
            'childPK': [2, 3],
        },
        'PK': {
            'className': 'UserMultiPK',
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'UserMultiple',
                },
            ],
        },
        'PKStore': {
            'storeOrder': [
                {
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'PK',
                    'key': 'UserMultiPK',
                },
            ],
        },
    },
    'UserSingleToAddLengthZero': {
        'Model': {
            'pk': [0],
            'column': [
                'id',
                'name',
                'userName',
                'uniqueName',
            ],
            'toAddFilter': [0, 1, 2, 3],
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
                    'objectStore': 'UserSingleToAddLengthZero',
                },
            ],
        },
    },
    'UserSingleToSetLengthZero': {
        'Model': {
            'pk': [0],
            'column': [
                'id',
                'name',
                'userName',
                'uniqueName',
            ],
            'toAddFilter': [],
            'toSetFilter': [0, 1, 2, 3],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'UserSingleToSetLengthZero',
                },
            ],
        },
    },
    'Single': {
        'Model': {
            'pk': [0],
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
            'className': 'SingleList',
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
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'MultipleList',
                },
            ],
        },
    },
};
