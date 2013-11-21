part of lib_i_model;

class IStoreException {
  int _code;
  List _parameters;
  static final Map _CODES = {
    // redis
    '20001': 'Cannot find config key [no] in redis store.',
    '20002': 'Cannot find config key [host] in redis store.',
    '20003': 'Cannot find config key [port] in redis store.',
    '20004': 'Cannot find config key [pwd] in redis store.',
    '20005': 'Cannot find config key [db] in redis store.',
    '20006': 'Invalid config value [host] in redis store.',
    '20007': 'Model PK is null when get redis handler.',
    '20008': 'Invalid shardMethod.',
    '20009': 'Invalid input when get redis handler.',
    '20021': 'Invalid pk when get model.',
    '20022': 'Invalid model when add model.',
    '20023': 'Invalid pk when add model.',
    '20024': 'Model exists when add it.',
    '20025': 'Add model to redis failed.',
    '20026': 'Invalid model when set model.',
    '20027': 'Invalid pk when set model.',
    '20028': 'Model not exists when set it.',
    '20029': 'Set model to redis failed.',
  };
  IStoreException(int code, [List parameters]) {
    _code = code;
    _parameters = parameters;
    print('${code}:${_CODES[code.toString()]}');
  }
}
