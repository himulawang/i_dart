part of lib_i_model;

class ConnectionMariaDBStore extends IMariaDBStore {
  static Future add(Connection model) {
    if (model is! Connection) throw new IStoreException(21023);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(21024);

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(model);

    return handler.prepareExecute("INSERT INTO `Connection` VALUES (?, ?, ?, ?, ?);", model.toAddList(true))
      .then((Results results) {
        if (results.affectedRows != 1) throw new IStoreException(21025);

        model.setUpdatedList(false);
        return model;
      }).catchError(_handleErr);
  }

  static Future set(Connection model) {
    if (model is! Connection) throw new IStoreException(21026);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(21027);

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(model);

    // TODO make query dynamic
    return handler.prepareExecute("UPDATE `Connection` SET `name` = ?, `host` = ? WHERE `id` = ?;", model.toSetList(true)..add(model.getPK()))
      .then((Results results) {
        if (results.affectedRows == 0) throw new IStoreException(21028);
        if (results.affectedRows != 1) throw new IStoreException(21029);

        model.setUpdatedList(false);
        return model;
      }).catchError(_handleErr);
  }

  static Future get(num pk) {
    if (pk is! num) throw new IStoreException(21021);

    Connection model = new Connection();
    model.setPK(pk);

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(model);

    // TODO change sql * to detail column name
    return handler.prepareExecute("SELECT * FROM `Connection` WHERE `id` = ?;", [pk])
      .then((Results results) {
        return results.toList().then((list) {
          if (list.length == 0) return model;
          if (list.length != 1) throw new IStoreException(21022);

          model.fromList(list[0]);
          model.setExist();
          return model;
        });
      }).catchError(_handleErr);
  }

  static void _handleErr(err) {
    throw err;
  }
}
