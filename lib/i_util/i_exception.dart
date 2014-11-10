part of i_dart;

class IException {
  int code;
  String message;
  List parameters;

  shout(int inputCode, List params, Map CODES) {
    _makeMessage(inputCode, params, CODES);

    ILog.severe('${this.runtimeType.toString()} ${code}: ${message}');
  }

  warning(int inputCode, List params, Map CODES) {
    _makeMessage(inputCode, params, CODES);

    ILog.warning('${this.runtimeType.toString()} ${code}: ${message}');
  }

  _makeMessage(int inputCode, List params, Map CODES) {
    if (params == null) params = [];

    code = inputCode;
    parameters = params;
    String msg = CODES[code.toString()];

    int i = 0;
    while(msg.contains('%%')) {
      if (params.length - 1 < i) {
        msg = msg.replaceFirst('%%', '[NOT_SET]');
      } else {
        msg = msg.replaceFirst('%%', params[i].toString());
      }
      ++i;
    }

    message = msg;
  }
}
