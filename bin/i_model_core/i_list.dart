/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

class IList {
  num _pk;
  Map _list = {};
  Map _toAddList = {};
  Map _toDelList = {};
  Map _toSetList = {};

  void _unset(input) => _list.remove(_getInputIndex(input));
  bool _set(IModel model) => _list[_getInputIndex(model.getPK())] = model;

  bool setPK(num pk) => _pk = pk;
  num getPK() => _pk;

  Map getList() => _list;
  Map getToAddList() => _toAddList;
  Map getToDelList() => _toDelList;
  Map getToSetList() => _toSetList;

  String _getInputIndex(input) {
    String index;
    if (input is num) {
      index = input.toString();
    } else if (input is String) {
      index = input;
    } else {
      throw new IModelException(10002);
    }
    return index;
  }

  get(input) => _list[_getInputIndex(input)];
  void add(model) {
    String index = _getInputIndex(model.getPK());
    if (_list.containsKey(index)) throw new IModelException(10003);
    
    _list[index] = model;
    _toAddList[index] = model;
  }
  void set(IModel model) {
    if (get(model) == null) throw new IModelException(10005);

    String index = _getInputIndex(model.getPK());

    _list[index] = model;
    if (_toAddList.containsKey(index)) _toAddList[index] = model;

    if (_toSetList.containsKey(index)) _toSetList[index] = model;

    if (_toDelList.containsKey(index)) _toDelList.remove(index);
  }
  void del(input) {
    String index;
    IModel model;
    if (input is num || input is String) {
      index = _getInputIndex(input);
      model = get(index);
    } else {
      index = _getInputIndex(input.getPK());
      model = get(index);
    }
    if (model == null) throw new IModelException(10004);
    
    if (_list.containsKey(index)) {
      _list.remove(index);
      _toDelList[index] = model;
    }
    
    if (_toAddList.containsKey(index)) _toAddList.remove(index);

    if (_toSetList.containsKey(index)) _toSetList.remove(index);
  }

  Map toFixedList([bool filterOn = false]) {
    Map result = {};
    _list.forEach((String i, IModel child) {
      result[i] = child.toFixedList(filterOn);
    });
    return result;
  }
  Map toList([bool filterOn = false]) {
    Map result = {};
    _list.forEach((String i, IModel child) {
      result[i] = child.toList(filterOn);
    });
    return result;
  }
  Map toFull([bool filterOn = false]) {
    Map result = {};
    _list.forEach((String i, IModel child) {
      result[i] = child.toFull(filterOn);
    });
    return result;
  }
  Map toAbb([bool filterOn = false]) {
    Map result = {};
    _list.forEach((String i, IModel child) {
      result[i] = child.toAbb(filterOn);
    });
    return result;
  }
}