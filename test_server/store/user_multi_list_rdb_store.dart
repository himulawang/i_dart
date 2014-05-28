/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

part of lib_test;

class UserMultiListRedisStore extends IRedisStore {
  static const Map store = const {"type":"redis","readWriteSeparate":false,"shardMethod":"CRC32","master":"GameCache","slave":"GameCacheSlave","expire":86400,"mode":"Atom"};
  static const String abb = 'um';

  static Future set(UserMultiList list) {
    if (list is! UserMultiList) throw new IStoreException(20040);

    if (!list.isUpdated()) {
      new IStoreException(25009);
      Completer completer = new Completer();
      completer.complete(list);
      return completer.future;
    }

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, list);
    String listKey = _makeListKey(list);

    List waitList = [];
    list.getToAddList().forEach((String childId, UserMulti model) {
      String childKey = _makeChildKey(list, model);
      waitList..add(_addChild(model, handler))
              ..add(handler.sadd(listKey, childId.toString()).catchError(_handleErr));
    });

    list.getToSetList().forEach((String childId, UserMulti model) {
      String childKey = _makeChildKey(id);
      waitList.add(UserMultiRedisStore.set(model, childKey));
    });

    list.getToDelList().forEach((String childId, UserMulti model) {
      String childKey = _makeChildKey(id);
      waitList..add(UserMultiRedisStore.del(model, childKey))
              ..add(handler.srem(listKey, id.toString()).catchError(_handleErr));
    });

    return Future.wait(waitList)
    .then((_) => handler.expire(listKey, 86400).catchError(_handleErr))
    .then((_) => list..resetAllToList())
    .catchError(_handleErr);
  }

  static Future get(num id) {
    if (id is! num) throw new IStoreException(20037);
    UserMultiList list = new UserMultiList(id);

    IRedis handler = new IRedisHandlerPool().getReaderHandler(store, list);
    String abbListKey = _makeListKey(id);

    return handler.exists(abbListKey)
    .then((bool exist) {
      if (!exist) throw new IStoreException(25008);
      return handler.smembers(abbListKey);
    })
    .then((Set result) {
      if (result.length == 0) return list;

      List waitList = [];
      String childKey = _makeChildKey(id);
      result.forEach((String childId) {
        waitList.add(UserMultiRedisStore.get(childId, childKey));
      });

      return Future.wait(waitList)
      .then((List dataList) => list..fromList(dataList));
    })
    .catchError((e) {
      if (e is IStoreException && e.code == 25008) return list;
      throw e;
    });
  }

  static Future del(UserMultiList list) {
    if (list is! UserMultiList) throw new IStoreException(20038);
    num id = list.getPK();
    if (id is! num) throw new IStoreException(20039);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, list);
    String abbListKey = _makeListKey(list);

    List waitList = [];
    list.getList().forEach((num childId, UserMulti model) {
      waitList.add(UserMultiRedisStore.del(model));
    });

    waitList.add(handler.del(abbListKey));

    return Future.wait(waitList)
    .catchError(_handleErr);
  }

  static Future _addChild(UserMulti model, IRedis handler) {
    String key = _makeKey(model);

    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model);

    return handler.exists(key)
    .then((bool exist) {
      if (exist) throw new IStoreException(20024);
      return handler.hmset(key, toAddAbb);
    })
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20025);
      return handler.expire(key, 86400);
    })
    .then((bool result) {
      if (result) return model;
      new IStoreException(25004);
      return model;
    })
    .catchError(_handleErr);
  }

  static String _makeListKey(UserMultiList list) => '${abb}-l:${list.getPK().join(':')}';

  static String _makeChildKey(UserMultiList list, UserMulti model) => '${abb}:${list.getPK().join(':')}:${model.getChildPK().join(':')}';

  static void _handleErr(e) => throw e;
}