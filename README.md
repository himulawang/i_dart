ParaNoidz I Framework for Dart
===

## 简介

一款用于加速Web App开发的框架。

使用配置生成Model文件和数据库中的映射关系。

抽象客户端和服务端交互协议。

让开发者专注于App本身的逻辑开发。

## Fast start

### Deployment

配置完deploy.dart

deploy.dart
```dart
library deploy;

Map deploy = {
  'iPath': '/home/ila/project/i_dart/bin', // 框架文件所在目录

  'app': 'test', // App名字
  'appPath': '/home/ila/project/i_dart/test_server', // 部署的目录
};
```

并执行以下代码，就能快速生成一个新的Server App。

```dart
import 'i_config/deploy.dart';
import '../bin/i_maker/lib_i_maker.dart';

void main() {
  IUtilMaker utilMaker = new IUtilMaker(deploy);
  utilMaker.make();

  ILibraryMaker libMaker = new ILibraryMaker(deploy);
  libMaker.makeServer();
}
```

## 模块

* Model
  * Model
  * PK
  * List
* Store
  * Server
    * Redis
    * MariaDB / MySQL
  * Client
    * IndexedDB
  * United Store
* Route
  * WebSocket
* Utility
  * IException
  * IHash
  * ILog
  * IString

* Advance
  * orm.dart具体说明
  * store运行机制

## Model

### Model

模型文件是业务逻辑中必然会用到的抽象个体，用于逻辑交互和数据存储。

orm.dart配置

```dart
Map orm = {
    'User': {
        'Model': {
            'pk': [0],
            'column': [
                'id',
                'name',
                'email',
                'country',
                'city',
            ],
            'toAddFilter': [0],
            'toSetFilter': [0, 1],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
    },
};
```

使用下面的代码进行部署：

```dart
import 'i_config/deploy.dart';
import 'i_config/orm.dart';
import '../bin/i_maker/lib_i_maker.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(deploy, orm);
  modelMaker.make();

  IUtilMaker utilMaker = new IUtilMaker(deploy);
  utilMaker.make();

  ILibraryMaker libMaker = new ILibraryMaker(deploy);
  libMaker.makeServer();
}
```

会在model文件夹下生成一个user.dart文件。

接下来就可以在自己的逻辑中使用User这个Model。

main.dart

```dart
import 'lib_test.dart';

main() {
  User user = new User();
  user..id = 1
      ..name = 'ila'
      ..email = 'ila[at]ilaempire.com'
      ..country = 'Japan'
      ..city = 'Tokyo';

  // 直接把Model转换成JSON
  print(user.toFull());

  // {"id":1,"name":"ila","email":"ila[at]ilaempire.com","country":"Japan","city":"Tokyo"}
}
```

Model的具体API请参见：[TODO]

### PK

PK的全称为Primary Key，即主键，这类模型的特点是可计数自增。
可用于全局的自增键，计数器等。

orm.dart配置

```dart
Map orm = {
    'User': {
        'PK': {
            'className': 'UserPK',
        },
    },
};
```

部署后会在model文件夹下生成user_pk.dart文件。

使用方法如下：

main.dart

```dart
import 'lib_test.dart';

main() {
  UserPK pk = new UserPK();

  print(pk.get()); // 0
  print(pk.incr()); // 1
  print(pk.incr(17)); // 18

  pk.reset();
  print(pk.get()); // 0
}
```

PK的具体API请参见：[TODO]

### List

List用于存放一个集合的Model，比如：可以将同类的User放到一个叫DevTeam的List中。

orm.dart配置

```dart
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
            'toAddFilter': [1],
            'toSetFilter': [0, 1],
            'toFullFilter': [],
            'toAbbFilter': [],
            'toListFilter': [],
        },
        'List': {
            'className': 'UserList',
            'pk': [0],
            'childPK': [1],
        },
    },
};
```

部署后会在model文件夹下生成一个user_list.dart的文件。

使用方法如下：

main.dart

```dart
import 'lib_test.dart';

main() {
  User user1 = new User([7, 1, 'ila', 'ila[at]ilaempire.com', 'Japan', 'Tokyo']);
  User user2 = new User([7, 2, 'Dya', 'dya[at]ilaempire.com', 'Japan', 'Kyoto']);

  // 7 是devTeam的GroupId
  UserList devTeam = new UserList(7);

  devTeam.add(user1);
  devTeam.add(user2);

  print(devTeam.toFull());
  /*
  {
    {"groupId":7,"id":1,"name":"ila","email":"ila[at]ilaempire.com","country":"Japan","city":"Tokyo"},
    {"groupId":7,"id":2,"name":"Dya","email":"dya[at]ilaempire.com","country":"Japan","city":"Kyoto"},
  }
  */
}
```

List的具体API请参见：[TODO]

## Store

Store是Model和数据库的连接层。可以便捷得从数据库中获取、增删改数据，并自动生成逻辑中需要使用的模型，而不用写SQL语句。

Store分为Server部分和Client部分。

目前的框架中，Server支持Redis和MariaDB(MySQL)，Client支持IndexedDB。

## Server Store

###Redis

###Model

orm.dart配置

```dart
Map orm = {
    'User': {
        'Model': {
            'pk': [0],
            'column': [
                'id',
                'name',
                'email',
                'country',
                'city',
            ],
            'toAddFilter': [0],
            'toSetFilter': [0],
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
                    'shardMethod': 'CRC32',
                    'master': 'GameCache',
                    'slave': 'GameCacheSlave',
                    'expire': 86400,
                    'mode': 'Atom',
                    'abb': 'u',
                },
            ],
        },
    },
};
```

store.dart配置

```dart
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
    },
};
```

使用如下代码进行部署

```dart
import 'i_config/deploy.dart';
import 'i_config/orm.dart';
import '../bin/i_maker/lib_i_maker.dart';

void main() {
  IModelMaker modelMaker = new IModelMaker(deploy, orm);
  modelMaker.make();

  IStoreMaker storeMaker = new IStoreMaker(deploy, orm);
  storeMaker.makeServer();

  IUtilMaker utilMaker = new IUtilMaker(deploy);
  utilMaker.make();

  ILibraryMaker libMaker = new ILibraryMaker(deploy);
  libMaker.makeServer();
}
```

上述代码会在store目录下生成user_rdb_store.dart

使用方法如下：

main.dart

```dart
import 'lib_test.dart';

main() {
// 将User1存入Redis
  User user1 = new User([1, 'ila', 'ila[at]ilaempire.com', 'Japan', 'Tokyo']);

  // 1是user1的id，分Shard时的依据
  UserRedisStore store = new UserRedisStore(1);
  store.add(user1);

  // 上述代码会将user1转换成Redis的命令：
  // hmset u1 i 1 n ila e ila[at]ilaempire.com c Japan c1 Tokyo
  // expire u1 86400

  // 从Redis中获取User1
  UserRedisStore store = new UserRedisStore(1);
  User user1 = store.get(1);

  // 转换成Redis命令：
  // hmget u1 i n e c c1

  print(user1.toFull());
  // {"id":1,"name":"ila","email":"ila[at]ilaempire.com","country":"Japan","city":"Tokyo"}
}
```

###PK

orm.dart配置

```dart
Map orm = {
    'User': {
        'PK': {
            'className': 'UserPK',
        },
        'PKStore': {
            'storeOrder': [
                {
                    'type': 'redis',
                    'readWriteSeparate': false,
                    'shardMethod': 'NONE',
                    'master': 'SingleCache',
                    'slave': 'SingleCacheSlave',
                    'abb': 'u',
                },
            ],
        },
    },
};
```

store.dart配置

```dart
Map store = {
    'redis': {
        'SingleCache': [
            {'no': 0, 'host': 'localhost', 'port': 6383, 'pwd': null, 'db': '0'},
        ],
        'SingleCacheSlave': [
            {'no': 0, 'host': 'localhost', 'port': 6384, 'pwd': null, 'db': '0'},
        ],
    },
};
```

To be continued...
