part of i_maker;

abstract class IIndexedDBStoreMaker {
  String makeIndexedDBStore(String name, Map orm, Map storeOrm) {
    Map store = _getStoreConfig('indexedDB', storeOrm);
    List pkColumnName = [];
    for (int i = 0; i < orm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][orm['pk'][i]]);
    }

    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${name}IndexedDBStore extends IIndexedDBStore {
  static const Map store = const ${JSON.encode(store)};

  static Future add(${name} model) {
    if (model is! ${name}) throw new IStoreException(22004);
    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(22005);

    toAddAbb['_pk'] = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.add(toAddAbb)
    .then((addKey) {
      return model..setUpdatedList(false);
    }).catchError((e) {
      if (e is Event) {
        if (e.target.error.message == 'Key already exists in the object store.') {
          throw new IStoreException(22007);
        }
        throw e.target.error;
      }
      throw e;
    });
  }

  static Future set(${name} model) {
    if (model is! ${name}) throw new IStoreException(22008);

    // model has not been updated
    if (!model.isUpdated()) {
      new IStoreException(27001);
      Completer completer = new Completer();
      completer.complete(model);
      return completer.future;
    }

    // indexedDB do not like redis, put(set) will overwrite the whole key
    // so we use toSet filter the whole _args
    Map toSetAbb = {};
    ${name}._mapAbb.forEach((abb, i) {
      if (${name}._columns[i]['toSet']) return;
      toSetAbb[abb] = model._args[i];
    });
    if (toSetAbb.length == 0) throw new IStoreException(22009);

    toSetAbb['_pk'] = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.put(toSetAbb)
    .then((setKey) {
      return model..setUpdatedList(false);
    }).catchError(_handleErr);
  }

  static Future get(${pkColumnName.join(', ')}) {
    ${name} model = new ${name}()..setPK(${pkColumnName.join(', ')});

    var pk = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.getObject(pk)
    .then((result) {
      if (result == null) return model;
      return model..fromAbb(result)..setExist();
    }).catchError(_handleErr);
  }

  static Future del(${name} model) {
    if (model is! ${name}) throw new IStoreException(22010);

    var pk = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.delete(pk).catchError(_handleErr);
  }

  static _makeKey(${name} model) {
    var pk = model.getPK();
    if (pk is List) {
      if (pk.contains(null)) throw new IStoreException(22006);
    } else {
      if (pk == null) throw new IStoreException(22006);
    }
    return pk;
  }

  static _handleErr(e) {
    if (e is Event)  throw e.target.error;
    throw e;
  }
}
    ''';

    return code;
  }

  String makeIndexedDBPKStore(String name, Map orm, Map storeOrm) {
    String pkName = orm['className'];
    Map storeConfig = _getStoreConfig('indexedDB', storeOrm);
    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${pkName}IndexedDBStore extends IIndexedDBStore {
  static const String OBJECT_STORE_PK_NAME = '_pk';
  static const String OBJECT_STORE_VALUE_NAME = 'value';

  static const String _objectStore = '${storeConfig['objectStore']}';
  static const String _key = '${storeConfig['key']}';

  static const Map store = const ${JSON.encode(storeConfig)};

  static Future set(${pkName} pk) {
    if (pk is! ${pkName}) throw new IStoreException(22011);
    if (!pk.isUpdated()) {
      new IStoreException(27002);
      Completer completer = new Completer();
      completer.complete(pk);
      return completer.future;
    }

    num value = pk.get();
    if (value is! num) throw new IStoreException(22012);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);
    return handler.put({ OBJECT_STORE_PK_NAME: _key, OBJECT_STORE_VALUE_NAME: value })
    .then((setKey) {
      return pk..setUpdated(false);
    }).catchError(_handleErr);
  }

  static Future get() {
    ${pkName} pk = new ${pkName}();

    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    return handler.getObject(_key)
    .then((result) {
      if (result == null) return pk;
      return pk..set(result[OBJECT_STORE_VALUE_NAME])..setUpdated(false);
    }).catchError(_handleErr);
  }

  static Future del() {
    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);
    return handler.delete(_key).catchError(_handleErr);
  }

  static void _handleErr(e) {
    if (e is Event) throw e.target.error;
    throw e;
  }
}
''';
    return code;
  }

  String makeIndexedDBListStore(String name, Map orm, Map listOrm, Map storeOrm) {
    String listName = listOrm['className'];
    Map storeConfig = _getStoreConfig('indexedDB', storeOrm);

    List pkColumnName = [];

    listOrm['pk'].forEach((index) {
      pkColumnName.add(orm['column'][index]);
    });

    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${listName}IndexedDBStore extends IIndexedDBStore {
  static const String OBJECT_STORE_PK_NAME = '_pk';
  static const String OBJECT_STORE_INDEX_NAME = '_index';

  static const Map store = const ${JSON.encode(storeConfig)};

  static Future<${listName}> set(${listName} list) {
    if (list is! ${listName}) throw new IStoreException(22013);

    if (!list.isUpdated()) {
      new IStoreException(27003);
      Completer completer = new Completer();
      completer.complete(list);
      return completer.future;
    }

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    List waitList = [];
    list.getToAddList().forEach((String childId, ${name} model) {
      waitList.add(_addChild(model, handler));
    });

    list.getToSetList().forEach((String childId, ${name} model) {
      waitList.add(_setChild(model, handler));
    });

    list.getToDelList().forEach((String childId, ${name} model) {
      waitList.add(_delChild(model, handler));
    });

    return Future.wait(waitList)
    .then((_) => list..resetAllToList())
    .catchError(_handleErr);
  }

  static Future<${listName}> get(${pkColumnName.join(', ')}) {
    Completer completer = new Completer();
    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    ${listName} list = new ${listName}(${pkColumnName.join(', ')});

    handler.index(OBJECT_STORE_INDEX_NAME)
    .openCursor(key: list.getUnitedPK(), autoAdvance: true)
    .listen((CursorWithValue cursor) {
      list._set(new ${name}()..fromAbb(cursor.value));
    }, onDone: () {
      completer.complete(list);
    });

    return completer.future;
  }

  static Future del(${listName} list) {
    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    List waitList = [];
    list.getList().forEach((String childId, ${name} model) {
      waitList.add(_delChild(model, handler));
    });

    return Future.wait(waitList);
  }

  static Future _addChild(${name} model, ObjectStore handler) {
    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) {
      new IStoreException(27005);
      Completer completer = new Completer();
      completer.complete();
      return completer.future;
    }

    toAddAbb
      ..[OBJECT_STORE_PK_NAME] = model.getUnitedWholePK()
      ..[OBJECT_STORE_INDEX_NAME] = model.getUnitedListPK();

    return handler.add(toAddAbb)
    .then((setKey) => model..setUpdatedList(false))
    .catchError((e) {
      if (e is Event) {
        if (e.target.error.message == 'Key already exists in the object store.') {
          new IStoreException(27004);
          return;
        }
        throw e.target.error;
      }
      throw e;
    });
  }

  static Future _setChild(${name} model, ObjectStore handler) {
    // indexedDB do not like redis, put(set) will overwrite the whole key
    // so we use toSet filter the whole _args
    Map toSetAbb = {};
    ${name}._mapAbb.forEach((abb, i) {
      if (${name}._columns[i]['toSet']) return;
      toSetAbb[abb] = model._args[i];
    });

    if (toSetAbb.length == 0) new IStoreException(27006);

    toSetAbb
      ..[OBJECT_STORE_PK_NAME] = model.getUnitedWholePK()
      ..[OBJECT_STORE_INDEX_NAME] = model.getUnitedListPK();

    return handler.put(toSetAbb)
    .then((setKey) => model..setUpdatedList(false))
    .catchError(_handleErr);
  }

  static Future _delChild(${name} model, ObjectStore handler) {
    return handler.delete(model.getUnitedWholePK())
    .catchError(_handleErr);
  }

  static void _handleErr(e) {
    if (e is Event) throw e.target.error;
    throw e;
  }
}
''';
    return code;
  }
}
