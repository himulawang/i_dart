part of lib_i_model;

class ConnectionRedisStore extends IRedisStore {
  static Future add(Connection model) {
    if (model is! Connection) throw new IStoreException(20022);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(20023);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(model);

    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);
    return handler.exists(abbModelKey)
      .then((exist) {
        if (exist) throw new IStoreException(20024);

        return handler.hmset(abbModelKey, model.toAddAbb(true))
          .then((result) {
            if (result != 'OK') throw IStoreException(20025);

            model.setUpdatedList(false);
            return model;
          });
      }).catchError(_handleErr);
  }

  static Future set(Connection model) {
    if (model is! Connection) throw new IStoreException(20026);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(20027);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(model);

    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    return handler.hmset(abbModelKey, model.toSetAbb(true))
      .then((result) {
        if (result != 'OK') throw IStoreException(20029);

        model.setUpdatedList(false);
        return model;
      }).catchError(_handleErr);
  }

  static Future get(num pk) {
    if (pk is! num) throw new IStoreException(20021);

    Connection model = new Connection();
    model.setPK(pk);

    RedisClient handler = new IRedisHandlerPool().getReaderHandler(model);

    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    return handler.exists(abbModelKey)
      .then((exist) {
        if (!exist) return model;

        return handler.hmget(abbModelKey, model.getMapAbb().keys)
          .then((result) {
            model.fromList(result);
            model.setExist();
            return model;
          });
      }).catchError(_handleErr);
  }

  static String _makeAbbModelKey(String abb, num pk) => '${abb}:${pk.toString()}';

  static void _handleErr(err) {
    throw err;
  }
}
