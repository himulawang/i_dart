/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

class IStoreException {
  int code;
  List parameters;
  static final Map _CODES = {
      // redis exception
      '20001': 'Cannot find config key [no] in redis store.',
      '20002': 'Cannot find config key [host] in redis store.',
      '20003': 'Cannot find config key [port] in redis store.',
      '20004': 'Cannot find config key [pwd] in redis store.',
      '20005': 'Cannot find config key [db] in redis store.',
      '20006': 'Invalid config value [host] in redis store.',
      '20007': 'Model PK is null when get redis handler.',
      '20008': 'Invalid shardMethod.',
      '20009': 'Invalid input when get redis handler.',
      //'20021': 'Invalid pk when get model from redis.',
      '20022': 'Invalid model when add model to redis.',
      //'20023': 'Invalid pk when add model to redis.',
      '20024': 'Model exists when add it.',
      '20025': 'Add model to redis failed.',
      '20026': 'Invalid model when set model to redis.',
      '20027': 'Invalid pk when set model to redis.',
      '20028': 'Model not exists when set it.',
      '20029': 'Set model to redis failed.',
      '20030': 'Invalid model when del model from redis.',
      '20031': 'Model does not exist when get from redis.',
      '20032': 'Model has no attribute to add to redis.',
      '20033': 'Redis handler pool is not initialized.',
      '20034': 'PK invalid when set to redis.',
      '20035': 'PK value invalid when set to redis.',
      '20036': 'Set PK to redis failed.',
      '20037': 'Invalid id when get list from redis.',
      '20038': 'Invalid list when del list from redis.',
      '20039': 'Invalid id when del list from redis.',
      '20040': 'Invalid list when set list from redis.',
      //'20041': 'Invalid id when set list from redis.',
      '20042': 'Invalid pk when make redis key.',
      // mariaDB
      '21001': 'Cannot find config key [no] in mariaDB store.',
      '21002': 'Cannot find config key [host] in mariaDB store.',
      '21003': 'Cannot find config key [port] in mariaDB store.',
      '21004': 'Cannot find config key [pwd] in mariaDB store.',
      '21005': 'Cannot find config key [db] in mariaDB store.',
      '21006': 'Cannot find config key [usr] in mariaDB store.',
      '21007': 'Cannot find config key [maxHandler] in mariaDB store.',
      //'21021': 'Invalid pk when get model from mariaDB.',
      '21022': 'Mutiple rows got from mariaDB.',
      '21023': 'Invalid model when add model to mariaDB.',
      '21024': 'Invalid pk when add model to mariaDB.',
      '21025': 'Add model to mariaDB failed.',
      '21026': 'Invalid model when set model to mariaDB.',
      '21027': 'Invalid pk when make where values.',
      '21028': 'PK conflict when add model to mariaDB.',
      '21029': 'MariaDB handler pool is not initialized.',
      '21030': 'No column to use when making add SQL for mariaDB.',
      '21031': 'No column to use when making set SQL for mariaDB.',
      '21032': 'No column to use when making get SQL for mariaDB.',
      '21033': 'No column to use when making del SQL for mariaDB.',
      '21034': 'Invalid model when del model from mariaDB.',
      '21035': 'Model has no attribute to add to mariaDB.',
      '21036': 'PK invalid when set to mariaDB.',
      '21037': 'PK value invalid when set to mariaDB.',
      '21038': 'Set pk to mariaDB failed.',
      // indexedDB
      '22001': 'Browser do not support IndexedDB.',
      '22002': 'Cannot find upgrade script when init IndexedDB.',
      '22003': 'IndexedDB handler pool is not initialized.',
      '22004': 'Invalid model when add model to indexedDB.',
      '22005': 'Model has no attribute to add to indexedDB.',
      '22006': 'Invalid pk when make pk key.',
      '22007': 'Add key to indexedDB failed.',
      '22008': 'Invalid model when set model to indexedDB.',
      '22009': 'Model has no attribute to set to indexedDB.',
      '22010': 'Invalid model when del model from indexedDB.',

      // redis warning
      '25001': 'Model has no attribute to set to redis.',
      '25002': 'No record affected when del model from redis.',
      '25003': 'Model does not exist when set it.',
      '25004': 'Set expire failed when add model to redis.',
      '25005': 'PK has not changed when set to redis.',
      '25006': 'PK not exist when get it from redis.',
      '25007': 'PK not exist when del it from redis.',
      '25008': 'List not exist when get it from redis.',
      '25009': 'List not changed when set to redis.',
      // mariaDB warning
      '26001': 'Model has no attribute to set to mariaDB.',
      '26002': 'No record affected when set model to mariaDB.',
      '26003': 'Multiple records affected when set model to mariaDB.',
      '26004': 'No record affected when del model from mariaDB.',
      '26005': 'Multiple records affected when del model from mariaDB.',
      '26006': 'PK has not changed when set to mariaDB.',
      '26007': 'PK not exist when del it from mariaDB.',
      // indexedDB warning
      '27001': 'Model has no attribute to set to indexedDB.',

  };
  IStoreException(int inputCode, [List inputParameters]) {
    code = inputCode;
    parameters = inputParameters;
    if (code > 25000) {
      ILog.warning('IStoreWarning ${code}: ${_CODES[code.toString()]}');
    } else {
      ILog.severe('IStoreException ${code}: ${_CODES[code.toString()]}');
    }
  }
}
