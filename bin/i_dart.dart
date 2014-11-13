library i_dart;

/* example

pub global run i_dart init -n app_name -t server

*/

import 'dart:io';
import 'dart:async';
import 'dart:convert';
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
---------- INIT START ----------

----- CONFIG -----
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
  static Map serverRootFiles;

  static Map clientConfigFiles;
  static Map clientRouteFiles;
  static Map clientRootFiles;

  Init(String rawAppName, String rawAppType) {
    appName = rawAppName;
    appType = rawAppType;
    appPath = Directory.current.path;
  }

  run() {
    createDir();

    print('');
    print('----- File -----');

    Future initFuture;
    if (appType == 'server') {
      initFuture = initServer();
    } else if (appType == 'client') {
      initFuture = initClient();
    }

    initFuture
    .then((_) => pubGet())
    .then((_) => deploy())
    .then((_) => printEnd());
  }

  pubGet() {
    print('');
    print('---------- PUB GET START ----------');
    return Process.start('pub', ['get'])
    .then((Process process) {
      process.stdout.transform(UTF8.decoder).listen((data) { print(data); });

      return process.exitCode.then((exitCode) {
        print('exit code: ${exitCode}');
        print('---------- PUB GET END----------');
      });
    });
  }

  deploy() {
    print('');
    print('---------- DEPLOY START ----------');
    return Process.start('dart', ['deploy.dart'])
    .then((Process process) {
      process.stdout.transform(UTF8.decoder).listen((data) { print(data); });

      return process.exitCode.then((exitCode) {
        print('exit code: ${exitCode}');
        print('---------- DEPLOY END----------');
      });
    });
  }

  printEnd() {
    print('');
    print('---------- INIT END ----------');
  }

  createDir() {
    print('----- DIRECTORY -----');
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
    loadServerRootFiles();

    List waitList = [];
    serverConfigFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}/i_config', content, true));
    });
    serverRouteFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}/route', content, true));
    });
    serverRootFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}', content, true));
    });
    return Future.wait(waitList);
  }

  Future initClient() {
    loadClientConfigFiles();
    loadClientRouteFiles();
    loadClientRootFiles();

    List waitList = [];
    clientConfigFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}/i_config', content, true));
    });
    clientRouteFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}/route', content, true));
    });
    clientRootFiles.forEach((fileName, content) {
      waitList.add(writeFile(fileName, '${appPath}', content, true));
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

    if (overwrite) return write(file, content);

    return file.exists().then((found) {
      if (!found) {
        return write(file, content);
      }
      print('${file.path} exists, skip.');
    });
  }

  loadServerConfigFiles() {
    serverConfigFiles = {
      'deploy.dart': '''
library deploy;

Map deploy = {
  'iPath': '${appPath}/packages/i_dart',

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
            {'no': 0, 'host': 'localhost', 'port': 6379, 'pwd': null, 'db': 0},
            {'no': 1, 'host': 'localhost', 'port': 6380, 'pwd': null, 'db': 0},
        ],
        'GameCacheSlave': [
            {'no': 0, 'host': 'localhost', 'port': 6381, 'pwd': null, 'db': 0},
            {'no': 1, 'host': 'localhost', 'port': 6382, 'pwd': null, 'db': 0},
        ],
        'SingleCache': [
            {'no': 0, 'host': 'localhost', 'port': 6383, 'pwd': null, 'db': 0},
        ],
        'SingleCacheSlave': [
            {'no': 0, 'host': 'localhost', 'port': 6384, 'pwd': null, 'db': 0},
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
      'server_route.dart': '''
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

  loadServerRootFiles() {
    serverRootFiles = {
      'pubspec.yaml':
'''
name: ${appName}
description: Description
dependencies:
  unittest: ">=0.11.0+5 <0.12.0"
  sqljocky: ">=0.11.0 <0.12.0"
  logging: ">=0.9.2 <0.10.0"
  http_server: ">=0.9.3 <0.10.0"
  route: ">=0.4.6 <0.5.0"
  i_redis: ">=1.0.3 <2.0.0"
  uuid: ">=0.4.1 <0.5.0"
  i_dart: ">=0.1.0 <0.5.0"
''',
        'run.dart':
        '''
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:http_server/http_server.dart';
import 'package:route/server.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_${appName}.dart';
import 'i_config/deploy.dart';
import 'i_config/orm.dart';
import 'i_config/store.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('\${rec.level.name}: \${rec.time}: \${rec.message}');
  });

  int port = 8080;
  final String rootPath = deploy['appPath'] + '/web';

  var buildPath = Platform.script.resolve(rootPath).toFilePath();
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port).then((server) {
    Router router = new Router(server);

    var virDir = new VirtualDirectory(buildPath);
    virDir.jailRoot = false;
    virDir.allowDirectoryListing = true;
    /*
    virDir.directoryHandler = (dir, request) {
      print(dir.path);
      var indexUrl = new Uri.file(dir.path).resolve('index.html');
      virDir.serveFile(new File(indexUrl.toFilePath()), request);
    };
    */

    var handler = new IWebSocketServerHandler();
    router.serve('/ws')
    .transform(new WebSocketTransformer())
    .listen(handler.onMessage);

    virDir.serve(router.defaultStream);

    ILog.info('WebSocket Server is running on http://\${server.address.address}:\${port}');
  });
}
''',
        'deploy.dart':
'''
import 'package:i_dart/i_maker/lib_i_maker.dart';
import 'i_config/deploy.dart';
import 'i_config/orm.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(deploy, orm);
  modelMaker.make();

  IStoreMaker storeMaker = new IStoreMaker(deploy, orm);
  storeMaker.makeServer();

  IRouteMaker routeMaker = new IRouteMaker(deploy);
  routeMaker.makeServer();

  ILibraryMaker libMaker = new ILibraryMaker(deploy);
  libMaker.makeServer();
}
''',
    };
  }

  loadClientConfigFiles() {
    clientConfigFiles = {
        'deploy.dart': '''
library deploy;

Map deploy = {
  'iPath': '${appPath}/packages/i_dart',

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
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'User',
                },
            ],
        },
        'PK': {
            'className': 'UserPK',
        },
        'PKStore': {
            'storeOrder': [
                {
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'PK',
                    'key': 'UserPK',
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
                    'type': 'indexedDB',
                    'master': 'GameIDB',
                    'objectStore': 'SingleList',
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
    'indexedDB': {
        'GameIDB': {'db': 'GameIDB'},
    },
};
*/

Map store = {
};
''',
        'client_route.dart': '''
part of lib_${appName};

/* example
Map clientRoute = {
    "V101": { // echo
        "handler": TestRouteLogic.echo,
    },
    "onUnknown": { // echo
        "handler": TestRouteLogic.onUnknown,
    },
};
*/

Map clientRoute = {
};
''',
        'idb_upgrade.dart': '''
library idb_upgrade;

import 'dart:indexed_db';

/*

Model

ObjectStore objectStore = db.createObjectStore('UserSingle', keyPath: '_pk');

PK
one objStore can hold all pks
ObjectStore objectStore = db.createObjectStore('PK', keyPath: '_pk');

List
ObjectStore objectStore = db.createObjectStore('SingleList', keyPath: '_pk');
objectStore.createIndex("_index", "_index", unique: false );

*/

/* example
Map idbUpgrade = {
  'GameIDB': {
      '1': (Database db) {
        ObjectStore objectStore = db.createObjectStore('UserMultiple', keyPath: '_pk');
      },
      '7': (Database db) {
        ObjectStore objectStore = db.createObjectStore('UserSingle', keyPath: '_pk');
      },
      '8': (Database db) {
        ObjectStore objectStore = db.createObjectStore('PK', keyPath: '_pk');
      },
      '9': (Database db) {
        ObjectStore objectStore = db.createObjectStore('UserSingleList', keyPath: '_pk');
        objectStore.createIndex("_index", "_index", unique: false );
      },
      '10': (Database db) {
        ObjectStore objectStore = db.createObjectStore('SingleList', keyPath: '_pk');
        objectStore.createIndex("_index", "_index", unique: false );
        db.deleteObjectStore('UserSingleList');
      },
      '12': (Database db) {
        ObjectStore objectStore = db.createObjectStore('MultipleList', keyPath: '_pk');
        objectStore.createIndex("_index", "_index", unique: false );
      },
  },
};
*/

Map idbUpgrade = {
};
''',
    };
  }

  loadClientRouteFiles() {
    clientRouteFiles = {
        'example_route_logic.dart': '''
part of lib_${appName};

/* example
class ExampleRouteLogic {
  static echo(WebSocket ws, String api, Map params) {
    print('Message received: \${JSON.encode(params)}');
  }

  static onUnknown(WebSocket ws, String api, Map params) {
    print('Message received: \${JSON.encode(params)}');
  }
}
*/

class ExampleRouteLogic {
}
''',
    };
  }

  loadClientRootFiles() {
    clientRootFiles = {
        'pubspec.yaml':
        '''
name: ${appName}
description: Description
dependencies:
  unittest: ">=0.11.0+5 <0.12.0"
  logging: ">=0.9.2 <0.10.0"
  i_dart: ">=0.1.0 <0.5.0"
''',
        'main.dart':
        '''
import 'dart:html';
import 'dart:indexed_db';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:i_dart/i_dart_clt.dart';

import 'lib_${appName}.dart';
import './i_config/orm.dart';
import './i_config/store.dart';
import './i_config/idb_upgrade.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('\${rec.level.name}: \${rec.time}: \${rec.message}');
  });

  IIndexedDBHandlerPool indexedDBPool = new IIndexedDBHandlerPool();
  indexedDBPool.init(store['indexedDB'], idbUpgrade)
  .then((_) {
    // do something
  });
}
''',
        'index.html':
        '''
<!DOCTYPE html>
<html>
<head>
    <title>${appName}</title>
</head>
<body>
    <script type="application/dart" src="main.dart"></script>
</body>
</html>
''',

        'deploy.dart':
        '''
import 'i_config/deploy.dart';
import 'package:i_dart/i_maker/lib_i_maker.dart';
import 'i_config/orm.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(deploy, orm);
  modelMaker.make();

  IStoreMaker storeMaker = new IStoreMaker(deploy, orm);
  storeMaker.makeClient();

  IRouteMaker routeMaker = new IRouteMaker(deploy);
  routeMaker.makeClient();

  ILibraryMaker libMaker = new ILibraryMaker(deploy);
  libMaker.makeClient();
}
''',
    };
  }
}
