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
        'PK': {
            'className': 'UserPK',
        },
        'List': {
            'className': 'UserList',
            'pk': [0],
            'childPK': [1],
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
    },
    'UserMulti': {
        'Model': {
            'pk': [0, 1, 3],
            'column': [
                'id',
                'name',
                'gender',
                'uniqueName',
                'value'
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
        'PK': {
            'className': 'RoomPK',
        },
        'List': {
            'className': 'RoomList',
            'pk': [0],
            'childPK': [1],
        },
    },
};
