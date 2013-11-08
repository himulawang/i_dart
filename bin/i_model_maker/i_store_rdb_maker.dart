part of maker;

class IStoreRDBMaker extends IMaker {
  IStoreRDBMaker(orm) : super() {
    _orm = orm;
  }

  void make(String targetPath) {
    // create i_model i_store directory
    makeSubDir(targetPath);

    /*
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
    */
  }
}
