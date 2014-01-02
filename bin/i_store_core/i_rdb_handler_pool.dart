/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

class IRedisHandlerPool {
  static bool _initialized = false;
  static IRedisHandlerPool _instance;

  static final Map dbs = <String, List<RedisClient>>{};
  static final Map nodesLength = <String, int>{};

  Future init(Map config) {
    // for configs
    List waitList = [];
    config.forEach((String groupName, List group) {
      // get groupName
      dbs[groupName] = new List(group.length);
      nodesLength[groupName] = group.length;

      // for nodes
      group.forEach((Map node) {
        String connectionString = _makeConnectionString(node);
        waitList.add(
            RedisClient.connect(connectionString).then((RedisClient client) {
              dbs[groupName][node['no']] = client;
            }).catchError(_handleErr)
        );
      });
    });
    return Future.wait(waitList).then((_) => print('Redis connected.'));
  }

  factory IRedisHandlerPool([Map config = null]) {
    if (_initialized) return _instance;

    _initialized = true;
    _instance = new IRedisHandlerPool._internal();

    return _instance;
  }

  IRedisHandlerPool._internal();

  static String _makeConnectionString(Map node) {
    // check node config
    if (!node.containsKey('no')) throw new IStoreException(20001);
    if (!node.containsKey('host')) throw new IStoreException(20002);
    if (!node.containsKey('port')) throw new IStoreException(20003);
    if (!node.containsKey('pwd')) throw new IStoreException(20004);
    if (!node.containsKey('db')) throw new IStoreException(20005);

    StringBuffer connectionSB = new StringBuffer();

    if (node['pwd'] is String) {
      connectionSB.writeAll([node['pwd'], '@']);
    }

    if (node['host'] is! String) throw new IStoreException(20006);
    connectionSB.write(node['host']);

    connectionSB.write(':');
    if (node['port'] is int) {
      connectionSB.write(node['port'].toString());
    } else {
      connectionSB.write('6379');
    }

    if (node['db'] is String) {
      connectionSB.writeAll(['/', node['db']]);
    }

    return connectionSB.toString();
  }

  static void _handleErr(err) {
    throw err;
  }

  RedisClient getWriteHandler(model) {
    num pk = model.getPK();

    Map redisStore = model.getRedisStore();
    String groupType = 'master';
    String groupName = redisStore[groupType];

    int modValue = nodesLength[groupName];
    String shardMethod = redisStore['shardMethod'];

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

  RedisClient getReaderHandler(model) {
    num pk = model.getPK();

    Map redisStore = model.getRedisStore();
    String groupType = redisStore['readWriteSeparate'] ? 'master' : 'slave';
    String groupName = redisStore[groupType];

    int modValue = nodesLength[groupName];
    String shardMethod = redisStore['shardMethod'];

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

