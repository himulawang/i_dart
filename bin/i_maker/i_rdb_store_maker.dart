part of i_maker;

abstract class IRedisStoreMaker {
  String makeRedisStore(String name, Map orm, Map storeOrm) {
    Map storeConfig = _getStoreConfig('redis', storeOrm);
    if (storeConfig == null) return '';

    String codeHeader = '''
${_DECLARATION}
part of lib_${_app};

class ${name}RedisStore extends IRedisStore {
  static const String abb = '${storeConfig['abb']}';
  static const Map store = const ${JSON.encode(storeConfig)};
  static const String _modelName = '${name}';

''';

    String codeFooter = '''
  static String _makeKey(${name} model) {
    var pk = model.getPK();
    if (pk is List) {
      if (pk.contains(null)) throw new IStoreException(20042, ['${name}']);
      return '\$\{abb}:\$\{pk.join(':')}';
    } else {
      if (pk == null) throw new IStoreException(20042, ['${name}}']);
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

  String makeRedisPKStore(String name, Map orm, Map storeOrm) {
    Map storeConfig = _getStoreConfig('redis', storeOrm);
    if (storeConfig == null) return '';

    String pkName = orm['className'];

    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${pkName}RedisStore extends IRedisStore {
  static const String _key = '${storeConfig['abb']}-pk';
  static const String _pkName = '${pkName}';

  static const Map store = const ${JSON.encode(storeConfig)};

  static Future set(${pkName} pk) {
    if (pk is! ${pkName}) throw new IStoreException(20034, [pk.runtimeType, _pkName]);
    if (!pk.isUpdated()) {
      new IStoreException(20505, ['${pkName}']);
      Completer completer = new Completer();
      completer.complete(pk);
      return completer.future;
    }

    num value = pk.get();
    if (value is! num) throw new IStoreException(20035, [_pkName, value]);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, _key);
    return handler.set(_key, value.toString())
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20036, [_pkName]);
      return pk..setUpdated(false);
    })
    .catchError(_handleErr);
  }

  static Future get() {
    ${pkName} pk = new ${pkName}();

    IRedis handler = new IRedisHandlerPool().getReaderHandler(store, _key);

    return handler.exists(_key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(20506, [_pkName]);
      return handler.get(_key);
    })
    .then((String value) => pk..set(int.parse(value))..setUpdated(false))
    .catchError((e) {
      if (e is IStoreException && e.code == 20506) return pk;
      throw e;
    });
  }

  static Future del(pk) {
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, _key);

    return handler.del(_key)
    .then((num deletedNum) {
      if (deletedNum == 0) new IStoreException(20507, [_pkName]);
      return deletedNum;
    })
    .catchError(_handleErr);
  }

  static Future incr() {
    ${pkName} pk = new ${pkName}();
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, _key);

    return handler.incr(_key)
    .then((num value) => pk..set(value)..setUpdated(false))
    .catchError(_handleErr);
  }

  static void _handleErr(e) => throw e;
}
''';
    return code;
  }

  String makeRedisListStore(String name, Map orm, Map listOrm, Map storeOrm) {
    Map storeConfig = _getStoreConfig('redis', storeOrm);
    if (storeConfig == null) return '';

    String listName = listOrm['className'];

    List pkColumnName = [];

    listOrm['pk'].forEach((index) {
      pkColumnName.add(orm['column'][index]);
    });

    StringBuffer codeSB = new StringBuffer();

    codeSB.write('''
${_DECLARATION}
part of lib_${_app};

class ${listName}RedisStore extends IRedisStore {
  static const Map store = const ${JSON.encode(storeConfig)};
  static const String abb = '${storeConfig['abb']}';
  static const num expire = ${storeConfig['expire']};

  static const String _listName = '${listName}';
  static const String _modelName = '${name}';
  static const String _typeDelimiter = '_';
  static const String _fieldDelimiter = '-';
  static const String _keyDelimiter = ':';

  static Future<${listName}> set(${listName} list) {
    if (list is! ${listName}) throw new IStoreException(20040, [list.runtimeType, _listName]);

    if (!list.isUpdated()) {
      new IStoreException(20509, [_listName]);
      Completer completer = new Completer();
      completer.complete(list);
      return completer.future;
    }

    String listKey = _makeListKey(list);
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    List waitList = [];

    list.getToAddList().forEach((String childId, ${name} model) {
      String childKey = _makeChildKey(list, model);
      waitList..add(_addChild(listKey, childKey, model))
        ..add(handler.sadd(listKey, childKey));
    });

    list.getToSetList().forEach((String childId, ${name} model) {
      String childKey = _makeChildKey(list, model);
      waitList.add(_setChild(listKey, childKey, model));
    });

    list.getToDelList().forEach((String childId, ${name} model) {
      String childKey = _makeChildKey(list, model);
      waitList..add(_delChild(listKey, childKey, model))
        ..add(handler.srem(listKey, childId.toString()));
    });
''');

    if (storeConfig['expire'] != 0) {
      codeSB.write('''

    // if this list is not in redis, we set expireTime
    // otherwise, we use get function to set expireTime
    if (!list.isExist()) waitList.add(handler.expire(listKey, expire));
''');
    }

    codeSB.write('''

    return Future.wait(waitList)
    .then((_) => list)
    .catchError(_handleErr);
  }

  static Future<${listName}> get(${pkColumnName.join(', ')}) {
    ${listName} list = new ${listName}(${pkColumnName.join(', ')});

    String listKey = _makeListKey(list);
    IRedis handler = new IRedisHandlerPool().getReaderHandler(store, listKey);

    return handler.smembers(listKey)
    .then((List result) {
      if (result.length == 0) throw new IStoreException(20508, [_listName]);

      List waitList = [];
      result.forEach((String childKey) {
        ${name} model = new ${name}();

        waitList.add(
          handler.exists(childKey)
          .then((int exists) {
            if (exists == 0) throw new IStoreException(20503, [_listName]);
            return handler.hmget(childKey, new List.from(model.getMapAbb().keys));
          })
          .then((List data) {
            model..fromList(data)..setExist();
            list._set(model);
          })
          .catchError((e) {
            if (e is IStoreException && e.code == 20503) return model;
            throw e;
          })
        );
      });

      return Future.wait(waitList).then((_) => list..setExist());
    })
    .catchError((e) {
      if (e is IStoreException && e.code == 20508) return list;
      throw e;
    });
  }

  static Future del(${listName} list) {
    if (list is! ${listName}) throw new IStoreException(20038, [list.runtimeType, _listName]);

    String listKey = _makeListKey(list);
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    List waitList = [];
    list.getList().forEach((String childId, ${name} model) {
      String childKey = _makeChildKey(list, model);
      waitList.add(_delChild(listKey, childKey, model));
    });

    waitList.add(handler.del(listKey));

    return Future.wait(waitList)
    .catchError(_handleErr);
  }

  static Future _addChild(String listKey, String key, ${name} model) {
    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032, [_modelName]);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    return handler.exists(key)
    .then((int exists) {
      if (exists == 1) throw new IStoreException(20024, [_modelName]);
      return handler.hmset(key, toAddAbb);
    })
''');

    if (storeConfig['expire'] != 0) {
      codeSB.write('''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20025, [_modelName]);
      return handler.expire(key, expire);
    })
    .then((int result) {
      if (result == 1) return model;
      new IStoreException(20504, [_modelName]);
      return model;
    })
''');
    } else {
      codeSB.write('''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20025, [_modelName]);
      return model;
    })
''');
    }

    codeSB.write('''
    .catchError(_handleErr);
  }

  static Future _setChild(String listKey, String key, ${name} model) {
    Map toSetAbb = model.toSetAbb(true);
    if (toSetAbb.length == 0) {
      new IStoreException(20501, [_modelName]);
      Completer completer = new Completer();
      completer.complete(model);
      return completer.future;
    }

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    return handler.exists(key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(20028, [_modelName]);
      return handler.hmset(key, toSetAbb);
    })
    ''');

    if (storeConfig['expire'] != 0) {
      codeSB.write('''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20029, [_modelName]);
      return handler.expire(key, expire);
    })
    .then((int result) {
      if (result == 1) return model;
      new IStoreException(20510, [_modelName]);
      return model;
    })
''');
    } else {
      codeSB.write('''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20029, [_modelName]);
      return model;
    })
''');
    }

    codeSB.write('''
    .catchError(_handleErr);
  }

  static Future _delChild(String listKey, String key, ${name} model) {
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, listKey);

    return handler.del(key)
    .then((num deletedNum) {
      if (deletedNum == 0) new IStoreException(20502, [_modelName]);
      return deletedNum;
    })
    .catchError(_handleErr);
  }

  static String _makeListKey(${listName} list)
    => '\${abb}\${_typeDelimiter}l\${_fieldDelimiter}\${list.getPK().join(_keyDelimiter)}';

  static String _makeChildKey(${listName} list, ${name} model)
    => '\${abb}\${_typeDelimiter}c\${_fieldDelimiter}\${list.getPK().join(_keyDelimiter)}\${_fieldDelimiter}\${model.getChildPK().join(_keyDelimiter)}';

  static void _handleErr(e) => throw e;
}
''');

    return codeSB.toString();
  }

  String _makeRedisAdd(String name, Map orm, Map storeConfig) {
    String codeHeader = '''
  static Future add(${name} model) {
    if (model is! ${name}) throw new IStoreException(20022, [model.runtimeType, _modelName]);

    String key = _makeKey(model);

    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032, [_modelName]);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model.getUnitedPK());

    return handler.exists(key)
    .then((int exists) {
      if (exists == 1) throw new IStoreException(20024, [_modelName]);
      return handler.hmset(key, toAddAbb);
    })
''';

    String codeAddWithExpire = '''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20025, [_modelName]);
      return handler.expire(key, ${storeConfig['expire']});
    })
    .then((int result) {
      if (result == 1) return model;
      new IStoreException(20504, [_modelName]);
      return model;
    })
''';

    String codeAddWithoutExpire = '''
    .then((String result) {
      if (result != 'OK') throw IStoreException(20025, [_modelName]);
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
    if (model is! ${name}) throw new IStoreException(20026, [model.runtimeType, _modelName]);

    String key = _makeKey(model);

    Map toSetAbb = model.toSetAbb(true);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model.getUnitedPK());

    return handler.exists(key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(20028, [_modelName]);
      if (toSetAbb.length == 0)  throw new IStoreException(20501, [_modelName]);

      return handler.hmset(key, toSetAbb);
    })
''';

    String codeSetWithExpire = '''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20029, [_modelName]);
      return handler.expire(key, ${storeConfig['expire']});
    })
    .then((int result) {
      if (result == 1) return model;
      new IStoreException(20510, [_modelName]);
      return model;
    })
''';

    String codeSetWithoutExpire = '''
    .then((String result) {
      if (result != 'OK') throw IStoreException(20029, [_modelName]);
      return model;
    })
''';

    String codeFooter = '''
    .catchError((e) {
      if (e is IStoreException && e.code == 20501) return model;
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
    if (model is! ${name}) throw new IStoreException(20030, [model.runtimeType, _modelName]);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model.getUnitedPK());

    String key = _makeKey(model);

    return handler.del(key)
    .then((int result) {
      if (result == 0) new IStoreException(20502, [_modelName]);
      return result;
    })
    .catchError(_handleErr);
  }

''';
    return code;
  }

}
