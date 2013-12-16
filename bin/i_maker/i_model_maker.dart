part of i_maker;

class IModelMaker extends IMaker {
  List _orm;
  String _outModelCoreDir;
  String _srcModelCoreDir;
  String _outModelDir;

  IModelMaker(Map deploy, List orm) : super(deploy) {
    _orm = orm;
  }

  void make() {
    _srcModelCoreDir = '${_iPath}/i_model_core';
    _outModelCoreDir = '${_appPath}/i_model_core';
    _outModelDir = '${_appPath}/model';

    // create i_model directory
    makeSubDir();

    // copy base model
    copyFileWithHeader(_srcModelCoreDir, 'i_pk.dart', _outModelCoreDir, 'i_pk.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcModelCoreDir, 'i_model.dart', _outModelCoreDir, 'i_model.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcModelCoreDir, 'i_list.dart', _outModelCoreDir, 'i_list.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcModelCoreDir, 'i_model_exception.dart', _outModelCoreDir, 'i_model_exception.dart', 'part of lib_${_app};');

    // make model files
    _orm.forEach((orm) {
      String lowerName = makeLowerUnderline(orm['name']);
      writeFile('${lowerName}.dart', _outModelDir, makeModel(orm), true);
      writeFile('${lowerName}_pk.dart', _outModelDir, makePK(orm), true);
      writeFile('${lowerName}_list.dart', _outModelDir, makeList(orm), true);
    });
  }
  
  String makeModel(Map orm) {
    StringBuffer codeSB = new StringBuffer();

    Map abbs = makeAbbs(orm['column']);
    List columns = [];
    Map mapAbb = {};
    Map mapFull = {};
    
    int length = orm['column'].length;

    // make model attributes
    String full;
    for (int i = 0; i < length; ++i) {
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

    codeSB.write('''
${_DECLARATION}
part of lib_${_app};

class ${orm['name']} extends IModel {
  static const String _abb = '${orm['abb']}';
  static const String _name = '${orm['name']}';
  static const String _listName = '${orm['listName']}';
  static const String _pkName = '${orm['column'][orm['pk']]}';

  static const num _pk = ${orm['pk']};
  static const num _length = ${length};
  static const List _columns = const ${makeConstJSON(columns)};
  static const Map _mapAbb = const ${JSON.encode(mapAbb)};
  static const Map _mapFull = const ${JSON.encode(mapFull)};

''');

    // store information
    Map store;
    for (int j = 0; j < orm['storeOrder'].length; ++j) {
      store = orm['storeOrder'][j];
      codeSB.write('''
  static const Map _${store['type']}Store = const ${JSON.encode(store)};
  Map get${makeUpperFirstLetter(store['type'])}Store() => _${store['type']}Store;
''');
    }

    codeSB.write('''

  List _args;
  List<bool> _updatedList;
  bool _exist = false;

  ${orm['name']}([List args = null]) : super() {
    if (args == null) {
      _args = new List.filled(_length, null);
    } else {
      if (args is! List) throw new IModelException(10010);
      if (args.length != _length) throw new IModelException(10009);
      _args = args;
    }
    _updatedList = new List.filled(_length, false);
  }

  String getAbb() => _abb;
  String getName() => _name;
  String getListName() => _listName;
  String getPKName() => _pkName;
  String getColumnCount() => _length;

  Map getColumns() => _columns;
  Map getMapAbb() => _mapAbb;
  Map getMapFull() => _mapFull;
''');

    for (int i = 0; i < length; ++i) {
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

  void setExist([bool exist = true]) { _exist = exist; }
  bool isExist() => _exist;

  void setPK(pk) => _args[_pk] = pk;
  getPK() => _args[_pk];

  bool isUpdated() => _updatedList.any((bool e) => e);
  void setUpdatedList(bool flag) => _updatedList.fillRange(0, _length, flag);

  List toAddFixedList([bool filterOn = false]) {
    if (!filterOn) return _args.toList(growable: false);

    List result = new List.filled(_length, null);
    for (int i = 0; i < _length; ++i) {
      if (_columns[i]['toAdd']) continue;
      result[i] = _args[i];
    }
    return result;
  }
  List toAddList([bool filterOn = false]) {
    List result = [];
    for (int i = 0; i < _length; ++i) {
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
    for (int i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toSet']) continue;
      if (_updatedList[i]) result[i] = _args[i].toString();
    }
    return result;
  }
  List toSetList([bool filterOn = false]) {
    List result = [];
    for (int i = 0; i < _length; ++i) {
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
    for (int i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toList']) continue;
      result[i] = _args[i];
    }
    return result;
  }
  List toList([bool filterOn = false]) {
    List result = [];
    for (int i = 0; i < _length; ++i) {
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
    if (data is! List || data.length != _length) throw new IModelException(10006);
    for (num i = 0; i < _args.length; ++i) {
      _args[i] = data[i];
    }
    if (changeUpdatedList) setUpdatedList(true);
  }
  void fromFull(Map data, [bool changeUpdatedList = false]) {
    if (data is! Map) throw new IModelException(10008);

    _mapFull.forEach((String full, num i) {
      if (!data.containsKey(full)) return;
      _args[i] = data[full];
      if (changeUpdatedList) _updatedList[i] = true;
    });
  }
  void fromAbb(Map data, [bool changeUpdatedList = false]) {
    if (data is! Map) throw new IModelException(10007);

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
  String makePK(Map orm) {
    String name = orm['name'];
    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${name}PK extends IPK {
  ${name}PK([int pk = 0]) {
    _pk = pk;
  }
}
''';
    return code;
  }
  String makeList(Map orm) {
    String name = orm['name'];
    String listName = orm['listName'];
    String code = '''
${_DECLARATION}
part of lib_${_app};

class ${listName} extends IList {
  ${listName}(num pk) { _initPK(pk); }

  ${listName}.filledMap(num pk, Map dataList) {
    _initPK(pk);

    dataList.forEach((String i, ${name} model) {
      if (model is! ${name}) return;

      var childPK = model.getPK();
      if (childPK == null) return;

      _set(model);
    });
  }

  ${listName}.filledList(num pk, List dataList) {
    _initPK(pk);

    dataList.forEach((${name} model) {
      if (model is! ${name}) return;

      var childPK = model.getPK();
      if (childPK == null) return;

      _set(model);
    });
  }

  void _initPK(num pk) {
    if (pk is! num) throw new IModelException(10011);
    _pk = pk;
  }

  void fromList(List dataList, [bool changeUpdatedList = false]) {
    if (dataList is! List) throw new IModelException(10012);

    dataList.forEach((Map data) {
      ${name} model = new ${name}();
      model.fromList(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (_list.containsKey(model.getPK())) {
          set(data);
        } else {
          add(data);
        }
      } else {
        _set(model);
      }
    });
  }
  void fromFull(Map dataList, [bool changeUpdatedList = false]) {
    if (dataList is! Map) throw new IModelException(10013);

    dataList.forEach((String i, Map data) {
      ${name} model = new ${name}();
      model.fromFull(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (_list.containsKey(model.getPK())) {
          set(data);
        } else {
          add(data);
        }
      } else {
        _set(model);
      }
    });
  }
  void fromAbb(Map dataList, [bool changeUpdatedList = false]) {
    if (dataList is! Map) throw new IModelException(10014);

    dataList.forEach((String i, Map data) {
      ${name} model = new ${name}();
      model.fromAbb(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (_list.containsKey(model.getPK())) {
          set(data);
        } else {
          add(data);
        }
      } else {
        _set(model);
      }
    });
  }
}
''';
    return code;
  }

  String makeConstJSON(List columns) {
    StringBuffer codeSB = new StringBuffer();
    codeSB.write('[');
    columns.forEach((detail) => codeSB.writeAll(['const ', JSON.encode(detail), ',']));
    codeSB.write(']');

    return codeSB.toString();
  }

  void makeSubDir() {
    Directory coreDir = new Directory(_outModelCoreDir);
    if (!coreDir.existsSync()) coreDir.createSync();

    Directory modelDir = new Directory(_outModelDir);
    if (!modelDir.existsSync()) modelDir.createSync();
  }
}