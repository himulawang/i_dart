part of i_maker;

class IRouteMaker extends IMaker {
  String _outRouteCoreDir;
  String _srcRouteCoreDir;

  String _outConfigDir;
  String _srcConfigDir;

  IRouteMaker(Map deploy) : super(deploy);

  void makeServer() {
    _srcRouteCoreDir = '${_iPath}/i_route_core';
    _outRouteCoreDir = '${_appPath}/i_route_core';

    _srcConfigDir = '${_iPath}/i_route_config';
    _outConfigDir = '${_appPath}/i_config';

    // create i_route_core directory
    makeSubDir();

    // copy route config
    copyFileWithHeader(_srcConfigDir, 'server_route.dart', _outConfigDir, 'server_route.dart', 'part of lib_${_app};', false);

    // copy core route
    copyFileWithHeader(_srcRouteCoreDir, 'i_route_validator.dart', _outRouteCoreDir, 'i_route_validator.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcRouteCoreDir, 'i_route_srv_exception.dart', _outRouteCoreDir, 'i_route_srv_exception.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcRouteCoreDir, 'i_websocket_srv_handler.dart', _outRouteCoreDir, 'i_websocket_srv_handler.dart', 'part of lib_${_app};');
  }

  void makeClient() {
    _srcRouteCoreDir = '${_iPath}/i_route_core';
    _outRouteCoreDir = '${_appPath}/i_route_core';

    _srcConfigDir = '${_iPath}/i_route_config';
    _outConfigDir = '${_appPath}/i_config';

    // create i_route_core directory
    makeSubDir();

    // copy route config
    copyFileWithHeader(_srcConfigDir, 'client_route.dart', _outConfigDir, 'client_route.dart', 'part of lib_${_app};', false);

    // copy core route
    copyFileWithHeader(_srcRouteCoreDir, 'i_route_clt_exception.dart', _outRouteCoreDir, 'i_route_clt_exception.dart', 'part of lib_${_app};');
    copyFileWithHeader(_srcRouteCoreDir, 'i_websocket_clt_handler.dart', _outRouteCoreDir, 'i_websocket_clt_handler.dart', 'part of lib_${_app};');
  }

  void makeSubDir() {
    Directory coreDir = new Directory(_outRouteCoreDir);
    if (!coreDir.existsSync()) coreDir.createSync();
  }
}
