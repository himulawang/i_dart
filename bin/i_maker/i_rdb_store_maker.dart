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

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, pk);
    return handler.set(_key, value.toString())
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20036);
      return pk..setUpdated(false);
    })
    .catchError(_handleErr);
  }

  static Future get() {
    ${pkName} pk = new ${pkName}();

    IRedis handler = new IRedisHandlerPool().getReaderHandler(store, pk);

    return handler.exists(_key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(25006);
      return handler.get(_key);
    })
    .then((String value) => pk..set(int.parse(value))..setUpdated(false))
    .catchError((e) {
      if (e is IStoreException && e.code == 25006) return pk;
      throw e;
    });
  }

  static Future del(pk) {
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, pk);

    return handler.del(_key)
    .then((num deletedNum) {
      if (deletedNum == 0) new IStoreException(25007);
      return deletedNum;
    })
    .catchError(_handleErr);
  }

  static Future incr() {
    ${pkName} pk = new ${pkName}();
    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, pk);

    return handler.incr(_key)
    .then((num value) => pk..set(value)..setUpdated(false))
    .catchError(_handleErr);
  }

  static void _handleErr(e) => throw e;
}
''';
    return code;
  }

  String makeRedisListStore(String name, Map orm, Map storeOrm) {

  }

  String _makeRedisAdd(String name, Map orm, Map storeConfig) {
    String codeHeader = '''
  static Future add(${name} model) {
    if (model is! ${name}) throw new IStoreException(20022);

    String key = _makeKey(model);

    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032);

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model);

    return handler.exists(key)
    .then((int exists) {
      if (exists == 1) throw new IStoreException(20024);
      return handler.hmset(key, toAddAbb);
    })
''';

    String codeAddWithExpire = '''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20025);
      return handler.expire(key, ${storeConfig['expire']});
    })
    .then((int result) {
      if (result == 1) return model;
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

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model);

    return handler.exists(key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(20028);
      if (toSetAbb.length == 0)  throw new IStoreException(25001);

      return handler.hmset(key, toSetAbb);
    })
''';

    String codeSetWithExpire = '''
    .then((String result) {
      if (result != 'OK') throw new IStoreException(20029);
      return handler.expire(key, ${storeConfig['expire']});
    })
    .then((int result) {
      if (result == 1) return model;
      new IStoreException(25010);
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

    IRedis handler = new IRedisHandlerPool().getReaderHandler(store, model);

    return handler.exists(key)
    .then((int exists) {
      if (exists == 0) throw new IStoreException(25003);
      return handler.hmget(key, new List.from(model.getMapAbb().keys));
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

    IRedis handler = new IRedisHandlerPool().getWriteHandler(store, model);

    String key = _makeKey(model);

    return handler.del(key)
    .then((int result) {
      if (result == 0) new IStoreException(25002);
      return result;
    })
    .catchError(_handleErr);
  }

''';
    return code;
  }

}
