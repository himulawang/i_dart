part of i_maker;

class IStoreMaker extends IMaker {
  String _outStoreCoreDir;
  String _srcStoreCoreDir;
  String _outStoreDir;

  IStoreMaker(List orm) : super() {
    _orm = orm;
  }

  void make(String targetPath) {
    _srcStoreCoreDir = '${_rootDir}/../bin/i_store_core';
    _outStoreCoreDir = '${targetPath}/i_store_core';
    _outStoreDir = '${targetPath}/store';

    makeSubDir(targetPath);

    // copy core store
    copyFile(_srcStoreCoreDir, 'i_rdb_store.dart', _outStoreCoreDir, 'i_rdb_store.dart');
    copyFile(_srcStoreCoreDir, 'i_mdb_store.dart', _outStoreCoreDir, 'i_mdb_store.dart');
    copyFile(_srcStoreCoreDir, 'i_rdb_handler_pool.dart', _outStoreCoreDir, 'i_rdb_handler_pool.dart');
    copyFile(_srcStoreCoreDir, 'i_mdb_handler_pool.dart', _outStoreCoreDir, 'i_mdb_handler_pool.dart');
    copyFile(_srcStoreCoreDir, 'i_mdb_sql_prepare.dart', _outStoreCoreDir, 'i_mdb_sql_prepare.dart');
    copyFile(_srcStoreCoreDir, 'i_store_exception.dart', _outStoreCoreDir, 'i_store_exception.dart');

    /*
    // make store files
    _orm.forEach((orm) {
      String lowerName = makeLowerUnderline(orm['name']);
      writeFile('${lowerName}.dart', _outStoreDir, makeStore(orm), true);
    });
    // make import package
    // writeFile('lib_i_model.dart', targetPath, makeModelPackage(), true);
    */
  }

  String makeStore(Map orm) {
    StringBuffer codeSB = new StringBuffer();
  }

  void makeSubDir(String targetPath) {
    Directory coreDir = new Directory(_outStoreCoreDir);
    if (!coreDir.existsSync()) coreDir.createSync();

    Directory storeDir = new Directory(_outStoreDir);
    if (!storeDir.existsSync()) storeDir.createSync();
  }
}
