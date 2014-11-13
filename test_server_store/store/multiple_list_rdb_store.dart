/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_server_store;

class MultipleListRedisStore extends IRedisStore {
  static const Map store = const {"type":"redis","readWriteSeparate":false,"sharding":true,"shardMethod":"CRC32","master":"GameCache","slave":"GameCacheSlave","expire":0,"mode":"Atom","abb":"m"};
  static const String abb = 'm';
  static const num expire = 0;

  static const String _listName = 'MultipleList';
  static const String _modelName = 'Multiple';
  static const String _typeDelimiter = '_';
  static const String _fieldDelimiter = '-';
  static const String _keyDelimiter = ':';

  static Future<MultipleList> set(MultipleList list) {
    if (list is! MultipleList) throw new IStoreException(20040, [list.runtimeType, _listName]);

    if (!list.isUpdated()) {
      new IStoreException(20509, [_listName]);
      Completer completer = new Completer();
      completer.complete(list);
      return completer.future;
    }

    String listKey = _makeListKey(list);
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    List waitList = [];

    list.getToAddList().forEach((String childId, Multiple model) {
      String childKey = _makeChildKey(list, model);
      waitList..add(_addChild(listKey, childKey, model))
        ..add(handler.sadd(listKey, childKey));
    });

    list.getToSetList().forEach((String childId, Multiple model) {
      String childKey = _makeChildKey(list, model);
      waitList.add(_setChild(listKey, childKey, model));
    });

    list.getToDelList().forEach((String childId, Multiple model) {
      String childKey = _makeChildKey(list, model);
      waitList..add(_delChild(listKey, childKey, model))
        ..add(handler.srem(listKey, childId.toString()));
    });

    return Future.wait(waitList)
    .then((_) => list)
    .catchError(_handleErr);
  }

  static Future<MultipleList> get(id, name) {
    MultipleList list = new MultipleList(id, name);

    String listKey = _makeListKey(list);
    IRedis handler = new IRedisHandlerPool().getReaderHandler(store, listKey);

    return handler.smembers(listKey)
    .then((List result) {
      if (result.length == 0) throw new IStoreException(20508, [_listName]);

      List waitList = [];
      result.forEach((String childKey) {
        Multiple model = new Multiple();

        waitList.add(
          handler.exists(childKey)
          .then((int exists) {
            if (exists == 0) throw new IStoreException(20503, [_listName]);
            return handler.hmget(childKey, new List.from(model.getMapAbb().keys));
          })
          .then((List data) {
            model..fromList(data)..setExist();
            list.rawSet(model);
          })
          .catchError((e) {
            if (e is IStoreException && e.code == 20503) return model;
            throw e;
          })
        );
      });

      return Future.wait(waitList).then((_) => list..setExist());
    })
    .catchError((e) {
      if (e is IStoreException && e.code == 20508) return list;
      throw e;
    });
  }

  static Future del(MultipleList list) {
    if (list is! MultipleList) throw new IStoreException(20038, [list.runtimeType, _listName]);

    String listKey = _makeListKey(list);
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    List waitList = [];
    list.getList().forEach((String childId, Multiple model) {
      String childKey = _makeChildKey(list, model);
      waitList.add(_delChild(listKey, childKey, model));
    });

    waitList.add(handler.del(listKey));

    return Future.wait(waitList)
    .catchError(_handleErr);
  }

  static Future _addChild(String listKey, String key, Multiple model) {
    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032, [_modelName]);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    return handler.exists(key)
    .then((int exists) {
      if (exists == 1) throw new IStoreException(20024, [_modelName]);
      return handler.hmset(key, toAddAbb);
    })
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20025, [_modelName]);
      return model;
    })
    .catchError(_handleErr);
  }

  static Future _setChild(String listKey, String key, Multiple model) {
    Map toSetAbb = model.toSetAbb(true);
    if (toSetAbb.length == 0) {
      new IStoreException(20501, [_modelName]);
      Completer completer = new Completer();
      completer.complete(model);
      return completer.future;
    }

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    return handler.exists(key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(20028, [_modelName]);
      return handler.hmset(key, toSetAbb);
    })
        .then((String result) {
      if (result != 'OK') throw new IStoreException(20029, [_modelName]);
      return model;
    })
    .catchError(_handleErr);
  }

  static Future _delChild(String listKey, String key, Multiple model) {
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    return handler.del(key)
    .then((num deletedNum) {
      if (deletedNum == 0) new IStoreException(20502, [_modelName]);
      return deletedNum;
    })
    .catchError(_handleErr);
  }

  static String _makeListKey(MultipleList list)
    => '${abb}${_typeDelimiter}l${_fieldDelimiter}${list.getPK().join(_keyDelimiter)}';

  static String _makeChildKey(MultipleList list, Multiple model)
    => '${abb}${_typeDelimiter}c${_fieldDelimiter}${list.getPK().join(_keyDelimiter)}${_fieldDelimiter}${model.getChildPK().join(_keyDelimiter)}';

  static void _handleErr(e) => throw e;
}