part of i_maker;

class ILibraryMaker extends IMaker {
  final String _serverHeader = '''
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:i_redis/i_redis.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:logging/logging.dart';
import 'package:i_dart/i_dart_srv.dart';

part './i_config/server_route.dart';

''';

  final String _clientHeader = '''
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:indexed_db';
import 'dart:html';

import 'package:logging/logging.dart';
import 'package:i_dart/i_dart_clt.dart';

part './i_config/client_route.dart';

''';

  ILibraryMaker(Map deploy) : super(deploy);

  void makeServer() {
    writeFile('lib_${_app}.dart', _appPath, _makeClassFileLibrary(_serverHeader), true);
  }

  void makeClient() {
    writeFile('lib_${_app}.dart', _appPath, _makeClassFileLibrary(_clientHeader), true);
  }

  String _makeClassFileLibrary(String header) {
    StringBuffer contentSB = new StringBuffer();
    contentSB.write(_DECLARATION);
    contentSB.writeln('library lib_${_app};\n');
    contentSB.write(header);

    Directory outDir = new Directory(_appPath);
    List ls = outDir.listSync();
    ls.forEach((entity) {
      // skip File & i_config directory
      String path = makeCompatiblePath(entity.path);
      if (entity is File ||
        path[0] == '.' ||
        path == '${_appPath}/i_config' ||
        path == '${_appPath}/packages'
      ) return;


      Directory childDir = new Directory(path);
      List childLs = childDir.listSync(recursive: true);
      contentSB.writeln('// ${path.replaceFirst('${_appPath}/', '')}');
      childLs.forEach((childEntity) {
        if (childEntity is Directory || !childEntity.path.endsWith('.dart')) return;
        contentSB.writeln("part '${makeCompatiblePath(childEntity.path).replaceFirst(_appPath, '.')}';");
      });
    });

    return contentSB.toString();
  }

}
