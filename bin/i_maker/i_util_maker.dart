part of i_maker;

class IUtilMaker extends IMaker {
  String _outUtilCoreDir;
  String _srcUtilCoreDir;

  IUtilMaker(Map deploy) : super(deploy);

  void make() {
    _srcUtilCoreDir = '${_iPath}/i_util';
    _outUtilCoreDir = '${_appPath}/i_util';

    // create i_util_core directory
    makeSubDir();

    // copy core util
    copyFile(_srcUtilCoreDir, 'i_hash.dart', _outUtilCoreDir, 'i_hash.dart');
    copyFile(_srcUtilCoreDir, 'i_log.dart', _outUtilCoreDir, 'i_log.dart');
  }

  void makeSubDir() {
    Directory coreDir = new Directory(_outUtilCoreDir);
    if (!coreDir.existsSync()) coreDir.createSync();
  }
}
