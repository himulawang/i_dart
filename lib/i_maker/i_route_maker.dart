part of i_maker;

class IRouteMaker extends IMaker {
  String _outConfigDir;
  String _srcConfigDir;

  IRouteMaker(Map deploy) : super(deploy);

  void makeServer() {
    _srcConfigDir = '${_iPath}/i_route_config';
    _outConfigDir = '${_appPath}/i_config';

    // copy route config
    copyFileWithHeader(_srcConfigDir, 'server_route.dart', _outConfigDir, 'server_route.dart', 'part of lib_${_app};', false);
  }

  void makeClient() {
    _srcConfigDir = '${_iPath}/i_route_config';
    _outConfigDir = '${_appPath}/i_config';

    // copy route config
    copyFileWithHeader(_srcConfigDir, 'client_route.dart', _outConfigDir, 'client_route.dart', 'part of lib_${_app};', false);
  }
}
