part of i;

class IException {
  int _code;
  List _parameters;
  IException(int code, [List parameters]) {
    _code = code;
    _parameters = parameters;
  }
}