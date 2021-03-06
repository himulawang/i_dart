/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_client_store;

class SingleListIndexedDBStore extends IIndexedDBStore {
  static const String OBJECT_STORE_PK_NAME = '_pk';
  static const String OBJECT_STORE_INDEX_NAME = '_index';
  static const String _listName = 'SingleList';
  static const String _modelName = 'Single';

  static const Map store = const {"type":"indexedDB","master":"GameIDB","objectStore":"SingleList"};

  static Future<SingleList> set(SingleList list) {
    if (list is! SingleList) throw new IStoreException(30013, [list.runtimeType, _listName]);

    if (!list.isUpdated()) {
      new IStoreException(30503, [_listName]);
      Completer completer = new Completer();
      completer.complete(list);
      return completer.future;
    }

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    List waitList = [];
    list.getToAddList().forEach((String childId, Single model) {
      waitList.add(_addChild(model, handler));
    });

    list.getToSetList().forEach((String childId, Single model) {
      waitList.add(_setChild(model, handler));
    });

    list.getToDelList().forEach((String childId, Single model) {
      waitList.add(_delChild(model, handler));
    });

    return Future.wait(waitList)
    .then((_) => list..resetAllToList())
    .catchError(_handleErr);
  }

  static Future<SingleList> get(id) {
    Completer completer = new Completer();
    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    SingleList list = new SingleList(id);

    handler.index(OBJECT_STORE_INDEX_NAME)
    .openCursor(key: list.getUnitedPK(), autoAdvance: true)
    .listen((CursorWithValue cursor) {
      list.rawSet(new Single()..fromAbb(cursor.value));
    }, onDone: () {
      completer.complete(list);
    });

    return completer.future;
  }

  static Future del(SingleList list) {
    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    List waitList = [];
    list.getList().forEach((String childId, Single model) {
      waitList.add(_delChild(model, handler));
    });

    return Future.wait(waitList);
  }

  static Future _addChild(Single model, ObjectStore handler) {
    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) {
      new IStoreException(30505, [_modelName]);
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
          new IStoreException(30504, [_modelName]);
          return;
        }
        throw e.target.error;
      }
      throw e;
    });
  }

  static Future _setChild(Single model, ObjectStore handler) {
    // indexedDB do not like redis, put(set) will overwrite the whole key
    // so we use toSet filter the whole _args
    Map toSetAbb = {};
    Single._mapAbb.forEach((abb, i) {
      if (Single._columns[i]['toSet']) return;
      toSetAbb[abb] = model._args[i];
    });

    if (toSetAbb.length == 0) new IStoreException(30506, [_modelName]);

    toSetAbb
      ..[OBJECT_STORE_PK_NAME] = model.getUnitedWholePK()
      ..[OBJECT_STORE_INDEX_NAME] = model.getUnitedListPK();

    return handler.put(toSetAbb)
    .then((setKey) => model..setUpdatedList(false))
    .catchError(_handleErr);
  }

  static Future _delChild(Single model, ObjectStore handler) {
    return handler.delete(model.getUnitedWholePK())
    .catchError(_handleErr);
  }

  static void _handleErr(e) {
    if (e is Event) throw e.target.error;
    throw e;
  }
}
