part of lib_i_model;

class IModelException {
  int _code;
  List _parameters;
  static final Map _CODES = {
    //'10001': 'Model has no pk when set to list.',
    '10002': 'Invalid index when check model pk from list.',
    '10003': 'Model exists when add model to list.',
    '10004': 'Model not exist when del model from list.',
    '10005': 'Model not exist when update model to list.',
    '10006': 'Invalid input data when fromList.',
    '10007': 'Invalid input data when fromAbb.',
    '10008': 'Invalid input data when fromFull.',
  };
  IModelException(int code, [List parameters]) {
    _code = code;
    _parameters = parameters;
    print('${code}:${_CODES[code.toString()]}');
  }
}