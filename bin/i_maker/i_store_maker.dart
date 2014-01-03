part of i_maker;

class IStoreMaker extends IMaker {
  List _orm;
  String _outStoreCoreDir;
  String _srcStoreCoreDir;
  String _outStoreDir;

  IStoreMaker(Map deploy, List orm) : super(deploy) {
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

    _orm.forEach((orm) {
      String lowerName = makeLowerUnderline(orm['name']);
      writeFile('${lowerName}_rdb_store.dart', _outStoreDir, makeRedisStore(orm), true);
    });
  }

  String makeRedisStore(Map orm) {
    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${orm['name']}RedisStore extends IRedisStore {
  static Future add(${orm['name']} model) {
    if (model is! ${orm['name']}) throw new IStoreException(20022);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(20023);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(model);

    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(20032);

    return handler.exists(abbModelKey)
    .then((bool exist) {
      // model exist
      if (exist) throw new IStoreException(20024);

      return toAddAbb;
    })
    .then((Map toAddAbb) => handler.hmset(abbModelKey, toAddAbb))
    .then((String result) {
      if (result != 'OK') throw IStoreException(20025);
      return model;
    })
    .catchError(_handleErr);
  }

  static Future set(${orm['name']} model) {
    if (model is! ${orm['name']}) throw new IStoreException(20026);

    num pk = model.getPK();
    if (pk is! num) throw new IStoreException(20027);

    RedisClient handler = new IRedisHandlerPool().getWriteHandler(model);
    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    Map toSetAbb = model.toSetAbb(true);
    if (toSetAbb.length == 0) throw new IStoreException(25001);

    return handler.exists(abbModelKey)
    .then((bool exist) {
      // model exist
      if (!exist) throw new IStoreException(20033);

      return handler.hmset(abbModelKey, toSetAbb);
    })
    .then((String result) {
      if (result != 'OK') throw IStoreException(20029);
      model.setUpdatedList(false);
      return model;
    })
    .catchError(_handleErr);
  }

  static Future get(num pk) {
    if (pk is! num) throw new IStoreException(20021);

    ${orm['name']} model = new ${orm['name']}()..setPK(pk);
    RedisClient handler = new IRedisHandlerPool().getReaderHandler(model);
    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    return handler.exists(abbModelKey)
    .then((bool exist) {
      if (!exist) throw new IStoreException(25003);
    })
    .then((_) => handler.hmget(abbModelKey, model.getMapAbb().keys))
    .then((List data) => model..fromList(data)..setExist())
    .catchError((e) {
      if (e is IStoreException && e.code == 25003) return model;
      throw e;
    });
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
    if (pk is! num) throw new IStoreException(20030);

    RedisClient handler = new IRedisHandlerPool().getReaderHandler(model);
    String abbModelKey = _makeAbbModelKey(model.getAbb(), pk);

    return handler.del(abbModelKey)
    .then((bool result) {
      // TODO change this to warning
      if (!result) new IStoreException(25002);
      return result;
    })
    .catchError(_handleErr);
  }

  static String _makeAbbModelKey(String abb, num pk) => '\$\{abb}:\$\{pk.toString()}';

  static void _handleErr(err) => throw err;
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
}
