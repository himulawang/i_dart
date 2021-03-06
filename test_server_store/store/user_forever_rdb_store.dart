/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_server_store;

class UserForeverRedisStore extends IRedisStore {
  static const String abb = 'uf';
  static const Map store = const {"type":"redis","readWriteSeparate":false,"sharding":true,"shardMethod":"CRC32","master":"GameCache","slave":"GameCacheSlave","expire":0,"mode":"Atom","abb":"uf"};
  static const num expire = 0;
  static const String _modelName = 'UserForever';

  static Future add(UserForever model) {
    if (model is! UserForever) throw new IStoreException(20022, [model.runtimeType, _modelName]);

    String key = _makeKey(model);

    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032, [_modelName]);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model.getUnitedPK());

    return handler.exists(key)
    .then((int exists) {
      if (exists == 1) throw new IStoreException(20024, [_modelName]);
      return handler.hmset(key, toAddAbb);
    })
    .then((String result) {
      if (result != 'OK') throw IStoreException(20025, [_modelName]);
      return model;
    })
    .catchError(_handleErr);
  }

  static Future set(UserForever model) {
    if (model is! UserForever) throw new IStoreException(20026, [model.runtimeType, _modelName]);

    String key = _makeKey(model);

    Map toSetAbb = model.toSetAbb(true);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model.getUnitedPK());

    return handler.exists(key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(20028, [_modelName]);
      if (toSetAbb.length == 0)  throw new IStoreException(20501, [_modelName]);

      return handler.hmset(key, toSetAbb);
    })
    .then((String result) {
      if (result != 'OK') throw IStoreException(20029, [_modelName]);
      return model;
    })
    .catchError((e) {
      if (e is IStoreException && e.code == 20501) return model;
      throw e;
    });
  }

  static Future get(id) {
    UserForever model = new UserForever()..setPK(id);

    String key = _makeKey(model);

    IRedis handler = new IRedisHandlerPool().getReaderHandler(store, model.getUnitedPK());

    return handler.exists(key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(20503, [_modelName]);
      return handler.hmget(key, new List.from(model.getMapAbb().keys));
    })
    .then((List data) => model..fromList(data)..setExist())
    .catchError((e) {
      if (e is IStoreException && e.code == 20503) return model;
      throw e;
    });
  }

  static Future del(UserForever model) {
    if (model is! UserForever) throw new IStoreException(20030, [model.runtimeType, _modelName]);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model.getUnitedPK());

    String key = _makeKey(model);

    return handler.del(key)
    .then((int result) {
      if (result == 0) new IStoreException(20502, [_modelName]);
      return result;
    })
    .catchError(_handleErr);
  }

  static String _makeKey(UserForever model) {
    var pk = model.getPK();
    if (pk is List) {
      if (pk.contains(null)) throw new IStoreException(20042, ['UserForever']);
      return '${abb}:${pk.join(':')}';
    } else {
      if (pk == null) throw new IStoreException(20042, ['UserForever}']);
      return '${abb}:${pk}';
    }
  }

  static void _handleErr(e) => throw e;
}
