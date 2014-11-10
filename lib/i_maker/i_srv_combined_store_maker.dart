part of i_maker;

abstract class IServerCombinedStoreMaker {
  String makeServerCombinedStore(String name, Map orm, Map storeOrm) {
    List storeOrder = storeOrm['storeOrder'];

    List pkColumnName = [];
    for (int i = 0; i < orm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][orm['pk'][i]]);
    }

    String codeHeader = '''
${_DECLARATION}

part of lib_${_app};

class ${name}Store {
''';

    String codeFooter = '''
}
''';

    StringBuffer codeSB = new StringBuffer();
    codeSB.write(codeHeader);

    // add
    codeSB.writeln('  static Future add(${name} model) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${name}${upperType}Store.add(model)');
      } else {
        codeSB.writeln('    .then((_) => ${name}${upperType}Store.add(model))');
      }
    }
    codeSB..writeln('    .then((${name} model) => model..setUpdatedList(false))')
      ..writeln('    ;')
      ..writeln('  }')
      ..writeln('');

    // set
    codeSB.writeln('  static Future set(${name} model) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${name}${upperType}Store.set(model)');
      } else {
        codeSB.writeln('    .then((_) => ${name}${upperType}Store.set(model))');
      }
    }
    codeSB..writeln('    .then((${name} model) => model..setUpdatedList(false))')
      ..writeln('    ;')
      ..writeln('  }')
      ..writeln('');

    // get
    codeSB.writeln('  static Future get(${pkColumnName.join(', ')}) {');
    for (int i = 0; i < storeOrder.length; ++i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == 0) {
        codeSB..writeln('    return ${name}${upperType}Store.get(${pkColumnName.join(', ')})');
      } else {
        codeSB..writeln('    .then((${name} model) {')
          ..writeln('      if (model.isExist()) return model;')
          ..writeln('      return ${name}${upperType}Store.get(${pkColumnName.join(', ')});')
          ..writeln('    })');
      }
    }

    codeSB..writeln('    ;')
      ..writeln('  }')
      ..writeln('');

    // del
    codeSB.writeln('  static Future del(${name} model) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${name}${upperType}Store.del(model)');
      } else {
        codeSB.writeln('    .then((_) => ${name}${upperType}Store.del(model))');
      }
    }
    codeSB..writeln('    ;')
      ..writeln('  }');

    codeSB.write(codeFooter);
    return codeSB.toString();
  }

  String makeServerCombinedPKStore(String name, Map orm, Map storeOrm) {
    String pkName = orm['className'];
    String firstStoreTypeName = makeUpperFirstLetter(storeOrm['storeOrder'].first['type']);
    String lastStoreTypeName = makeUpperFirstLetter(storeOrm['storeOrder'].last['type']);

    StringBuffer codeSB = new StringBuffer();
    codeSB.write('''
${_DECLARATION}

part of lib_${_app};

class ${pkName}Store {
  static int _step = ${storeOrm['backupStep']};

  static Future set(${pkName} pk) {
    num value = pk.get();
    List waitList = [];
    ${pkName} backupPK = _checkReachBackupStep(pk);
    if (backupPK != null) waitList.add(${pkName}${lastStoreTypeName}Store.set(backupPK));

    waitList.add(${pkName}${firstStoreTypeName}Store.set(pk));

    return Future.wait(waitList)
    .catchError(_handleErr);
  }

  static Future get() {
    return ${pkName}${firstStoreTypeName}Store.get()
    .then((${pkName} pk) {
      if (pk.get() != 0) return pk;
      if (_step == 0) return pk;
      return ${pkName}${lastStoreTypeName}Store.get();
    })
    .catchError(_handleErr);
  }

  static Future del(${pkName} pk) {
    List waitList = [];
    waitList.add(${pkName}${firstStoreTypeName}Store.del(pk));
    waitList.add(${pkName}${lastStoreTypeName}Store.del(pk));

    return Future.wait(waitList)
    .catchError(_handleErr);
  }

''');

    if (storeOrm['backupStep'] != 0) {
      codeSB.write('''
  static Future incr() {
    return ${pkName}${firstStoreTypeName}Store.exists()
    .then((int exists) {
      if (exists == 0) {
        return ${pkName}${lastStoreTypeName}Store.get()
        .then((${pkName} pk) {
          pk.setUpdated(true);
          if (pk.get() != 0) return ${pkName}${firstStoreTypeName}Store.set(pk);
        });
      }
    })
    .then((_) {
      return ${pkName}${firstStoreTypeName}Store.incr()
      .then((${pkName} pk) {
        ${pkName} backupPK = _checkReachBackupStep(pk);
        if (backupPK == null) return pk;

        return ${pkName}${lastStoreTypeName}Store.set(backupPK)
        .then((_) => pk);
      });
    })
    .catchError(_handleErr);
  }
''');
    } else {
      codeSB.write('''
  static Future incr() => ${pkName}${firstStoreTypeName}Store.incr().catchError(_handleErr);
''');
    }

    codeSB.write('''

  static ${pkName} _checkReachBackupStep(${pkName} pk) {
    if (!(_step != 0 && (pk.get() - 1) % _step == 0)) return null;
    return new ${pkName}()..set(pk.get() - 1 + _step);
  }

  static void _handleErr(e) => throw e;
}
''');
    return codeSB.toString();
  }

  String makeServerCombinedListStore(String name, Map orm, Map listOrm, Map storeOrm) {
    List storeOrder = storeOrm['storeOrder'];

    List pkColumnName = [];
    for (int i = 0; i < listOrm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][listOrm['pk'][i]]);
    }

    String codeHeader = '''
${_DECLARATION}

part of lib_${_app};

class ${name}ListStore {
''';

    String codeFooter = '''
}
''';

    StringBuffer codeSB = new StringBuffer();
    codeSB.write(codeHeader);

    // set
    codeSB.writeln('  static Future set(${name}List list) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${name}List${upperType}Store.set(list)');
      } else {
        codeSB.writeln('    .then((_) => ${name}List${upperType}Store.set(list))');
      }
    }
    codeSB..writeln('    .then((${name}List list) => list..resetAllToList())')
      ..writeln('    ;')
      ..writeln('  }')
      ..writeln('');

    // get
    codeSB.writeln('  static Future get(${pkColumnName.join(', ')}) {');
    for (int i = 0; i < storeOrder.length; ++i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == 0) {
        codeSB..writeln('    return ${name}List${upperType}Store.get(${pkColumnName.join(', ')})');
      } else {
        codeSB..writeln('    .then((${name}List list) {')
          ..writeln('      if (list.isExist()) return list;')
          ..writeln('      return ${name}List${upperType}Store.get(${pkColumnName.join(', ')});')
          ..writeln('    })');
      }
    }

    codeSB..writeln('    ;')
      ..writeln('  }')
      ..writeln('');

    // del
    codeSB.writeln('  static Future del(${name}List list) {');
    for (int i = storeOrder.length - 1; i >= 0; --i) {
      String upperType = makeUpperFirstLetter(storeOrder[i]['type']);
      if (i == storeOrder.length - 1) {
        codeSB.writeln('    return ${name}List${upperType}Store.del(list)');
      } else {
        codeSB.writeln('    .then((_) => ${name}List${upperType}Store.del(list))');
      }
    }
    codeSB..writeln('    ;')
      ..writeln('  }');

    codeSB.write(codeFooter);

    return codeSB.toString();
  }
}
