part of i_maker;

abstract class IMariaDBStoreMaker {
  String makeMariaDBStore(String name, Map orm, Map storeOrm) {
    Map store = _getStoreConfig('mariaDB', storeOrm);
    if (store == null) return '';

    List pkColumnName = [];
    for (int i = 0; i < orm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][orm['pk'][i]]);
    }

    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${name}MariaDBStore extends IMariaDBStore {
  static const Map store = const ${JSON.encode(store)};
  static const String table = '${store['table']}';

  static Future add(${name} model) {
    if (model is! ${name}) throw new IStoreException(21023);

    Map toAddList = model.toAddList(true);
    if (toAddList.length == 0) throw new IStoreException(21035);

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, model.getUnitedPK());

    return handler.prepareExecute(IMariaDBSQLPrepare.makeAdd(table, ${name}._mapFull, ${name}._columns), toAddList)
    .then((Results results) {
      if (results.affectedRows != 1) throw new IStoreException(21025);
      return model;
    }).catchError((e) {
      if (e is MySqlException) {
        if (e.errorNumber == 1062) throw new IStoreException(21028);
        throw e;
      }
      throw e;
    });
  }

  static Future set(${name} model) {
    if (model is! ${name}) throw new IStoreException(21026);

    Map toSetList = model.toSetList(true);
    if (toSetList.length == 0) {
      new IStoreException(26001);
      Completer completer = new Completer();
      completer.complete(model);
      return completer.future;
    }

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, model.getUnitedPK());

    return handler.prepareExecute(
        IMariaDBSQLPrepare.makeSet(table, model),
        IMariaDBSQLPrepare.makeWhereValues(model, toSetList)
    ).then((Results results) {
      if (results.affectedRows == 0) new IStoreException(26002);
      if (results.affectedRows > 1) new IStoreException(26003);
      return model;
    }).catchError(_handleErr);
  }

  static Future get(${pkColumnName.join(', ')}) {
    ${name} model = new ${name}()..setPK(${pkColumnName.join(', ')});
    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, model.getUnitedPK());

    return handler.prepareExecute(
        IMariaDBSQLPrepare.makeGet(table, model),
        IMariaDBSQLPrepare.makeWhereValues(model, [])
    ).then((Results results) => results.toList())
    .then((List result) {
      if (result.length == 0) return model;
      if (result.length != 1) throw new IStoreException(21022);
      return model..fromList(result[0])..setExist();
    })
    .catchError(_handleErr);
  }

  static Future del(model) {
    if (model is! ${name}) throw new IStoreException(21034);

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, model.getUnitedPK());
    return handler.prepareExecute(
        IMariaDBSQLPrepare.makeDel(table, model),
        IMariaDBSQLPrepare.makeWhereValues(model, [])
    ).then((Results results) {
      if (results.affectedRows == 0) new IStoreException(26004);
      if (results.affectedRows != 1) new IStoreException(26005);
      return results.affectedRows;
    }).catchError(_handleErr);
  }

  static void _handleErr(e) => throw e;
}
    ''';
    return code;
  }

  String makeMariaDBPKStore(String name, Map orm, Map storeOrm) {
    Map storeConfig = _getStoreConfig('mariaDB', storeOrm);
    if (storeConfig == null) return '';

    String pkName = orm['className'];

    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${pkName}MariaDBStore extends IMariaDBStore {
  static const _key = '${storeConfig['abb']}-pk';
  static const _table = '${storeConfig['table']}';
  static const Map store = const ${JSON.encode(storeConfig)};

  static Future set(${pkName} pk) {
    if (pk is! ${pkName}) throw new IStoreException(21036);
    if (!pk.isUpdated()) {
      new IStoreException(26006);
      Completer completer = new Completer();
      completer.complete(pk);
      return completer.future;
    }

    num value = pk.get();
    if (value is! num) throw new IStoreException(21037);

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, _key);
    return handler.prepareExecute('INSERT INTO `\${_table}` (`key`, `pk`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `pk` = ?;', [_key, value, value])
    .then((Results results) {
      if (results.affectedRows == 0) throw new IStoreException(21038);
      return pk..setUpdated(false);
    })
    .catchError(_handleErr);
  }

  static Future get() {
    ${pkName} pk = new ${pkName}();

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, _key);

    return handler.prepareExecute('SELECT `pk` FROM `\${_table}` WHERE `key` = ?', [_key])
    .then((Results results) => results.toList())
    .then((List list) {
      if (list.length == 0) return pk;
      return pk..set(list[0][0])..setUpdated(false);
    })
    .catchError(_handleErr);
  }

  static Future del(pk) {
    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, _key);

    return handler.prepareExecute('DELETE FROM `\${_table}` WHERE `key` = ?', [_key])
    .then((Results results) {
      if (results.affectedRows == 0) new IStoreException(26007);
      if (results.affectedRows == 1) return true;
      return false;
    })
    .catchError(_handleErr);
  }

  static void _handleErr(e) => throw e;
}
''';
    return code;
  }

  String makeMaraiaDBListStore(String name, Map orm, Map listOrm, Map storeOrm) {
    Map storeConfig = _getStoreConfig('mariaDB', storeOrm);
    if (storeConfig == null) return '';

    String listName = listOrm['className'];

    List pkColumnName = [];

    listOrm['pk'].forEach((index) {
      pkColumnName.add(orm['column'][index]);
    });

    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${listName}MariaDBStore extends IMariaDBStore {
  static const String table = '${storeConfig['table']}';

  static const Map store = const ${JSON.encode(storeConfig)};

  static Future<${listName}> set(${listName} list) {
    if (list is! ${listName}) throw new IStoreException(21039);

    if (!list.isUpdated()) {
      new IStoreException(26008);
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

  static Future<${listName}> get(${pkColumnName.join(', ')}) {
    ${listName} list = new ${listName}(${pkColumnName.join(', ')});
    ${name} model = new ${name}();

    Completer c = new Completer();

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, list.getUnitedPK());

    return handler.prepareExecute(
        IMariaDBSQLPrepare.makeListGet(table, model),
        [${pkColumnName.join(', ')}]
    ).then((Results results) {
      results.listen((row) {
        list._set(new ${name}()..fromList(row.toList()));
      }, onDone: () {
        c.complete(list);
      });

      return c.future;
    })
    .catchError(_handleErr);
  }

  static Future del(${listName} list) {
    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, list.getUnitedPK());

    return _delChildren(list.getList(), handler)
    .catchError(_handleErr);
  }

  static Future _addChildren(Map toAddList, ConnectionPool handler) {
    List params = [];
    toAddList.forEach((String childId, ${name} model) {
      List toAdd = model.toAddList(true);
      if (toAdd.length != 0) params.add(toAdd);
    });

    return handler
    .prepare(IMariaDBSQLPrepare.makeAdd(table, ${name}._mapFull, ${name}._columns))
    .then((query) => query.executeMulti(params));
  }

  static Future _setChildren(Map toSetList, ConnectionPool handler) {
    List waitList = [];

    toSetList.forEach((String childId, ${name} model) {
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

    toDelList.forEach((String childId, ${name} model) {
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
''';

    return code;
  }
}
