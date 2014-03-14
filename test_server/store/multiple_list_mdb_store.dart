/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

part of lib_test;

class MultipleListMariaDBStore extends IMariaDBStore {
  static const String table = 'Multiple';

  static const Map store = const {"type":"mariaDB","readWriteSeparate":false,"sharding":true,"shardMethod":"CRC32","master":"GameDB","slave":"GameDBSlave","table":"Multiple"};

  static Future<MultipleList> set(MultipleList list) {
    if (list is! MultipleList) throw new IStoreException(21039);

    if (!list.isUpdated()) {
      new IStoreException(26008);
      Completer completer = new Completer();
      completer.complete(list);
      return completer.future;
    }

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, list);

    List waitList = [];
    Map toAddList = list.getToAddList();
    Map toSetList = list.getToSetList();
    Map toDelList = list.getToDelList();

    if (toAddList.length != 0) waitList.add(_addChildren(toAddList, handler));
    if (toSetList.length != 0) waitList.add(_setChildren(toSetList, handler));
    if (toDelList.length != 0) waitList.add(_delChildren(toDelList, handler));

    return Future.wait(waitList)
    .then((_) => list..resetAllToList())
    .catchError(_handleErr);
  }

  static Future<MultipleList> get(id, name) {
    MultipleList list = new MultipleList(id, name);
    Multiple model = new Multiple();

    Completer c = new Completer();

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, list);

    return handler.prepareExecute(
        IMariaDBSQLPrepare.makeGet(table, list),
        IMariaDBSQLPrepare.makeWhereValues(model, [])
    ).then((Results results) {
      results.listen((row) {
        list._set(new Multiple.fromList(row.toList()));
      }, onDone: () {
        c.complete(list);
      });

      return c.future;
    })
    .catchError(_handleErr);
  }

  static Future del(MultipleList list) {
    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, list);

    return _delChildren(list.getList(), handler)
    .catchError(_handleErr);
  }

  static Future _addChildren(Map toAddList, ConnectionPool handler) {
    List params = [];
    toAddList.forEach((String childId, Multiple model) {
      List toAdd = model.toAddList(true);
      if (toAdd.length != 0) params.add(toAdd);
    });

    return handler
    .prepare(IMariaDBSQLPrepare.makeAdd(table, Multiple._mapFull, Multiple._columns))
    .then((query) => query.executeMulti(params));
  }

  static Future _setChildren(Map toSetList, ConnectionPool handler) {
    List waitList = [];

    toSetList.forEach((String childId, Multiple model) {
      List toSet = model.toSetList(true);
      if (toSet.length == 0) return;
      waitList.add(
        handler.prepareExecute(
            IMariaDBSQLPrepare.makeSet(table, model),
            IMariaDBSQLPrepare.makeWhereValues(model, toSet)
        ).then((Results results) {
          if (results.affectedRows == 0) new IStoreException(26010);
          if (results.affectedRows > 1) new IStoreException(26011);
          return model;
        }).catchError(_handleErr)
      );
    });

    return Future.wait(waitList);
  }

  static Future _delChildren(Map toDelList, ConnectionPool handler) {
    List waitList = [];

    toDelList.forEach((String childId, Multiple model) {
      waitList.add(
          handler.prepareExecute(
              IMariaDBSQLPrepare.makeDel(table, model),
              IMariaDBSQLPrepare.makeWhereValues(model, [])
          ).then((Results results) {
            if (results.affectedRows == 0) new IStoreException(26012);
            if (results.affectedRows > 1) new IStoreException(26013);
            return results.affectedRows;
          }).catchError(_handleErr)
      );
    });

    return Future.wait(waitList);
  }

  static void _handleErr(e) => throw e;
}
