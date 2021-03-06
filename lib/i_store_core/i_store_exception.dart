/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

part of i_dart;

class IStoreException extends IException {
  static final Map _CODES = {
      // redis exception
      //'20001': '',
      //'20002': '',
      //'20003': '',
      //'20004': '',
      //'20005': '',
      //'20006': '',
      '20007': 'Model PK is null when get redis handler.',
      '20008': 'Invalid shardMethod when use redis.',
      '20009': 'Invalid input when get redis handler.',
      //'20021': '',
      '20022': 'Invalid model %% when add model %% to redis.',
      //'20023': '',
      '20024': 'Model %% exists when add it.',
      '20025': 'Add model %% to redis failed.',
      '20026': 'Invalid model %% when set model %% to redis.',
      '20027': 'Invalid pk when set model to redis.',
      '20028': 'Model %% not exists when set it.',
      '20029': 'Set model %% to redis failed.',
      '20030': 'Invalid model %% when del model %% from redis.',
      '20031': 'Model does not exist when get from redis.',
      '20032': 'Model %% has no attribute to add to redis.',
      '20033': 'Redis handler pool is not initialized.',
      '20034': 'PK invalid when set to redis input: %%, expect: %%.',
      '20035': 'PK %% value invalid when set to redis, value: %%.',
      '20036': 'Set PK to redis failed for model: %%.',
      //'20037': '',
      '20038': 'Invalid list when del list from redis, input: %%, expect: %%.',
      //'20039': '',
      '20040': 'Invalid list when set list to redis, input: %%, expect: %%.',
      //'20041': '',
      '20042': 'Invalid pk when make redis key for model: %%.',

      // redis warning
      '20501': 'Model %% has no attribute to set to redis.',
      '20502': 'No record affected when del model %% from redis.',
      '20503': 'Model %% does not exist when get it.',
      '20504': 'Set expire failed when add model to redis for model: %%.',
      '20505': 'PK has not changed when set to redis for model: %%.',
      '20506': 'PK not exist when get it from redis for model: %%.',
      '20507': 'PK not exist when del it from redis for model: %%.',
      '20508': 'List not exist when get it from redis for model: %%.',
      '20509': 'List is not changed when set to redis for model: %%.',
      '20510': 'Set expire failed when set model to redis for model: %%.',

      // mariaDB
      '21001': 'Cannot find config key [no] in mariaDB store.',
      '21002': 'Cannot find config key [host] in mariaDB store.',
      '21003': 'Cannot find config key [port] in mariaDB store.',
      '21004': 'Cannot find config key [pwd] in mariaDB store.',
      '21005': 'Cannot find config key [db] in mariaDB store.',
      '21006': 'Cannot find config key [usr] in mariaDB store.',
      '21007': 'Cannot find config key [maxHandler] in mariaDB store.',
      //'21021': '',
      '21022': 'Model %% got mutiple rows from mariaDB.',
      '21023': 'Invalid model %% when add model %% to mariaDB.',
      //'21024': '',
      '21025': 'Add model %% to mariaDB failed.',
      '21026': 'Invalid model %% when set model %% to mariaDB.',
      '21027': 'Invalid pk when make where values.',
      '21028': 'PK conflict when add model %% to mariaDB.',
      '21029': 'MariaDB handler pool is not initialized.',
      '21030': 'No column to use when making add SQL for mariaDB.',
      '21031': 'No column to use when making set SQL for mariaDB.',
      '21032': 'No column to use when making get SQL for mariaDB.',
      '21033': 'No column to use when making del SQL for mariaDB.',
      '21034': 'Invalid model %% when del model %% from mariaDB.',
      '21035': 'Model %% has no attribute to add to mariaDB.',
      '21036': 'PK %% invalid when set %% to mariaDB.',
      '21037': 'PK value invalid when set %% to mariaDB.',
      '21038': 'Set pk %% to mariaDB failed.',
      '21039': 'Invalid list %% when set list %% to mariaDB.',
      '21040': 'Invalid shardMethod when use mariaDB.',
      //'21041': '',
      '21042': 'No column to use when making add list SQL for mariaDB.',
      '21043': 'No column to use when making list get SQL for mariaDB.',

      // mariaDB warning
      '21501': 'Model %% has no attribute to set to mariaDB.',
      '21502': 'No record affected when set model %% to mariaDB.',
      '21503': 'Multiple records affected when set model %% to mariaDB.',
      '21504': 'No record affected when del model %% from mariaDB.',
      '21505': 'Multiple records affected when del model %% from mariaDB.',
      '21506': 'PK %% has not changed when set to mariaDB.',
      '21507': 'PK %% not exist when del it from mariaDB.',
      '21508': 'List %% is not changed when set to mariaDB.',
      '21509': 'Model has no attribute to add when set list to mariaDB.',
      '21510': 'No record affected when update list & set model %% to mariaDB.',
      '21511': 'Multiple records affected when update list & set model %% to mariaDB.',
      '21512': 'No record affected when update list & del model %% from mariaDB.',
      '21513': 'Multiple records affected when update list & del model %% from mariaDB.',

      // indexedDB
      '30001': 'Browser do not support IndexedDB.',
      '30002': 'Cannot find upgrade script when init IndexedDB.',
      '30003': 'IndexedDB handler pool is not initialized.',
      '30004': 'Invalid model %% when add model %% to indexedDB.',
      '30005': 'Model %% has no attribute to add to indexedDB.',
      '30006': 'Invalid pk when make pk key for model: %%.',
      '30007': 'Add model %% to indexedDB failed, model already exists.',
      '30008': 'Invalid model %% when set model %% to indexedDB.',
      '30009': 'Model %% has no attribute to set to indexedDB.',
      '30010': 'Invalid model %% when del model %% from indexedDB.',
      '30011': 'Invalid pk %% when set pk to indexedDB.',
      '30012': 'PK %% value invalid when set to indexedDB.',
      '30013': 'Invalid list %% when set list %% to indexedDB.',

      // indexedDB warning
      '30501': 'Model %% has no attribute to set to indexedDB.',
      '30502': 'PK %% has not changed when set to indexedDB.',
      '30503': 'List %% is not changed when set to indexedDB.',
      '30504': 'Model %% exists when add list to indexedDB.',
      '30505': 'Model %% has no attribute to add when set list to indexedDB.',
      '30506': 'Model %% has no attribute to set when set list to indexedDB.',

  };

  IStoreException(int inputCode, [List params]) {
    if (inputCode.toString()[2] == '5') {
      super.warning(inputCode, params, _CODES);
    } else {
      super.shout(inputCode, params, _CODES);
    }
  }
}
