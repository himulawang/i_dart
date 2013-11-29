part of i_maker;

class IUtilMaker extends IMaker {
  String _outUtilCoreDir;
  String _srcUtilCoreDir;
  void make(String targetPath) {
    _srcUtilCoreDir = '${_rootDir}/../bin/i_util_core';
    _outUtilCoreDir = '${targetPath}/i_util_core';

    // create i_util_core directory
    makeSubDir(targetPath);

    // copy core util
    copyFile(_srcUtilCoreDir, 'i_hash.dart', _outUtilCoreDir, 'i_hash.dart');
    copyFile(_srcUtilCoreDir, 'i_log.dart', _outUtilCoreDir, 'i_log.dart');
  }
  void makeSubDir(String targetPath) {
    Directory coreDir = new Directory(_outUtilCoreDir);
    if (!coreDir.existsSync()) coreDir.createSync();
  }
}
