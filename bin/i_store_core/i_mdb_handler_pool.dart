part of lib_i_model;

class IMariaDBHandlerPool {
  static bool _initialized = false;
  static IMariaDBHandlerPool _instance;

  static final Map dbs = <String, List<int, RedisClient>>{};
  static final Map nodesLength = <String, int>{};

  factory IMariaDBHandlerPool([Map config = null]) {
    if (_initialized) return _instance;

    _initialized = true;
    _instance = new IMariaDBHandlerPool._internal(config);

    config.forEach((String groupName, List group) {
      // get groupName
      dbs[groupName] = new List<int, ConnectionPool>(group.length);
      nodesLength[groupName] = group.length;

      // for nodes
      group.forEach((Map node) {
        _checkNodeConfig(node);

        dbs[groupName][node['no']] = new ConnectionPool(
          host: node['host'],
          port: node['port'],
          user: node['usr'],
          password: node['pwd'],
          db: node['db'],
          max: node['maxHandler']
        );
      });
    });
    return _instance;
  }

  IMariaDBHandlerPool._internal(Map config);

  static void _checkNodeConfig(node) {
    // check node config
    if (!node.containsKey('no')) throw new IStoreException(21001);
    if (!node.containsKey('host')) throw new IStoreException(21002);
    if (!node.containsKey('port')) throw new IStoreException(21003);
    if (!node.containsKey('pwd')) throw new IStoreException(21004);
    if (!node.containsKey('db')) throw new IStoreException(21005);
    if (!node.containsKey('usr')) throw new IStoreException(21006);
    if (!node.containsKey('maxHandler')) throw new IStoreException(21007);
  }

  ConnectionPool getWriteHandler(M model) {
    num pk = model.getPK();

    Map mariaDBStore = model.getMariaDBStore();
    String groupType = 'master';
    String groupName = mariaDBStore[groupType];

    int modValue = nodesLength[groupName];
    String shardMethod = mariaDBStore['shardMethod'];

    int shardIndex;
    switch (shardMethod) {
      case 'CRC32':
        shardIndex = CRC32.compute(pk.toString()) % modValue;
        break;
      default:
        throw new IStoreException(20008);
    }

    return dbs[groupName][shardIndex];
  }

  ConnectionPool getReaderHandler(M model) {
    num pk = model.getPK();

    Map mariaDBStore = model.getMariaDBStore();
    String groupType = mariaDBStore['readWriteSeparate'] ? 'master' : 'slave';
    String groupName = mariaDBStore[groupType];

    int modValue = nodesLength[groupName];
    String shardMethod = mariaDBStore['shardMethod'];

    int shardIndex;
    switch (shardMethod) {
      case 'CRC32':
        shardIndex = CRC32.compute(pk.toString()) % modValue;
        break;
      default:
        throw new IStoreException(20008);
    }

    return dbs[groupName][shardIndex];
  }
}
