/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_server_store;

class UserSingleNoExpireListMariaDBStore extends IMariaDBStore {
  static const String table = 'UserSingle';
  static const String _listName = 'UserSingleNoExpireList';
  static const String _modelName = 'UserSingleNoExpire';

  static const Map store = const {"type":"mariaDB","readWriteSeparate":false,"sharding":true,"shardMethod":"CRC32","master":"GameDB","slave":"GameDBSlave","table":"UserSingle"};

  static Future<UserSingleNoExpireList> set(UserSingleNoExpireList list) {
    if (list is! UserSingleNoExpireList) throw new IStoreException(21039, [list.runtimeType, _listName]);

    if (!list.isUpdated()) {
      new IStoreException(21508, [_listName]);
      Completer completer = new Completer();
      completer.complete(list);
      return completer.future;
    }

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, list.getUnitedPK());

    List waitList = [];
    Map toAddList = list.getToAddList();
    Map toSetList = list.getToSetList();
    Map toDelList = list.getToDelList();

    if (toAddList.length != 0) waitList.add(_addChildren(toAddList, handler));
    if (toSetList.length != 0) waitList.add(_setChildren(toSetList, handler));
    if (toDelList.length != 0) waitList.add(_delChildren(toDelList, handler));

    return Future.wait(waitList)
    .then((_) => list)
    .catchError(_handleErr);
  }

  static Future<UserSingleNoExpireList> get(id) {
    UserSingleNoExpireList list = new UserSingleNoExpireList(id);
    UserSingleNoExpire model = new UserSingleNoExpire();

    Completer c = new Completer();

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, list.getUnitedPK());

    return handler.prepareExecute(
        IMariaDBSQLPrepare.makeListGet(table, model),
        [id]
    ).then((Results results) {
      results.listen((row) {
        list.rawSet(new UserSingleNoExpire()..fromList(row.toList()));
      }, onDone: () {
        c.complete(list);
      });

      return c.future;
    })
    .catchError(_handleErr);
  }

  static Future del(UserSingleNoExpireList list) {
    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, list.getUnitedPK());

    return _delChildren(list.getList(), handler)
    .catchError(_handleErr);
  }

  static Future _addChildren(Map toAddList, ConnectionPool handler) {
    List params = [];
    toAddList.forEach((String childId, UserSingleNoExpire model) {
      List toAdd = model.toAddList(true);
      if (toAdd.length != 0) {
        params.add(toAdd);
      } else {
        new IStoreException(21509, [_modelName]);
      }
    });

    return handler
    .prepare(IMariaDBSQLPrepare.makeAdd(table, UserSingleNoExpire._mapFull, UserSingleNoExpire._columns))
    .then((query) => query.executeMulti(params));
  }

  static Future _setChildren(Map toSetList, ConnectionPool handler) {
    List waitList = [];

    toSetList.forEach((String childId, UserSingleNoExpire model) {
      List toSet = model.toSetList(true);
      if (toSet.length == 0) return;
      waitList.add(
        handler.prepareExecute(
            IMariaDBSQLPrepare.makeSet(table, model),
            IMariaDBSQLPrepare.makeWhereValues(model, toSet)
        ).then((Results results) {
          if (results.affectedRows == 0) new IStoreException(21510, [_modelName]);
          if (results.affectedRows > 1) new IStoreException(21511, [_modelName]);
          return model;
        }).catchError(_handleErr)
      );
    });

    return Future.wait(waitList);
  }

  static Future _delChildren(Map toDelList, ConnectionPool handler) {
    List waitList = [];

    toDelList.forEach((String childId, UserSingleNoExpire model) {
      waitList.add(
          handler.prepareExecute(
              IMariaDBSQLPrepare.makeDel(table, model),
              IMariaDBSQLPrepare.makeWhereValues(model, [])
          ).then((Results results) {
            if (results.affectedRows == 0) new IStoreException(21512, [_modelName]);
            if (results.affectedRows > 1) new IStoreException(21513, [_modelName]);
            return results.affectedRows;
          }).catchError(_handleErr)
      );
    });

    return Future.wait(waitList);
  }

  static void _handleErr(e) => throw e;
}
