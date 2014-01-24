part of i_maker;

class ILibraryMaker extends IMaker {
  final String _header = '''
import 'dart:async';
import 'dart:convert';

import 'package:redis_client/redis_client.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:logging/logging.dart';

''';

  ILibraryMaker(Map deploy) : super(deploy);

  void make() {
    writeFile('lib_${_app}.dart', _appPath, makeClassFileLibrary(), true);
  }

  String makeClassFileLibrary() {
    StringBuffer contentSB = new StringBuffer();
    contentSB.write(_DECLARATION);
    contentSB.writeln('library lib_${_app};\n');
    contentSB.write(_header);

    Directory outDir = new Directory(_appPath);
    List ls = outDir.listSync();
    ls.forEach((entity) {
      // skip File & i_config directory
      String path = makeCompatiblePath(entity.path);
      if (entity is File || path == '${_appPath}/i_config') return;

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
