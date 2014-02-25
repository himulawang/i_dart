library orm;

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
};
