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
    '20021': 'Invalid pk when get model from redis.',
    '20022': 'Invalid model when add model to redis.',
    '20023': 'Invalid pk when add model to redis.',
    '20024': 'Model exists when add it.',
    '20025': 'Add model to redis failed.',
    '20026': 'Invalid model when set model to redis.',
    '20027': 'Invalid pk when set model to redis.',
    '20028': 'Model not exists when set it.',
    '20029': 'Set model to redis failed.',
    // mariaDB
    '21001': 'Cannot find config key [no] in mariaDB store.',
    '21002': 'Cannot find config key [host] in mariaDB store.',
    '21003': 'Cannot find config key [port] in mariaDB store.',
    '21004': 'Cannot find config key [pwd] in mariaDB store.',
    '21005': 'Cannot find config key [db] in mariaDB store.',
    '21006': 'Cannot find config key [usr] in mariaDB store.',
    '21007': 'Cannot find config key [maxHandler] in mariaDB store.',
    '21021': 'Invalid pk when get model from mariaDB.',
    '21022': 'Mutiple rows got from mariaDB.',
    '2l023': 'Invalid model when add model to mariaDB.',
    '21024': 'Invalid pk when add model to mariaDB.',
    '21025': 'Add model to mariaDB failed.',
    '21026': 'Invalid model when update model to mariaDB.',
    '21027': 'Invalid pk when update model to mariaDB.',
    '21028': 'Model not exists when update to mariaDB.',
    '21029': 'Update multiple model to mariaDB.',
  };
  IStoreException(int code, [List parameters]) {
    _code = code;
    _parameters = parameters;
    print('${code}:${_CODES[code.toString()]}');
  }
}
