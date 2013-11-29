part of i_maker;

class ILibraryMaker {
  String _outLibDir;
  void make(String targetPath) {
    _outLibDir = '${targetPath}/i_util_core';

  }
}
