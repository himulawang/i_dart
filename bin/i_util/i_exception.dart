class IException {
  int code;
  String message;
  List parameters;

  shout(int inputCode, List inputParameters, Map CODES) {
    if (inputParameters == null) inputParameters = [];

    code = inputCode;
    parameters = inputParameters;
    String msg = CODES[code.toString()];

    int i = 0;
    while(msg.contains('%%')) {
      if (inputParameters.length - 1 < i) {
        msg = msg.replaceFirst('%%', '[NOT_SET]');
      } else {
        msg = msg.replaceFirst('%%', inputParameters[i].toString());
      }
      ++i;
    }

    message = msg;

    ILog.severe('${this.runtimeType.toString()} ${code}: ${msg}');
  }
}
