part of lib_i_model;

class ConnectionMariaDBStore extends IMariaDBStore {
  static Future add(Connection model) {
    if (model is! Connection) throw new IStoreException(21023);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(21024);

    Map toAddList = model.toAddList(true);
    if (toAddList.length == 0) throw new IStoreException(21035);

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(model);

    return handler.prepareExecute(IMariaDBSQLPrepare.makeAdd(model), toAddList)
    .then((Results results) {
      if (results.affectedRows != 1) throw new IStoreException(21025);
      return model;
    }).catchError(_handleErr);
  }

  static Future set(Connection model) {
    if (model is! Connection) throw new IStoreException(21026);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(21027);

    Map toSetList = model.toSetList(true);
    if (toSetList.length == 0) throw new IStoreException(26001);

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(model);

    return handler.prepareExecute(IMariaDBSQLPrepare.makeSet(model), toSetList..add(model.getPK()))
    .then((Results results) {
      if (results.affectedRows == 0) new IStoreException(26002);
      else if (results.affectedRows > 1) new IStoreException(26003);
      return model;
    }).catchError(_handleErr);
  }

  static Future get(num pk) {
    if (pk is! num) throw new IStoreException(21021);

    Connection model = new Connection()..setPK(pk);
    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(model);

    return handler.prepareExecute(IMariaDBSQLPrepare.makeGet(model), [pk])
    .then((Results results) => results.toList())
    .then((List result) {
      if (result.length == 0) return model;
      if (result.length != 1) throw new IStoreException(21022);
      return model..fromList(result[0])..setExist();
    })
    .catchError(_handleErr);
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
    if (pk is! num) throw new IStoreException(21034);

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(model);
    return handler.prepareExecute(IMariaDBSQLPrepare.makeDel(model), [pk])
    .then((Results results) {
      if (results.affectedRows == 0) new IStoreException(26004);
      if (results.affectedRows != 1) new IStoreException(26005);
      return results.affectedRows;
    }).catchError(_handleErr);
  }

  static void _handleErr(err) => throw err;
}
