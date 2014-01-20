part of i_maker;

class IStoreMaker extends IMaker {
  Map _orm;
  String _outStoreCoreDir;
  String _srcStoreCoreDir;
  String _outStoreDir;

  IStoreMaker(Map deploy, Map orm) : super(deploy) {
    _orm = orm;
  }

  void make() {
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
      /*
      if (orm['type'] == 'Model') {
        // redis
        String redisCode = makeRedisStore(orm);
        if (!redisCode.isEmpty) writeFile('${lowerName}_rdb_store.dart', _outStoreDir, redisCode, true);

        // mariaDB
        String mariaDBCode = makeMariaDBStore(orm);
        if (!mariaDBCode.isEmpty) writeFile('${lowerName}_mdb_store.dart', _outStoreDir, mariaDBCode, true);

        // combined
        String combinedCode = makeCombinedStore(orm);
        if (!combinedCode.isEmpty) writeFile('${lowerName}_store.dart', _outStoreDir, combinedCode, true);
      } else if (orm['type'] == 'PK') {
        // redis
        String redisCode = makeRedisPKStore(orm);
        if (!redisCode.isEmpty) writeFile('${lowerName}_pk_rdb_store.dart', _outStoreDir, redisCode, true);

        // mariaDB
        String mariaDBCode = makeMariaDBPKStore(orm);
        if (!mariaDBCode.isEmpty) writeFile('${lowerName}_pk_mdb_store.dart', _outStoreDir, mariaDBCode, true);

        // combined
        String combinedCode = makeCombinedPKStore(orm);
        if (!combinedCode.isEmpty) writeFile('${lowerName}_pk_store.dart', _outStoreDir, combinedCode, true);
      }
      */
    });

  }

  String makeRedisStore(Map orm) {
    Map storeConfig = _getStoreConfig('redis', orm);
    if (storeConfig == null) return '';

    String codeHeader = '''
${_DECLARATION}
part of lib_${_app};

class ${orm['name']}RedisStore extends IRedisStore {
  static const String abb = '${orm['abb']}';

''';

    String codeFooter = '''
  static String _makeAbbModelKey(String abb, num pk) => '\$\{abb}:\$\{pk.toString()}';

  static void _handleErr(e) => throw e;
}
''';

    StringBuffer codeSB = new StringBuffer();
    codeSB.write(codeHeader);

    Map store = _getStoreConfig('redis', orm);
    codeSB.writeln('  static const Map store = const ${JSON.encode(store)};');
    codeSB.writeln('');

    codeSB.writeAll([
        _makeRedisAdd(orm, storeConfig),
        _makeRedisSet(orm, storeConfig),
        _makeRedisGet(orm, storeConfig),
        _makeRedisDel(orm, storeConfig),
        codeFooter
    ]);

    return codeSB.toString();
  }

  String _makeRedisAdd(Map orm, Map storeConfig) {
    String codeHeader = '''
  static Future add(${orm['name']} model, [String abbListKey = null]) {
    if (model is! ${orm['name']}) throw new IStoreException(20022);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(20023);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(store, model);

    String abbPrefix = abbListKey == null ? abb : abbListKey;
    String abbModelKey = _makeAbbModelKey(abbPrefix, pk);

    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032);

    return handler.exists(abbModelKey)
    .then((bool exist) {
      if (exist) throw new IStoreException(20024);
      return handler.hmset(abbModelKey, toAddAbb);
    })
''';

    String codeAddWithExpire = '''
    .then((String result) {
      if (result != 'OK') throw IStoreException(20025);
      return handler.expire(abbModelKey, ${storeConfig['expire']});
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

  String _makeRedisSet(Map orm, Map storeConfig) {
    String codeHeader = '''
  static Future set(${orm['name']} model, [String abbListKey = null]) {
    if (model is! ${orm['name']}) throw new IStoreException(20026);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(20027);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(store, model);

    String abbPrefix = abbListKey == null ? abb : abbListKey;
    String abbModelKey = _makeAbbModelKey(abbPrefix, pk);

    Map toSetAbb = model.toSetAbb(true);

    return handler.exists(abbModelKey)
    .then((bool exist) {
      if (!exist) throw new IStoreException(20028);
      if (toSetAbb.length == 0)  throw new IStoreException(25001);

      return handler.hmset(abbModelKey, toSetAbb);
    })
''';

    String codeSetWithExpire = '''
    .then((String result) {
      if (result != 'OK') throw IStoreException(20029);
      return handler.expire(abbModelKey, ${storeConfig['expire']});
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

  String _makeRedisGet(Map orm, Map storeConfig) {
    String code = '''
  static Future get(num pk, [String abbListKey = null]) {
    if (pk is! num) throw new IStoreException(20021);

    ${orm['name']} model = new ${orm['name']}()..setPK(pk);
    RedisClient handler = new IRedisHandlerPool().getReaderHandler(store, model);

    String abbPrefix = abbListKey == null ? abb : abbListKey;
    String abbModelKey = _makeAbbModelKey(abbPrefix, pk);

    return handler.exists(abbModelKey)
    .then((bool exist) {
      if (!exist) throw new IStoreException(25003);
      return handler.hmget(abbModelKey, model.getMapAbb().keys);
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

  String _makeRedisDel(Map orm, Map storeConfig) {
    String code = '''
  static Future del(input, [String abbListKey = null]) {
    num pk;
    ${orm['name']} model;
    if (input is ${orm['name']}) {
      model = input;
      pk = model.getPK();
    } else {
      model = new ${orm['name']}()..setPK(input);
      pk = input;
    }
    if (pk is! num) throw new IStoreException(20030);

    RedisClient handler = new IRedisHandlerPool().getReaderHandler(store, model);

    String abbPrefix = abbListKey == null ? abb : abbListKey;
    String abbModelKey = _makeAbbModelKey(abbPrefix, pk);

    return handler.del(abbModelKey)
    .then((bool result) {
      if (!result) new IStoreException(25002);
      return result;
    })
    .catchError(_handleErr);
  }

''';
    return code;
  }

  String makeMariaDBStore(Map orm) {
    Map store = _getStoreConfig('mariaDB', orm);
    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${orm['name']}MariaDBStore extends IMariaDBStore {
  static const Map store = const ${JSON.encode(store)};
  static const String table = '${store['table']}';

  static Future add(${orm['name']} model) {
    if (model is! ${orm['name']}) throw new IStoreException(21023);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(21024);

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

  static Future set(${orm['name']} model) {
    if (model is! ${orm['name']}) throw new IStoreException(21026);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(21027);

    Map toSetList = model.toSetList(true);
    if (toSetList.length == 0) {
      new IStoreException(26001);
      Completer completer = new Completer();
      completer.complete(model);
      return completer.future;
    }

    ConnectionPool handler = new IMariaDBHandlerPool().getWriteHandler(store, model);

    return handler.prepareExecute(IMariaDBSQLPrepare.makeSet(table, model), toSetList..add(model.getPK()))
    .then((Results results) {
      if (results.affectedRows == 0) new IStoreException(26002);
      if (results.affectedRows > 1) new IStoreException(26003);
      return model;
    }).catchError(_handleErr);
  }

  static Future get(num pk) {
    if (pk is! num) throw new IStoreException(21021);

    ${orm['name']} model = new ${orm['name']}()..setPK(pk);
    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, model);

    return handler.prepareExecute(IMariaDBSQLPrepare.makeGet(table, model), [pk])
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
    ${orm['name']} model;
    if (input is ${orm['name']}) {
      model = input;
      pk = model.getPK();
    } else {
      model = new ${orm['name']}()..setPK(input);
      pk = input;
    }
    if (pk is! num) throw new IStoreException(21034);

    ConnectionPool handler = new IMariaDBHandlerPool().getReaderHandler(store, model);
    return handler.prepareExecute(IMariaDBSQLPrepare.makeDel(table, model), [pk])
    .then((Results results) {
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

  String makeCombinedStore(Map orm) {
    List storeOrder = orm['storeOrder'];

    String codeHeader = '''
${_DECLARATION}
part of lib_${_app};

class ${orm['name']}Store {
''';

    String codeFooter = '''
}
''';

    StringBuffer codeSB = new StringBuffer();
    codeSB.write(codeHeader);

    // add
    codeSB.writeln('  static Future add(${orm['name']} model) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(orm['storeOrder'][i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${orm['name']}${upperType}Store.add(model)');
      } else {
        codeSB.writeln('    .then((_) => ${orm['name']}${upperType}Store.add(model))');
      }
    }
    codeSB..writeln('    .then((${orm['name']} model) => model..setUpdatedList(false))')
          ..writeln('    ;')
          ..writeln('  }')
          ..writeln('');

    // set
    codeSB.writeln('  static Future set(${orm['name']} model) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(orm['storeOrder'][i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${orm['name']}${upperType}Store.set(model)');
      } else {
        codeSB.writeln('    .then((_) => ${orm['name']}${upperType}Store.set(model))');
      }
    }
    codeSB..writeln('    .then((${orm['name']} model) => model..setUpdatedList(false))')
          ..writeln('    ;')
          ..writeln('  }')
          ..writeln('');

    // get
    codeSB.writeln('  static Future get(num pk) {');
    for (int i = 0; i < storeOrder.length; ++i) {
      String upperType = makeUpperFirstLetter(orm['storeOrder'][i]['type']);
      if (i == 0) {
        codeSB..writeln('    return ${orm['name']}${upperType}Store.get(pk)');
      } else {
        codeSB..writeln('    .then((${orm['name']} model) {')
              ..writeln('      if (model.isExist()) return model;')
              ..writeln('      return ${orm['name']}${upperType}Store.get(pk);')
              ..writeln('    })');
      }
    }

    codeSB..writeln('    ;')
      ..writeln('  }')
      ..writeln('');

    // del
    codeSB.writeln('  static Future del(input) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(orm['storeOrder'][i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${orm['name']}${upperType}Store.del(input)');
      } else {
        codeSB.writeln('    .then((_) => ${orm['name']}${upperType}Store.del(input))');
      }
    }
    codeSB..writeln('    ;')
      ..writeln('  }');

    codeSB.write(codeFooter);
    return codeSB.toString();
  }

  String makeRedisPKStore(String name, Map pkOrm, Map storeOrm) {
    String pkName = pkOrm['className'];
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

  String makeMariaDBPKStore(String name, Map pkOrm, Map storeOrm) {
    String pkName = pkOrm['className'];
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

  String makeCombinedPKStore(String name, Map pkOrm, Map storeOrm) {
    String pkName = pkOrm['className'];
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
