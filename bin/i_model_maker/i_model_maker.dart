part of maker;

class IModelMaker extends IMaker {

  IModelMaker(orm) : super() {
    _orm = orm;
  }

  void make(String targetPath) {
    // create i_model i_store directory
    makeSubDir(targetPath);

    // copy base model
    copyFile(_srcPath, 'i_pk.dart', _outCoreDir, 'i_pk.dart');
    copyFile(_srcPath, 'i_model.dart', _outCoreDir, 'i_model.dart');
    copyFile(_srcPath, 'i_list.dart', _outCoreDir, 'i_list.dart');
    copyFile(_srcPath, 'i_model_exception.dart', _outCoreDir, 'i_model_exception.dart');

    // make model files
    _orm.forEach((orm) {
      String lowerName = makeLowerUnderline(orm['name']);
      writeFile('${lowerName}_base_model.dart', _outModelDir, makeBaseModel(orm), true);
      writeFile('${lowerName}.dart', _outModelDir, makeModel(orm), true);
      writeFile('${lowerName}_base_pk.dart', _outModelDir, makeBasePK(orm), true);
      writeFile('${lowerName}_pk.dart', _outModelDir, makePK(orm), true);
      writeFile('${lowerName}_base_list.dart', _outModelDir, makeBaseList(orm), true);
      writeFile('${lowerName}_list.dart', _outModelDir, makeList(orm), true);
    });
    // make import package
    //writeFile('lib_i_model.dart', targetPath, makeModelPackage(), true);
  }
  
  String makeBaseModel(Map orm) {
    Map abbs = makeAbbs(orm['column']);
    List columns = [];
    Map mapAbb = {};
    Map mapFull = {};
    
    num length = orm['column'].length;
    
    for (num i = 0; i < length; ++i) {
      String full = orm['column'][i];
      columns.add({
        'i': i,
        'full': full,
        'abb': abbs[full],
        'toAdd': orm['toAddFilter'].contains(i),
        'toUpdate': orm['toUpdateFilter'].contains(i),
        'toAbb': orm['toAbbFilter'].contains(i),
        'toArray': orm['toArrayFilter'].contains(i),
        'toList': orm['toListFilter'].contains(i),
      });
      
      mapAbb[abbs[full]] = columns[i];
      mapFull[full] = columns[i];
    }

    String code = '''
${_DECLARATION}
part of lib_i_model;

class ${orm['name']}Base extends IModel {
  ${orm['name']}Base(args) : super(){
    _pk = ${orm['pk']};
    _columns = ${JSON.encode(columns)};
    _mapAbb = ${JSON.encode(mapAbb)};
    _mapFull = ${JSON.encode(mapFull)};

    _args = args == null ? new List.filled(${length}, null) : args;
    _length = ${length};
    _updatedList = new List.filled(${length}, false);
  }
''';

    for (num i = 0; i < length; ++i) {
      String full = orm['column'][i];
      code += '''

  void set ${full}(v) {
    if (_args[${i}] == v) return;
    _args[${i}] = v;
    _updatedList[${i}] = true;
  }
  get ${full} => _args[${i}];
''';
    }
    
    code += '}';

    return code;
  }
  String makeModel(Map orm) {
    String name = orm['name'];
    String code = '''
${_DECLARATION}
part of lib_i_model;

class ${name} extends ${name}Base {
  ${name}([args = null]) : super(args){}
}
''';
    return code;
  }
  String makeBasePK(Map orm) {
    String name = orm['name'];
    String code = '''
${_DECLARATION}
part of lib_i_model;

class ${name}BasePK extends IPK {
  ${name}BasePK(int pk) : super(){
    _pk = pk;
  }
}
''';
    return code;
  }
  String makePK(Map orm) {
    String name = orm['name'];
    String code = '''
${_DECLARATION}
part of lib_i_model;

class ${name}PK extends ${name}BasePK {
  ${name}PK([int pk = 0]) : super(pk){}
}
''';
    return code;
  }
  String makeBaseList(Map orm) {
    String name = orm['name'];
    String code = '''
${_DECLARATION}
part of lib_i_model;

class ${name}BaseList extends IList {
  ${name}BaseList(int pk, list) : super(){
    _pk = pk;
    if (list is Map) _list = list;
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

class ${name}List extends ${name}BaseList {
  ${name}List(int pk, [list = null]) : super(pk, list){}
}
''';
    return code;
  }

  String makeModelPackage() {
    String code ='''
${_DECLARATION}
library lib_i_model;

''';
    _orm.forEach((Map orm) {
      String lowerName = makeLowerUnderline(orm['name']);
      code += '''
part 'i_model_exception.dart';
part 'i_model.dart';
part 'i_pk.dart';
part 'i_list.dart';

part '${lowerName}_base_model.dart';
part '${lowerName}.dart';
part '${lowerName}_base_pk.dart';
part '${lowerName}_pk.dart';
part '${lowerName}_base_list.dart';
part '${lowerName}_list.dart';
''';
    });
    
    return code;
  }
}