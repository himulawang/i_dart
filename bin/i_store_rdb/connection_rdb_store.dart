part of lib_i_model;

class ConnectionRedisStore extends IRedisStore {
  static Future add(Connection model) {
    if (model is! Connection) throw new IStoreException(20022);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(20023);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(model);

    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);
    return handler.exists(abbModelKey)
    .then((bool exist) {
      // model exist
      if (exist) throw new IStoreException(20024);

      Map toAddAbb = model.toAddAbb(true);
      // no attribute to add
      if (toAddAbb.length == 0) throw new IStoreException(20032);
      return toAddAbb;
    })
    .then((Map toAddAbb) => handler.hmset(abbModelKey, toAddAbb))
    .then((String result) {
      if (result != 'OK') throw IStoreException(20025);
      return model;
    })
    .catchError(_handleErr);
  }

  static Future set(Connection model) {
    if (model is! Connection) throw new IStoreException(20026);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(20027);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(model);
    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    Map toSetAbb = model.toSetAbb(true);
    if (toSetAbb.length == 0) throw new IStoreException(25001);

    return handler.hmset(abbModelKey, toSetAbb)
    .then((String result) {
      if (result != 'OK') throw IStoreException(20029);
      return model;
    })
    .catchError((e) {
      if (e is IStoreException && e._code == 25001) return model;
      throw e;
    });
  }

  static Future get(num pk) {
    if (pk is! num) throw new IStoreException(20021);

    Connection model = new Connection()..setPK(pk);
    RedisClient handler = new IRedisHandlerPool().getReaderHandler(model);
    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    return handler.exists(abbModelKey)
    .then((bool exist) {
      // TODO change this to warning
      if (!exist) throw new IStoreException(20031);
    })
    .then((_) => handler.hmget(abbModelKey, model.getMapAbb().keys))
    .then((List data) => model..fromList(data)..setExist())
    .catchError((e) {
      if (e is IStoreException && e._code == 20031) return model;
      throw e;
    });
  }

  static Future del(input) {
    num pk;
    Connection model;
    if (input is Connection) {
      model = input;
      pk = model.getPK();
    } else {
      model = new Connection()..setPK(input);
      pk = input;
    }
    if (pk is! num) throw new IStoreException(20030);

    RedisClient handler = new IRedisHandlerPool().getReaderHandler(model);
    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    return handler.del(abbModelKey)
    .then((bool result) {
      if (!result) new IStoreException(25002);
      return result;
    })
    .catchError(_handleErr);
  }

  static String _makeAbbModelKey(String abb, num pk) => '${abb}:${pk.toString()}';

  static void _handleErr(err) => throw err;
}
