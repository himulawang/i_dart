part of i_maker;

class IStoreMaker extends IMaker {
  Map _orm;
  String _outStoreCoreDir;
  String _srcStoreCoreDir;
  String _outStoreDir;

  IStoreMaker(Map deploy, Map orm) : super(deploy) {
    _orm = orm;
  }

  void makeServer() {
    _srcStoreCoreDir = '${_iPath}/i_store_core';

    _outStoreCoreDir = '${_appPath}/i_store_core';
    _outStoreDir = '${_appPath}/store';

    makeSubDir();

    // copy core store
    copyFileWithHeader(_srcStoreCoreDir, 'i_rdb_store.dart', _outStoreCoreDir, 'i_rdb_store.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcStoreCoreDir, 'i_mdb_store.dart', _outStoreCoreDir, 'i_mdb_store.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcStoreCoreDir, 'i_rdb_handler_pool.dart', _outStoreCoreDir, 'i_rdb_handler_pool.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcStoreCoreDir, 'i_mdb_handler_pool.dart', _outStoreCoreDir, 'i_mdb_handler_pool.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcStoreCoreDir, 'i_mdb_sql_prepare.dart', _outStoreCoreDir, 'i_mdb_sql_prepare.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcStoreCoreDir, 'i_store_exception.dart', _outStoreCoreDir, 'i_store_exception.dart', 'part of lib_${_app};');

    _orm.forEach((String name, Map orm) {
      String lowerName = makeLowerUnderline(name);
      if (orm.containsKey('PK') && orm.containsKey('PKStore')) {
        // redis
        String redisCode = makeRedisPKStore(name, orm['PK'], orm['PKStore']);
        if (!redisCode.isEmpty) writeFile('${lowerName}_pk_rdb_store.dart', _outStoreDir, redisCode, true);

        // mariaDB
        String mariaDBCode = makeMariaDBPKStore(name, orm['PK'], orm['PKStore']);
        if (!mariaDBCode.isEmpty) writeFile('${lowerName}_pk_mdb_store.dart', _outStoreDir, mariaDBCode, true);

        // combined
        String combinedCode = makeCombinedPKStore(name, orm['PK'], orm['PKStore']);
        if (!combinedCode.isEmpty) writeFile('${lowerName}_pk_store.dart', _outStoreDir, combinedCode, true);
      }
      if (orm.containsKey('Model') && orm.containsKey('ModelStore')) {
        // redis
        String redisCode = makeRedisStore(name, orm['Model'], orm['ModelStore']);
        if (!redisCode.isEmpty) writeFile('${lowerName}_rdb_store.dart', _outStoreDir, redisCode, true);

        // mariaDB
        String mariaDBCode = makeMariaDBStore(name, orm['Model'], orm['ModelStore']);
        if (!mariaDBCode.isEmpty) writeFile('${lowerName}_mdb_store.dart', _outStoreDir, mariaDBCode, true);

        // combined
        String combinedCode = makeCombinedStore(name, orm['Model'], orm['ModelStore']);
        if (!combinedCode.isEmpty) writeFile('${lowerName}_store.dart', _outStoreDir, combinedCode, true);
      }
    });

  }

  void makeClient() {
    _srcStoreCoreDir = '${_iPath}/i_store_core';

    _outStoreCoreDir = '${_appPath}/i_store_core';
    _outStoreDir = '${_appPath}/store';

    makeSubDir();

    // copy core store
    copyFileWithHeader(_srcStoreCoreDir, 'i_idb_store.dart', _outStoreCoreDir, 'i_idb_store.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcStoreCoreDir, 'i_idb_handler_pool.dart', _outStoreCoreDir, 'i_idb_handler_pool.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcStoreCoreDir, 'i_store_exception.dart', _outStoreCoreDir, 'i_store_exception.dart', 'part of lib_${_app};');

    _orm.forEach((String name, Map orm) {
      String lowerName = makeLowerUnderline(name);

      if (orm.containsKey('PK') && orm.containsKey('PKStore')) {
        // indexedDB
        String indexedDBCode = makeIndexedDBPKStore(name, orm['PK'], orm['PKStore']);
        if (!indexedDBCode.isEmpty) writeFile('${lowerName}_pk_idb_store.dart', _outStoreDir, indexedDBCode, true);
      }

      if (orm.containsKey('Model') && orm.containsKey('ModelStore')) {
        // indexedDB
        String indexedDBCode = makeIndexedDBStore(name, orm['Model'], orm['ModelStore']);
        if (!indexedDBCode.isEmpty) writeFile('${lowerName}_idb_store.dart', _outStoreDir, indexedDBCode, true);
      }

      if (orm.containsKey('List') && orm.containsKey('ListStore')) {
        // indexedDB
        String indexedDBCode = makeIndexedDBListStore(name, orm['Model'], orm['List'], orm['ListStore']);
        if (!indexedDBCode.isEmpty) writeFile('${lowerName}_list_idb_store.dart', _outStoreDir, indexedDBCode, true);
      }
    });
  }

  String makeRedisStore(String name, Map orm, Map storeOrm) {
    Map storeConfig = _getStoreConfig('redis', storeOrm);
    if (storeConfig == null) return '';

    String codeHeader = '''
${_DECLARATION}
part of lib_${_app};

class ${name}RedisStore extends IRedisStore {
  static const String abb = '${storeConfig['abb']}';
  static const Map store = const ${JSON.encode(storeConfig)};

''';

    String codeFooter = '''
  static String _makeKey(${name} model) {
    var pk = model.getPK();
    if (pk is List) {
      if (pk.contains(null)) throw new IStoreException(20042);
      return '\$\{abb}:\$\{pk.join(':')}';
    } else {
      if (pk == null) throw new IStoreException(20042);
      return '\$\{abb}:\$\{pk}';
    }
  }

  static void _handleErr(e) => throw e;
}
''';

    StringBuffer codeSB = new StringBuffer();
    codeSB.write(codeHeader);

    codeSB.writeAll([
        _makeRedisAdd(name, orm, storeConfig),
        _makeRedisSet(name, orm, storeConfig),
        _makeRedisGet(name, orm, storeConfig),
        _makeRedisDel(name, orm, storeConfig),
        codeFooter
    ]);

    return codeSB.toString();
  }

  String _makeRedisAdd(String name, Map orm, Map storeConfig) {
    String codeHeader = '''
  static Future add(${name} model) {
    if (model is! ${name}) throw new IStoreException(20022);

    String key = _makeKey(model);

    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(store, model);

    return handler.exists(key)
    .then((bool exist) {
      if (exist) throw new IStoreException(20024);
      return handler.hmset(key, toAddAbb);
    })
''';

    String codeAddWithExpire = '''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20025);
      return handler.expire(key, ${storeConfig['expire']});
    })
    .then((bool result) {
      if (result) return model;
      new IStoreException(25004);
      return model;
    })
''';

    String codeAddWithoutExpire = '''
    .then((String result) {
      if (result != 'OK') throw IStoreException(20025);
      return model;
    })
''';

    String codeFooter = '''
    .catchError(_handleErr);
  }

''';

    StringBuffer codeSB = new StringBuffer();
    codeSB.write(codeHeader);
    if (storeConfig['expire'] == 0) {
      codeSB.write(codeAddWithoutExpire);
    } else {
      codeSB.write(codeAddWithExpire);
    }
    codeSB.write(codeFooter);

    return codeSB.toString();
  }

  String _makeRedisSet(String name, Map orm, Map storeConfig) {
    String codeHeader = '''
  static Future set(${name} model) {
    if (model is! ${name}) throw new IStoreException(20026);

    String key = _makeKey(model);

    Map toSetAbb = model.toSetAbb(true);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(store, model);

    return handler.exists(key)
    .then((bool exist) {
      if (!exist) throw new IStoreException(20028);
      if (toSetAbb.length == 0)  throw new IStoreException(25001);

      return handler.hmset(key, toSetAbb);
    })
''';

    String codeSetWithExpire = '''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20029);
      return handler.expire(key, ${storeConfig['expire']});
    })
    .then((bool result) {
      if (result) return model;
      new IStoreException(25005);
      return model;
    })
''';

    String codeSetWithoutExpire = '''
    .then((String result) {
      if (result != 'OK') throw IStoreException(20029);
      return model;
    })
''';

    String codeFooter = '''
    .catchError((e) {
      if (e is IStoreException && e.code == 25001) return model;
      throw e;
    });
  }

''';

    StringBuffer codeSB = new StringBuffer();
    codeSB.write(codeHeader);
    if (storeConfig['expire'] == 0) {
      codeSB.write(codeSetWithoutExpire);
    } else {
      codeSB.write(codeSetWithExpire);
    }
    codeSB.write(codeFooter);

    return codeSB.toString();
  }

  String _makeRedisGet(String name, Map orm, Map storeConfig) {
    List pkColumnName = [];
    for (int i = 0; i < orm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][orm['pk'][i]]);
    }

    String code = '''
  static Future get(${pkColumnName.join(', ')}) {
    ${name} model = new ${name}()..setPK(${pkColumnName.join(', ')});

    String key = _makeKey(model);

    RedisClient handler = new IRedisHandlerPool().getReaderHandler(store, model);

    return handler.exists(key)
    .then((bool exist) {
      if (!exist) throw new IStoreException(25003);
      return handler.hmget(key, model.getMapAbb().keys);
    })
    .then((List data) => model..fromList(data)..setExist())
    .catchError((e) {
      if (e is IStoreException && e.code == 25003) return model;
      throw e;
    });
  }

''';
    return code;
  }

  String _makeRedisDel(String name, Map orm, Map storeConfig) {
    List pkColumnName = [];
    for (int i = 0; i < orm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][orm['pk'][i]]);
    }

    String code = '''
  static Future del(${name} model) {
    if (model is! ${name}) throw new IStoreException(20030);

    RedisClient handler = new IRedisHandlerPool().getReaderHandler(store, model);

    String key = _makeKey(model);

    return handler.del(key)
    .then((bool result) {
      if (!result) new IStoreException(25002);
      return result;
    })
    .catchError(_handleErr);
  }

''';
    return code;
  }

  String makeMariaDBStore(String name, Map orm, Map storeOrm) {
    Map store = _getStoreConfig('mariaDB', storeOrm);

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

    var pk = model.getPK();
    if (pk is List && pk.contains(null)
      || pk == null
    ) throw new IStoreException(21024);

    Map toAddList = model.toAddList(true);
    if (toAddList.length == 0) throw new IStoreException(21035);

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, model);

    return handler.prepareExecute(IMariaDBSQLPrepare.makeAdd(table, model), toAddList)
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

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, model);

    return handler.prepareExecute(IMariaDBSQLPrepare.makeSet(table, model), _makeWhereValues(model, toSetList))
    .then((Results results) {
      if (results.affectedRows == 0) new IStoreException(26002);
      if (results.affectedRows > 1) new IStoreException(26003);
      return model;
    }).catchError(_handleErr);
  }

  static Future get(${pkColumnName.join(', ')}) {
    ${name} model = new ${name}()..setPK(${pkColumnName.join(', ')});
    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, model);

    return handler.prepareExecute(IMariaDBSQLPrepare.makeGet(table, model), _makeWhereValues(model, []))
    .then((Results results) => results.toList())
    .then((List result) {
      if (result.length == 0) return model;
      if (result.length != 1) throw new IStoreException(21022);
      return model..fromList(result[0])..setExist();
    })
    .catchError(_handleErr);
  }

  static Future del(model) {
    if (model is! ${name}) throw new IStoreException(21034);

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, model);
    return handler.prepareExecute(IMariaDBSQLPrepare.makeDel(table, model), _makeWhereValues(model, []))
    .then((Results results) {
      if (results.affectedRows == 0) new IStoreException(26004);
      if (results.affectedRows != 1) new IStoreException(26005);
      return results.affectedRows;
    }).catchError(_handleErr);
  }

  static void _handleErr(e) => throw e;

  static List _makeWhereValues(${name} model, List list) {
    var pk = model.getPK();
    if (pk is List) {
      if (pk.contains(null)) throw new IStoreException(21027);
      list.addAll(pk);
    } else {
      if (pk == null) throw new IStoreException(21027);
      list.add(pk);
    }
    return list;
  }
}
    ''';
    return code;

  }

  String makeIndexedDBStore(String name, Map orm, Map storeOrm) {
    Map store = _getStoreConfig('indexedDB', storeOrm);
    List pkColumnName = [];
    for (int i = 0; i < orm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][orm['pk'][i]]);
    }

    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${name}IndexedDBStore extends IIndexedDBStore {
  static const Map store = const ${JSON.encode(store)};

  static Future add(${name} model) {
    if (model is! ${name}) throw new IStoreException(22004);
    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(22005);

    toAddAbb['_pk'] = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.add(toAddAbb)
    .then((addKey) {
      return model..setUpdatedList(false);
    }).catchError((e) {
      if (e is Event) {
        if (e.target.error.message == 'Key already exists in the object store.') {
          throw new IStoreException(22007);
        }
        throw e.target.error;
      }
      throw e;
    });
  }

  static Future set(${name} model) {
    if (model is! ${name}) throw new IStoreException(22008);

    // model has not been updated
    if (!model.isUpdated()) {
      new IStoreException(27001);
      Completer completer = new Completer();
      completer.complete(model);
      return completer.future;
    }

    // indexedDB do not like redis, put(set) will overwrite the whole key
    // so we use toSet filter the whole _args
    Map toSetAbb = {};
    ${name}._mapAbb.forEach((abb, i) {
      if (${name}._columns[i]['toSet']) return;
      toSetAbb[abb] = model._args[i];
    });
    if (toSetAbb.length == 0) throw new IStoreException(22009);

    toSetAbb['_pk'] = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.put(toSetAbb)
    .then((setKey) {
      return model..setUpdatedList(false);
    }).catchError(_handleErr);
  }

  static Future get(${pkColumnName.join(', ')}) {
    ${name} model = new ${name}()..setPK(${pkColumnName.join(', ')});

    var pk = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.getObject(pk)
    .then((result) {
      if (result == null) return model;
      return model..fromAbb(result)..setExist();
    }).catchError(_handleErr);
  }

  static Future del(${name} model) {
    if (model is! ${name}) throw new IStoreException(22010);

    var pk = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.delete(pk).catchError(_handleErr);
  }

  static _makeKey(${name} model) {
    var pk = model.getPK();
    if (pk is List) {
      if (pk.contains(null)) throw new IStoreException(22006);
    } else {
      if (pk == null) throw new IStoreException(22006);
    }
    return pk;
  }

  static _handleErr(e) {
    if (e is Event)  throw e.target.error;
    throw e;
  }
}
    ''';

    return code;
  }

  String makeCombinedStore(String name, Map orm, Map storeOrm) {
    List storeOrder = storeOrm['storeOrder'];

    List pkColumnName = [];
    for (int i = 0; i < orm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][orm['pk'][i]]);
    }

    String codeHeader = '''
${_DECLARATION}
part of lib_${_app};

class ${name}Store {
''';

    String codeFooter = '''
}
''';

    StringBuffer codeSB = new StringBuffer();
    codeSB.write(codeHeader);

    // add
    codeSB.writeln('  static Future add(${name} model) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${name}${upperType}Store.add(model)');
      } else {
        codeSB.writeln('    .then((_) => ${name}${upperType}Store.add(model))');
      }
    }
    codeSB..writeln('    .then((${name} model) => model..setUpdatedList(false))')
          ..writeln('    ;')
          ..writeln('  }')
          ..writeln('');

    // set
    codeSB.writeln('  static Future set(${name} model) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${name}${upperType}Store.set(model)');
      } else {
        codeSB.writeln('    .then((_) => ${name}${upperType}Store.set(model))');
      }
    }
    codeSB..writeln('    .then((${name} model) => model..setUpdatedList(false))')
          ..writeln('    ;')
          ..writeln('  }')
          ..writeln('');

    // get
    codeSB.writeln('  static Future get(${pkColumnName.join(', ')}) {');
    for (int i = 0; i < storeOrder.length; ++i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == 0) {
        codeSB..writeln('    return ${name}${upperType}Store.get(${pkColumnName.join(', ')})');
      } else {
        codeSB..writeln('    .then((${name} model) {')
              ..writeln('      if (model.isExist()) return model;')
              ..writeln('      return ${name}${upperType}Store.get(${pkColumnName.join(', ')});')
              ..writeln('    })');
      }
    }

    codeSB..writeln('    ;')
      ..writeln('  }')
      ..writeln('');

    // del
    codeSB.writeln('  static Future del(input) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${name}${upperType}Store.del(input)');
      } else {
        codeSB.writeln('    .then((_) => ${name}${upperType}Store.del(input))');
      }
    }
    codeSB..writeln('    ;')
          ..writeln('  }');

    codeSB.write(codeFooter);
    return codeSB.toString();
  }

  String makeRedisPKStore(String name, Map orm, Map storeOrm) {
    String pkName = orm['className'];
    Map storeConfig = _getStoreConfig('redis', storeOrm);
    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${pkName}RedisStore extends IRedisStore {
  static const _key = '${storeConfig['abb']}-pk';

  static const Map store = const ${JSON.encode(storeConfig)};

  static Future set(${pkName} pk) {
    if (pk is! ${pkName}) throw new IStoreException(20034);
    if (!pk.isUpdated()) {
      new IStoreException(25005);
      Completer completer = new Completer();
      completer.complete(pk);
      return completer.future;
    }

    num value = pk.get();
    if (value is! num) throw new IStoreException(20035);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(store, pk);
    return handler.set(_key, value.toString())
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20036);
      return pk..setUpdated(false);
    })
    .catchError(_handleErr);
  }

  static Future get() {
    ${pkName} pk = new ${pkName}();

    RedisClient handler = new IRedisHandlerPool().getReaderHandler(store, pk);

    return handler.exists(_key)
    .then((bool exist) {
      if (!exist) throw new IStoreException(25006);
      return handler.get(_key);
    })
    .then((String value) => pk..set(int.parse(value))..setUpdated(false))
    .catchError((e) {
      if (e is IStoreException && e.code == 25006) return pk;
      throw e;
    });
  }

  static Future del(pk) {
    RedisClient handler = new IRedisHandlerPool().getWriteHandler(store, pk);

    return handler.del(_key)
    .then((bool result) {
      if (!result) new IStoreException(25007);
      return result;
    })
    .catchError(_handleErr);
  }

  static Future incr() {
    ${pkName} pk = new ${pkName}();
    RedisClient handler = new IRedisHandlerPool().getWriteHandler(store, pk);

    return handler.incr(_key)
    .then((num value) => pk..set(value)..setUpdated(false))
    .catchError(_handleErr);
  }

  static void _handleErr(e) => throw e;
}
''';
    return code;
  }

  String makeMariaDBPKStore(String name, Map orm, Map storeOrm) {
    String pkName = orm['className'];
    Map storeConfig = _getStoreConfig('mariaDB', storeOrm);
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

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, pk);
    return handler.prepareExecute('INSERT INTO `\${_table}` (`key`, `pk`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `pk` = ?;', [_key, value, value])
    .then((Results results) {
      if (results.affectedRows == 0) throw new IStoreException(21038);
      return pk..setUpdated(false);
    })
    .catchError(_handleErr);
  }

  static Future get() {
    ${pkName} pk = new ${pkName}();

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, pk);

    return handler.prepareExecute('SELECT `pk` FROM `\${_table}` WHERE `key` = ?', [_key])
    .then((Results results) => results.toList())
    .then((List list) {
      if (list.length == 0) return pk;
      return pk..set(list[0][0])..setUpdated(false);
    })
    .catchError(_handleErr);
  }

  static Future del(pk) {
    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, pk);

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

  String makeIndexedDBPKStore(String name, Map orm, Map storeOrm) {
    String pkName = orm['className'];
    Map storeConfig = _getStoreConfig('indexedDB', storeOrm);
    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${pkName}IndexedDBStore extends IIndexedDBStore {
  static const String OBJECT_STORE_PK_NAME = '_pk';
  static const String OBJECT_STORE_VALUE_NAME = 'value';

  static const String _objectStore = '${storeConfig['objectStore']}';
  static const String _key = '${storeConfig['key']}';

  static const Map store = const ${JSON.encode(storeConfig)};

  static Future set(${pkName} pk) {
    if (pk is! ${pkName}) throw new IStoreException(22011);
    if (!pk.isUpdated()) {
      new IStoreException(27002);
      Completer completer = new Completer();
      completer.complete(pk);
      return completer.future;
    }

    num value = pk.get();
    if (value is! num) throw new IStoreException(22012);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);
    return handler.put({ OBJECT_STORE_PK_NAME: _key, OBJECT_STORE_VALUE_NAME: value })
    .then((setKey) {
      return pk..setUpdated(false);
    }).catchError(_handleErr);
  }

  static Future get() {
    ${pkName} pk = new ${pkName}();

    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    return handler.getObject(_key)
    .then((result) {
      if (result == null) return pk;
      return pk..set(result[OBJECT_STORE_VALUE_NAME])..setUpdated(false);
    }).catchError(_handleErr);
  }

  static Future del() {
    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);
    return handler.delete(_key).catchError(_handleErr);
  }

  static void _handleErr(e) {
    if (e is Event) throw e.target.error;
    throw e;
  }
}
''';
    return code;
  }

  String makeCombinedPKStore(String name, Map orm, Map storeOrm) {
    String pkName = orm['className'];
    String firstStoreTypeName = makeUpperFirstLetter(storeOrm['storeOrder'].first['type']);
    String lastStoreTypeName = makeUpperFirstLetter(storeOrm['storeOrder'].last['type']);

    StringBuffer codeSB = new StringBuffer();
    codeSB.write('''
${_DECLARATION}
part of lib_${_app};

class ${pkName}Store {
  static int _step = ${storeOrm['backupStep']};

  static Future set(${pkName} pk) {
    num value = pk.get();
    List waitList = [];
    ${pkName} backupPK = _checkReachBackupStep(pk);
    if (backupPK != null) waitList.add(${pkName}${lastStoreTypeName}Store.set(backupPK));

    waitList.add(${pkName}${firstStoreTypeName}Store.set(pk));

    return Future.wait(waitList)
    .catchError(_handleErr);
  }

  static Future get() {
    return ${pkName}${firstStoreTypeName}Store.get()
    .then((${pkName} pk) {
      if (pk.get() != 0) return pk;
      if (_step == 0) return pk;
      return ${pkName}${lastStoreTypeName}Store.get();
    })
    .catchError(_handleErr);
  }

  static Future del(${pkName} pk) {
    List waitList = [];
    waitList.add(${pkName}${firstStoreTypeName}Store.del(pk));
    waitList.add(${pkName}${lastStoreTypeName}Store.del(pk));

    return Future.wait(waitList)
    .catchError(_handleErr);
  }

  static Future incr() {
    return ${pkName}${firstStoreTypeName}Store.incr()
    .then((${pkName} pk) {
      ${pkName} backupPK = _checkReachBackupStep(pk);
      if (backupPK == null) return pk;

      return ${pkName}${lastStoreTypeName}Store.set(backupPK)
      .then((_) => pk);
    })
    .catchError(_handleErr);
  }

  static ${pkName} _checkReachBackupStep(${pkName} pk) {
    if (!(_step != 0 && (pk.get() - 1) % _step == 0)) return null;
    return new ${pkName}()..set(pk.get() - 1 + _step);
  }

  static void _handleErr(e) => throw e;
}
''');
    return codeSB.toString();
  }

  String makeIndexedDBListStore(String name, Map orm, Map listOrm, Map storeOrm) {
    String listName = listOrm['className'];
    Map storeConfig = _getStoreConfig('indexedDB', storeOrm);

    List pkColumnName = [];

    listOrm['pk'].forEach((index) {
      pkColumnName.add(orm['column'][index]);
    });

    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${listName}IndexedDBStore extends IIndexedDBStore {
  static const String OBJECT_STORE_PK_NAME = '_pk';
  static const String OBJECT_STORE_INDEX_NAME = '_index';

  static const Map store = const ${JSON.encode(storeConfig)};

  static Future<${listName}> set(${listName} list) {
    if (list is! ${listName}) throw new IStoreException(22013);

    if (!list.isUpdated()) {
      new IStoreException(27003);
      Completer completer = new Completer();
      completer.complete(list);
      return completer.future;
    }

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    List waitList = [];
    list.getToAddList().forEach((String childId, ${name} model) {
      waitList.add(_addChild(model, handler));
    });

    list.getToSetList().forEach((String childId, ${name} model) {
      waitList.add(_setChild(model, handler));
    });

    list.getToDelList().forEach((String childId, ${name} model) {
      waitList.add(_delChild(model, handler));
    });

    return Future.wait(waitList)
    .then((_) => list..resetAllToList())
    .catchError(_handleErr);
  }

  static Future<${listName}> get(${pkColumnName.join(', ')}) {
    Completer completer = new Completer();
    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    ${listName} list = new ${listName}(${pkColumnName.join(', ')});

    handler.index(OBJECT_STORE_INDEX_NAME)
    .openCursor(key: list.getUnitedPK(), autoAdvance: true)
    .listen((CursorWithValue cursor) {
      list._set(new ${name}()..fromAbb(cursor.value));
    }, onDone: () {
      completer.complete(list);
    });

    return completer.future;
  }

  static Future del(${listName} list) {
    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    List waitList = [];
    list.getList().forEach((String childId, ${name} model) {
      waitList.add(_delChild(model, handler));
    });

    return Future.wait(waitList);
  }

  static Future _addChild(${name} model, ObjectStore handler) {
    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) {
      new IStoreException(27005);
      Completer completer = new Completer();
      completer.complete();
      return completer.future;
    }

    toAddAbb
      ..[OBJECT_STORE_PK_NAME] = model.getUnitedWholePK()
      ..[OBJECT_STORE_INDEX_NAME] = model.getUnitedListPK();

    return handler.add(toAddAbb)
    .then((setKey) => model..setUpdatedList(false))
    .catchError((e) {
      if (e is Event) {
        if (e.target.error.message == 'Key already exists in the object store.') {
          new IStoreException(27004);
          return;
        }
        throw e.target.error;
      }
      throw e;
    });
  }

  static Future _setChild(${name} model, ObjectStore handler) {
    // indexedDB do not like redis, put(set) will overwrite the whole key
    // so we use toSet filter the whole _args
    Map toSetAbb = {};
    ${name}._mapAbb.forEach((abb, i) {
      if (${name}._columns[i]['toSet']) return;
      toSetAbb[abb] = model._args[i];
    });

    if (toSetAbb.length == 0) new IStoreException(27006);

    toSetAbb
      ..[OBJECT_STORE_PK_NAME] = model.getUnitedWholePK()
      ..[OBJECT_STORE_INDEX_NAME] = model.getUnitedListPK();

    return handler.put(toSetAbb)
    .then((setKey) => model..setUpdatedList(false))
    .catchError(_handleErr);
  }

  static Future _delChild(${name} model, ObjectStore handler) {
    return handler.delete(model.getUnitedWholePK())
    .catchError(_handleErr);
  }

  static void _handleErr(e) {
    if (e is Event) throw e.target.error;
    throw e;
  }
}
''';
    return code;
  }

  void makeSubDir() {
    Directory coreDir = new Directory(_outStoreCoreDir);
    if (!coreDir.existsSync()) coreDir.createSync();

    Directory storeDir = new Directory(_outStoreDir);
    if (!storeDir.existsSync()) storeDir.createSync();
  }

  Map _getStoreConfig(String storeType, Map orm) {
    Map config = null;
    orm['storeOrder'].forEach((Map storeConfig) {
      if (storeConfig['type'] == storeType) config = storeConfig;
    });
    return config;
  }
}
