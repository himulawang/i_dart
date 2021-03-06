part of i_maker;

class IStoreMaker extends IMaker with
  IRedisStoreMaker,
  IMariaDBStoreMaker,
  IIndexedDBStoreMaker,
  IServerCombinedStoreMaker {

  Map _orm;
  String _outStoreDir;

  IStoreMaker(Map deploy, Map orm) : super(deploy) {
    _orm = orm;
  }

  void makeServer() {
    _outStoreDir = '${_appPath}/store';

    makeSubDir();

    _orm.forEach((String name, Map orm) {
      String lowerName = makeLowerUnderline(name);
      String redisCode, mariaDBCode, combinedCode;
      if (orm.containsKey('PK') && orm.containsKey('PKStore')) {
        // redis
        redisCode = makeRedisPKStore(name, orm['PK'], orm['PKStore']);
        if (!redisCode.isEmpty) writeFile('${lowerName}_pk_rdb_store.dart', _outStoreDir, redisCode, true);

        // mariaDB
        mariaDBCode = makeMariaDBPKStore(name, orm['PK'], orm['PKStore']);
        if (!mariaDBCode.isEmpty) writeFile('${lowerName}_pk_mdb_store.dart', _outStoreDir, mariaDBCode, true);

        // combined
        combinedCode = makeServerCombinedPKStore(name, orm['PK'], orm['PKStore']);
        if (!combinedCode.isEmpty) writeFile('${lowerName}_pk_store.dart', _outStoreDir, combinedCode, true);
      }
      if (orm.containsKey('Model') && orm.containsKey('ModelStore')) {
        // redis
        redisCode = makeRedisStore(name, orm['Model'], orm['ModelStore']);
        if (!redisCode.isEmpty) writeFile('${lowerName}_rdb_store.dart', _outStoreDir, redisCode, true);

        // mariaDB
        mariaDBCode = makeMariaDBStore(name, orm['Model'], orm['ModelStore']);
        if (!mariaDBCode.isEmpty) writeFile('${lowerName}_mdb_store.dart', _outStoreDir, mariaDBCode, true);

        // combined
        combinedCode = makeServerCombinedStore(name, orm['Model'], orm['ModelStore']);
        if (!combinedCode.isEmpty) writeFile('${lowerName}_store.dart', _outStoreDir, combinedCode, true);
      }
      if (orm.containsKey('List') && orm.containsKey('ListStore')) {
        // redis
        redisCode = makeRedisListStore(name, orm['Model'], orm['List'], orm['ListStore']);
        if (!redisCode.isEmpty) writeFile('${lowerName}_list_rdb_store.dart', _outStoreDir, redisCode, true);

        // mariaDB
        mariaDBCode = makeMaraiaDBListStore(name, orm['Model'], orm['List'], orm['ListStore']);
        if (!mariaDBCode.isEmpty) writeFile('${lowerName}_list_mdb_store.dart', _outStoreDir, mariaDBCode, true);

        // combined
        combinedCode = makeServerCombinedListStore(name, orm['Model'], orm['List'], orm['ListStore']);
        if (!combinedCode.isEmpty) writeFile('${lowerName}_list_store.dart', _outStoreDir, combinedCode, true);
      }
    });

  }

  void makeClient() {
    _outStoreDir = '${_appPath}/store';

    makeSubDir();

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

  void makeSubDir() {
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
