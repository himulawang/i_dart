library i_dart;

import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';

main(List<String> args) {
  if (args.length == 0) return print('Please enter a command.');
  var parser = new ArgParser();
  var initParser = new ArgParser();

  parser.addCommand('init', initParser);

  initParser.addOption('name', abbr: 'n');
  initParser.addOption('type', abbr: 't', defaultsTo: 'server', allowed: ['client', 'server']);

  var results;
  try {
    results = parser.parse(args);
  } catch (e) {
    return print('We cannot parse your command');
  }

  if (results.command.name != 'init') return print('Unknow command');

  String appName;
  String appType;
  try {
    appName = results.command['name'];
    appType = results.command['type'];
  } catch (e) {
    return print('We need a application name.');
  }

  var init = new Init(appName, appType);

  print('''
--- init start ---

Name: ${appName}
Type: ${appType}
Path: ${Init.appPath}
''');

  init.run();

}

class Init {
  static String appName;
  static String appType;
  static String appPath;
  static Map serverConfigFiles;
  static Map serverRouteFiles;
  static Map clientConfigFiles;
  static Map clientRouteFiles;

  Init(String rawAppName, String rawAppType) {
    appName = rawAppName;
    appType = rawAppType;
    appPath = Directory.current.path;
  }

  run() {
    createDir();

    if (appType == 'server') {
      initServer().then((_) => printEnd());
    } else if (appType == 'client') {
      initClient().then((_) => printEnd());
    }
  }

  printEnd() {
    print('--- init end ---');
  }

  createDir() {
    Directory configDir = new Directory('${appPath}/i_config');
    if (!configDir.existsSync()) configDir.createSync();
    print('i_config directory created.');

    Directory routeDir = new Directory('${appPath}/route');
    if (!routeDir.existsSync()) routeDir.createSync();
    print('route directory created.');
  }

  Future initServer() {
    loadServerConfigFiles();
    loadServerRouteFiles();
    List waitList = [];
    serverConfigFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}/i_config', content, true));
    });
    serverRouteFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}/route', content, true));
    });
    return Future.wait(waitList);
  }

  Future initClient() {
    loadClientConfigFiles();
    loadClientRouteFiles();
    List waitList = [];
    clientConfigFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}/i_config', content, true));
    });
    clientRouteFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}/route', content, true));
    });
    return Future.wait(waitList);
  }

  Future write(File file, String content) {
    IOSink sink = file.openWrite();
    sink.write(content);
    return sink.close()
    .then((_) {
      print('Write ${file.path} Done.');
    });
  }

  Future writeFile(String name, String path, String content, [bool overwrite = true]) {
    String fullName = '${path}/${name}';
    File file = new File(fullName);

    if (overwrite) {
      return write(file, content);
    } else {
      file.exists().then((found) {
        if (!found) {
          return write(file, content);
        }
      });
      print('${file.path} exists, skip.');
    }
  }

  loadServerConfigFiles() {
    serverConfigFiles = {
      // deploy.dart
      'deploy.dart': '''
library deploy;

Map deploy = {
  'iPath': '${appPath}/packages/i_dart/bin',

  'app': '${appName}',
  'appPath': '${appPath}',
};
''',

      // orm.dart
      'orm.dart': '''
library orm;

/* example
Map orm = {
    'User': {
        'Model': {
            'pk': [0],
            'column': [
                'groupId',
                'id',
                'name',
                'email',
                'country',
                'city',
            ],
            'toAddFilter': [2],
            'toSetFilter': [],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
        'ModelStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache', // link to store.dart
                    'slave': 'GameCacheSlave', // link to store.dart
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'u',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB', // link to store.dart
                    'slave': 'GameDBSlave', // link to store.dart
                    'table': 'User',
                },
            ],
        },
        'PK': {
            'className': 'UserPK',
        },
        'PKStore': {
            'backupStep': 5, // 0 means do not use backup
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'shardMethod': 'NONE',
                    'master': 'SingleCache',
                    'slave': 'SingleCacheSlave',
                    'abb': 'u',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'shardMethod': 'NONE',
                    'master': 'SingleDB',
                    'slave': 'SingleDBSlave',
                    'abb': 'u',
                    'table': 'PK',
                },
            ],
        },
        'List': {
            'className': 'UserList',
            'pk': [0],
            'childPK': [1],
        },
        'ListStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32', // CRC32 & Consistent Hashing
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 86400,
                    'mode': 'Atom', // TODO 'Atom' mode use hash type store model, 'Block' mode compress model to string type
                    'abb': 'u',
                },
                {
                    'type': 'mariaDB',
                    'readWriteSeparate': false,
                    'sharding': true,
                    'shardMethod': 'CRC32',
                    'master': 'GameDB',
                    'slave': 'GameDBSlave',
                    'table': 'User',
                },
            ],
        },
    },
};
*/

Map orm = {
};
''',
      'store.dart': '''
library store;

/* example
Map store = {
    'redis': {
        'GameCache': [
            {'no': 0, 'host': 'localhost', 'port': 6379, 'pwd': null, 'db': '0'},
            {'no': 1, 'host': 'localhost', 'port': 6380, 'pwd': null, 'db': '0'},
        ],
        'GameCacheSlave': [
            {'no': 0, 'host': 'localhost', 'port': 6381, 'pwd': null, 'db': '0'},
            {'no': 1, 'host': 'localhost', 'port': 6382, 'pwd': null, 'db': '0'},
        ],
        'SingleCache': [
            {'no': 0, 'host': 'localhost', 'port': 6383, 'pwd': null, 'db': '0'},
        ],
        'SingleCacheSlave': [
            {'no': 0, 'host': 'localhost', 'port': 6384, 'pwd': null, 'db': '0'},
        ],
    },
    'mariaDB': {
        'GameDB': [
            {'no': 0, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
            {'no': 1, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
        ],
        'GameDBSlave': [
            {'no': 0, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
            {'no': 1, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
        ],
        'SingleDB': [
            {'no': 0, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
        ],
        'SingleDBSlave': [
            {'no': 0, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
        ],
    },
};
*/

Map store = {
};
''',
      'server_route': '''
part of lib_${appName};

/* example
Map serverRoute = {
    "V101": { // receive blob
        "handler": TestRouteLogic.echo,
        "params": {
            "n": "rs",
        },
        "locks": [],
        "encryptType": null,
        "reqEncrypt": false,
        "resEncrypt": false,
    },
};
*/

Map serverRoute = {
};
''',
    };
  }

  loadServerRouteFiles() {
    serverRouteFiles = {
      'example_route_logic.dart': '''
part of lib_${appName};

/* example
class ExampleRouteLogic {
  static echo(WebSocket ws, String api, Map params) {
    ws.add(JSON.encode({"echo": "\${api} done."}));
  }
}
*/

class ExampleRouteLogic {
}
''',
    };
  }

  loadClientConfigFiles() {
    clientConfigFiles = {

    };
  }
}
