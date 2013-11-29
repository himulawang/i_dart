part of i_maker;

class IModelMaker extends IMaker {
  String _outModelCoreDir;
  String _srcModelCoreDir;
  String _outModelDir;

  IModelMaker(List orm) : super() {
    _orm = orm;
  }

  void make(String targetPath) {
    _srcModelCoreDir = '${_rootDir}/../bin/i_model_core';
    _outModelCoreDir = '${targetPath}/i_model_core';
    _outModelDir = '${targetPath}/model';

    // create i_model directory
    makeSubDir(targetPath);

    // copy base model
    copyFile(_srcModelCoreDir, 'i_pk.dart', _outModelCoreDir, 'i_pk.dart');
    copyFile(_srcModelCoreDir, 'i_model.dart', _outModelCoreDir, 'i_model.dart');
    copyFile(_srcModelCoreDir, 'i_list.dart', _outModelCoreDir, 'i_list.dart');
    copyFile(_srcModelCoreDir, 'i_model_exception.dart', _outModelCoreDir, 'i_model_exception.dart');

    // make model files
    _orm.forEach((orm) {
      String lowerName = makeLowerUnderline(orm['name']);
      writeFile('${lowerName}.dart', _outModelDir, makeModel(orm), true);
      writeFile('${lowerName}_pk.dart', _outModelDir, makePK(orm), true);
      writeFile('${lowerName}_list.dart', _outModelDir, makeList(orm), true);
    });
    // make import package
    writeFile('lib_i_model.dart', targetPath, makeModelPackage(), true);
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
part of lib_i_model;

class ${orm['name']} extends IModel {
  static const String _abb = '${orm['abb']}';
  static const String _name = '${orm['name']}';
  static const String _listName = '${orm['listName']}';
  static const String _pkName = '${orm['column'][orm['pk']]}';

  static const int _pk = ${orm['pk']};
  static const int _length = ${length};
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

  List<Dynamic> _args;
  List<bool> _updatedList;
  bool _addFlag = false;
  bool _delFlag = false;
  bool _exist = false;

  ${orm['name']}([List args = null]) : super() {
    _args = args == null ? new List.filled(_length, null) : args;
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

  void setPK(pk) { _args[_pk] = pk; }
  getPK() => _args[_pk];

  bool isUpdated() {
    for (var updated in _updatedList) {
      if (updated) return true;
    }
    return false;
  }
  void setUpdatedList(bool flag) {
    for (int i = 0; i < _length; ++i) {
      _updatedList[i] = flag;
    }
  }

  List toAddFixedList([bool filterOn = false]) {
    List result = new List.filled(_length, null);
    for (int i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toAdd']) continue;
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
      if (_updatedList[i]) result[i] = _args[i].toString();
    }
    return result;
  }
  List toList([bool filterOn = false]) {
    List result = [];
    for (int i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toList']) continue;
      if (_updatedList[i]) result.add(_args[i].toString());
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
    _args = data;
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

  void markForAdd([bool flag = true]) {
    _addFlag = flag;
  }
  void markForDel([bool flag = true]) {
    _delFlag = flag;
  }
''');

    codeSB.write('}');

    return codeSB.toString();
  }
  String makePK(Map orm) {
    String name = orm['name'];
    String code = '''
${_DECLARATION}
part of lib_i_model;

class ${name}PK extends IPK {
  ${name}PK([int pk = 0]) : super(){
    _pk = pk;
  }
}
''';
    return code;
  }
  String makeList(Map orm) {
    String name = orm['name'];
    String code = '''
${_DECLARATION}
part of lib_i_model;

class ${name}List extends IList {
  ${name}List(int pk, [list = null]) : super(){
    _pk = pk;
    if (list is Map) _list = list;
  }
}
''';
    return code;
  }

  String makeModelPackage() {
    String code ='''
${_DECLARATION}
library lib_i_model;

import 'dart:async';

import 'package:redis_client/redis_client.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:logging/logging.dart';

// util
part '../bin/i_util/i_log.dart';

// model
part './i_model_core/i_model_exception.dart';
part './i_model_core/i_model.dart';
part './i_model_core/i_pk.dart';
part './i_model_core/i_list.dart';

// store
part './i_store_core/i_store_exception.dart';
part './i_store_core/i_rdb_store.dart';
part './i_store_core/i_mdb_store.dart';
part './i_store_core/i_rdb_handler_pool.dart';
part './i_store_core/i_mdb_handler_pool.dart';
part './i_store_core/i_mdb_sql_prepare.dart';

part '../bin/i_maker/i_hash.dart';
''';
    _orm.forEach((Map orm) {
      String lowerName = makeLowerUnderline(orm['name']);
      code += '''

part './model/${lowerName}.dart';
part './model/${lowerName}_pk.dart';
part './model/${lowerName}_list.dart';

''';
    });
    
    return code;
  }

  String makeConstJSON(List columns) {
    StringBuffer codeSB = new StringBuffer();
    codeSB.write('[');
    columns.forEach((detail) => codeSB.writeAll(['const ', JSON.encode(detail), ',']));
    codeSB.write(']');

    return codeSB.toString();
  }

  void makeSubDir(String targetPath) {
    Directory coreDir = new Directory(_outModelCoreDir);
    if (!coreDir.existsSync()) coreDir.createSync();

    Directory modelDir = new Directory(_outModelDir);
    if (!modelDir.existsSync()) modelDir.createSync();
  }
}