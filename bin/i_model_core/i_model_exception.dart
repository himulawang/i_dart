/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

class IModelException {
  int code;
  List parameters;
  static final Map _CODES = {
    //'10001': 'Model has no pk when set to list.',
    //'10002': 'Invalid index when check model pk from list.',
    '10003': 'Model exists when add model to list.',
    '10004': 'Model not exist when del model from list.',
    '10005': 'Model not exist when update model to list.',
    '10006': 'Invalid input data when fromList.',
    '10007': 'Invalid input data when fromAbb.',
    '10008': 'Invalid input data when fromFull.',
    '10009': 'Invalid input args length when construct model.',
    '10010': 'Invalid input args type when construct model.',
    '10011': 'Invalid pk when initialize list.',
    '10012': 'Invalid datas when fromList.',
    '10013': 'Invalid datas when fromFull.',
    '10014': 'Invalid datas when fromAbb.',
    '10015': 'PK is not set.',
    '10016': 'Multiple PK is not set.',
    '10017': 'ChildPK is not set.',
    '10018': 'Multiple ChildPK is not set.',
  };
  IModelException(int inputCode, [List inputParameters]) {
    code = inputCode;
    parameters = inputParameters;
    ILog.severe('IStoreException ${code}: ${_CODES[code.toString()]}');
  }
}