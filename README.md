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
      * Model
      * PK
      * List
    * MariaDB / MySQL
      * Model
      * PK
      * List
    * United Store
      * Model
      * PK
      * List
  * Client
    * IndexedDB
      * Model
      * PK
      * List
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

