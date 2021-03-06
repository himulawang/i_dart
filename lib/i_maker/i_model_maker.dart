part of i_maker;

class IModelMaker extends IMaker {
  Map <String, Map>_orm;
  String _outModelDir;

  IModelMaker(Map deploy, Map orm) : super(deploy) {
    _orm = orm;
  }

  void make() {
    _outModelDir = '${_appPath}/model';

    // create i_model directory
    makeSubDir();

    // make model files
    _orm.forEach((String name, Map orm) {
      String lowerName = makeLowerUnderline(name);
      if (orm.containsKey('Model')) {
        writeFile('${lowerName}.dart', _outModelDir, makeModel(name, orm['Model'], orm['List']), true);
      }
      if (orm.containsKey('PK')) {
        writeFile('${lowerName}_pk.dart', _outModelDir, makePK(name, orm['PK']), true);
      }
      if (orm.containsKey('List')) {
        writeFile('${lowerName}_list.dart', _outModelDir, makeList(name, orm['Model'], orm['List']), true);
      }
    });
  }
  
  String makeModel(String name, Map orm, Map listOrm) {
    StringBuffer codeSB = new StringBuffer();

    Map abbs = makeAbbs(orm['column']);
    List columns = [];
    Map mapAbb = {};
    Map mapFull = {};
    
    num length = orm['column'].length;

    // make model attributes
    String full;
    for (num i = 0; i < length; ++i) {
      full = orm['column'][i];
      columns.add({
        'i': i,
        'full': full,
        'abb': abbs[full],
        'toAdd': orm['toAddFilter'].contains(i),
        'toSet': orm['toSetFilter'].contains(i),
        'toAbb': orm['toAbbFilter'].contains(i),
        'toFull': orm['toFullFilter'].contains(i),
        'toList': orm['toListFilter'].contains(i),
      });
      
      mapAbb[abbs[full]] = i;
      mapFull[full] = i;
    }

    List pkColumnName = [];
    List pkColumnRawName = [];
    for (int i = 0; i < orm['pk'].length; ++i) {
      pkColumnName.add(orm['column'][orm['pk'][i]]);
      pkColumnRawName.add('${orm['column'][orm['pk'][i]]}Raw');
    }

    List listPKColumnName = [];
    if (listOrm != null) {
      listOrm['pk'].forEach((index) => listPKColumnName.add(orm['column'][index]));
    }

    codeSB.write('''
${_DECLARATION}

part of lib_${_app};

class ${name} extends IModel {
  static String _delimiter = ':';

  static const String _name = '${name}';

  static const List _pk = const ${JSON.encode(orm['pk'])};
  static const List _pkColumns = const ${JSON.encode(pkColumnName)};
''');

    if (listOrm != null) {
      codeSB.write('''
  static const List _listPKColumns = const ${JSON.encode(listPKColumnName)};
''');
    }


    codeSB.write('''
  static const num _length = ${length};
  static const List _columns = const ${makeConstJSON(columns)};
  static const Map _mapAbb = const ${JSON.encode(mapAbb)};
  static const Map _mapFull = const ${JSON.encode(mapFull)};

''');

    codeSB.write('''
  List _args;
  List<bool> _updatedList;
  bool _exist = false;

  ${name}([List args = null]) : super() {
    if (args == null) {
      _args = new List.filled(_length, null);
    } else {
      if (args is! List) throw new IModelException(10010, [this.runtimeType, args]);
      if (args.length != _length) throw new IModelException(10009, [this.runtimeType, args.length, _length]);
      _args = args;
    }
    _updatedList = new List.filled(_length, false);
  }

  String getName() => _name;
  int getColumnCount() => _length;

  List getColumns() => _columns;
  Map getMapAbb() => _mapAbb;
  Map getMapFull() => _mapFull;

  void setExist([bool exist = true]) { _exist = exist; }
  bool isExist() => _exist;

''');

    // pk
    codeSB.writeln('  void setPK(${pkColumnRawName.join(', ')}) {');

    pkColumnName.forEach((name) {
      codeSB.writeln('    ${name} = ${name}Raw;');
    });
    codeSB.writeln('  }');

    if (pkColumnName.length == 1) {
      codeSB.writeln('  getPK() => ${pkColumnName[0]};');
    } else {
      codeSB.writeln('  List getPK() => [${pkColumnName.join(', ')}];');
    }
    codeSB.writeln('  List getPKColumns() => _pkColumns;');

    // united pk
    if (pkColumnName.length == 1) {
      codeSB.write('''

  String getUnitedPK() {
    var pk = getPK();
    if (pk == null) throw new IModelException(10015);
    return getPK().toString();
  }
''');
    } else {
      codeSB.write('''
  String getUnitedPK() {
    List pk = getPK();
    if (pk.contains(null)) throw new IModelException(10016, [pk]);
    return pk.join(_delimiter);
  }

''');
    }

    if (listOrm != null) {
      // united list pk
      codeSB.writeln('  List getListPK() => [${listPKColumnName.join(', ')}];');
      codeSB.writeln('  List getListPKColumns() => ${JSON.encode(listPKColumnName)};');
      codeSB.write('''
  String getUnitedListPK() {
    List listPK = getListPK();
    if (listPK.contains(null)) throw new IModelException(10020, [listPK]);
    return listPK.join(_delimiter);
  }

''');

      // united child pk
      List childPKColumnName = [];
      listOrm['childPK'].forEach((index) => childPKColumnName.add(orm['column'][index]));

      codeSB.writeln('  List getChildPK() => [${childPKColumnName.join(', ')}];');
      codeSB.write('''
  String getUnitedChildPK() {
    List childPK = getChildPK();
    if (childPK.contains(null)) throw new IModelException(10018, [childPK]);
    return childPK.join(_delimiter);
  }

''');

      // whole pk
      List wholePKColumnName = [];
      wholePKColumnName..addAll(listPKColumnName)..addAll(childPKColumnName);
      codeSB.writeln('  List getWholePK() => [${wholePKColumnName.join(', ')}];');
      codeSB.write('''
  String getUnitedWholePK() {
    List wholePK = getWholePK();
    if (wholePK.contains(null)) throw new IModelException(10019, [wholePK]);
    return wholePK.join(_delimiter);
  }
''');
    }

    for (num i = 0; i < length; ++i) {
      String full = orm['column'][i];
      codeSB.write('''

  void set ${full}(v) {
    if (_args[${i}] == v) return;
    _args[${i}] = v;
    _updatedList[${i}] = true;
  }
  get ${full} => _args[${i}];
''');
    }

    codeSB.write('''

  bool isUpdated() => _updatedList.any((bool e) => e);
  void setUpdatedList(bool flag) => _updatedList.fillRange(0, _length, flag);

  List toAddFixedList([bool filterOn = false]) {
    if (!filterOn) return _args.toList(growable: false);

    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (_columns[i]['toAdd']) continue;
      result[i] = _args[i];
    }
    return result;
  }
  List toAddList([bool filterOn = false]) {
    List result = [];
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toAdd']) continue;
      result.add(_args[i]);
    }
    return result;
  }
  Map toAddFull([bool filterOn = false]) {
    Map result = {};
    _mapFull.forEach((full, i) {
      if (filterOn && _columns[i]['toAdd']) return;
      result[full] = _args[i];
    });
    return result;
  }
  Map toAddAbb([bool filterOn = false]) {
    Map result = {};
    _mapAbb.forEach((abb, i) {
      if (filterOn && _columns[i]['toAdd']) return;
      result[abb] = _args[i];
    });
    return result;
  }

  List toSetFixedList([bool filterOn = false]) {
    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toSet']) continue;
      if (_updatedList[i]) result[i] = _args[i].toString();
    }
    return result;
  }
  List toSetList([bool filterOn = false]) {
    List result = [];
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toSet']) continue;
      if (_updatedList[i]) result.add(_args[i].toString());
    }
    return result;
  }
  Map toSetFull([bool filterOn = false]) {
    Map result = {};
    _mapFull.forEach((full, i) {
      if (filterOn && _columns[i]['toSet']) return;
      if (_updatedList[i]) result[full] = _args[i];
    });
    return result;
  }
  Map toSetAbb([bool filterOn = false]) {
    Map result = {};
    _mapAbb.forEach((abb, i) {
      if (filterOn && _columns[i]['toSet']) return;
      if (_updatedList[i]) result[abb] = _args[i];
    });
    return result;
  }

  List toFixedList([bool filterOn = false]) {
    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toList']) continue;
      result[i] = _args[i];
    }
    return result;
  }
  List toList([bool filterOn = false]) {
    List result = [];
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toList']) continue;
      result.add(_args[i]);
    }
    return result;
  }
  Map toFull([bool filterOn = false]) {
    Map result = {};
    _mapFull.forEach((full, i) {
      if (filterOn && _columns[i]['toFull']) return;
      result[full] = _args[i];
    });
    return result;
  }
  Map toAbb([bool filterOn = false]) {
    Map result = {};
    _mapAbb.forEach((abb, i) {
      if (filterOn && _columns[i]['toAbb']) return;
      result[abb] = _args[i];
    });
    return result;
  }

  void fromList(List data, [bool changeUpdatedList = false]) {
    if (data is! List || data.length != _length) throw new IModelException(10006, [this.runtimeType, data.length, _length]);
    for (num i = 0; i < _args.length; ++i) {
      _args[i] = data[i];
    }
    if (changeUpdatedList) setUpdatedList(true);
  }
  void fromFull(Map data, [bool changeUpdatedList = false]) {
    if (data is! Map) throw new IModelException(10008, [this.runtimeType, data.length, _length]);

    _mapFull.forEach((String full, num i) {
      if (!data.containsKey(full)) return;
      _args[i] = data[full];
      if (changeUpdatedList) _updatedList[i] = true;
    });
  }
  void fromAbb(Map data, [bool changeUpdatedList = false]) {
    if (data is! Map) throw new IModelException(10007, [this.runtimeType, data.length, _length]);

    _mapAbb.forEach((String abb, num i) {
      if (!data.containsKey(abb)) return;
      _args[i] = data[abb];
      if (changeUpdatedList) _updatedList[i] = true;
    });
  }
''');

    codeSB.write('}');

    return codeSB.toString();
  }
  String makePK(String name, Map orm) {
    String className = orm['className'];
    StringBuffer codeSB = new StringBuffer();
    codeSB.write('''
${_DECLARATION}

part of lib_${_app};

class ${className} extends IPK {
  ${name}PK([num init = 0]) {
    pk = init;
  }
}
''');

    return codeSB.toString();
  }

  String makeList(String name, Map orm, Map listOrm) {
    String listName = listOrm['className'];

    List pkColumnName = [];
    List childPKColumnName = [];

    listOrm['pk'].forEach((index) {
      pkColumnName.add(orm['column'][index]);
    });
    listOrm['childPK'].forEach((index) {
      childPKColumnName.add(orm['column'][index]);
    });

    StringBuffer codeSB = new StringBuffer();
    codeSB.write('''
${_DECLARATION}

part of lib_${_app};

class ${listName} extends IList {
  static String _delimiter = ':';
  ${listName}(${pkColumnName.join(', ')}) { _initPK([${pkColumnName.join(', ')}]); }

  ${listName}.filledMap(${pkColumnName.join(', ')}, Map dataList) {
    _initPK([${pkColumnName.join(', ')}]);

    dataList.forEach((String i, ${name} model) {
      if (model is! ${name}) return;
      rawSet(model);
    });
  }

  ${listName}.filledList(${pkColumnName.join(', ')}, List dataList) {
    _initPK([${pkColumnName.join(', ')}]);

    dataList.forEach((${name} model) {
      if (model is! ${name}) return;
      rawSet(model);
    });
  }

  _initPK(List pk) => pks = pk;

  setPK(${pkColumnName.join(', ')}) => pks = [${pkColumnName.join(', ')}];
  String getUnitedPK() {
    if (pks.contains(null)) throw new IModelException(10021);
    return pks.join(_delimiter);
  }

  ${name} get(${childPKColumnName.join(', ')}) => list["\${${childPKColumnName.join('}\$\{_delimiter}\${')}}"];

  void fromList(List dataList, [bool changeUpdatedList = false]) {
    if (dataList is! List) throw new IModelException(10012, [this.runtimeType]);

    dataList.forEach((List data) {
      ${name} model = new ${name}();
      model.fromList(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (get(model.getUnitedChildPK()) == null) {
          add(model);
        } else {
          set(model);
        }
      } else {
        rawSet(model);
      }
    });
  }
  void fromFull(Map dataList, [bool changeUpdatedList = false]) {
    if (dataList is! Map) throw new IModelException(10013, [this.runtimeType]);

    dataList.forEach((String i, Map data) {
      ${name} model = new ${name}();
      model.fromFull(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (get(model.getUnitedChildPK()) == null) {
          add(model);
        } else {
          set(model);
        }
      } else {
        rawSet(model);
      }
    });
  }
  void fromAbb(Map dataList, [bool changeUpdatedList = false]) {
    if (dataList is! Map) throw new IModelException(10014, [this.runtimeType]);

    dataList.forEach((String i, Map data) {
      ${name} model = new ${name}();
      model.fromAbb(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (get(model.getUnitedChildPK()) == null) {
          add(model);
        } else {
          set(model);
        }
      } else {
        rawSet(model);
      }
    });
  }
}
''');
    return codeSB.toString();
  }

  String makeConstJSON(List columns) {
    StringBuffer codeSB = new StringBuffer();
    codeSB.write('[');
    columns.forEach((detail) => codeSB.writeAll(['const ', JSON.encode(detail), ',']));
    codeSB.write(']');

    return codeSB.toString();
  }

  void makeSubDir() {
    //Directory coreDir = new Directory(_outModelCoreDir);
    //if (!coreDir.existsSync()) coreDir.createSync();

    Directory modelDir = new Directory(_outModelDir);
    if (!modelDir.existsSync()) modelDir.createSync();
  }
}