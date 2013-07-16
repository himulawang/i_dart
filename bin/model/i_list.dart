/* Part of I Framework Model library
 * 
 */

part of lib_i_model;

class IList {
  int _pk;
  Map _list = {};
  Map _toAddList = {};
  Map _toDelList = {};
  Map _toUpdateList = {};
  bool _delFlag = false;
  
  String _checkInputIndex(input) {
    String index;
    if (input is int) {
      index = input.toString();
    } else if (input is String) {
      index = input;
    } else {
      throw new IModelException(10002);
    }
    return index;
  }
  
  void setPK(pk) {
    _pk = pk;
  }
  int getPK() {
    return _pk;
  }
  
  void set(model) {
    _list[_checkInputIndex(model.getPK())] = model;
  }
  get(input) {
    return _list[_checkInputIndex(input)];
  }
  void unset(input) {
    _list.remove(_checkInputIndex(input));    
  }

  void add(model) {
    String index = _checkInputIndex(model.getPK());
    if (_list.containsKey(index)) throw new IModelException(10003);
    
    _list[index] = model;
    _toAddList[index] = model;
  }
  void del(input) {
    String index;
    var model;
    if (input is int || input is String) {
      index = _checkInputIndex(input);
      model = get(index);
    } else {
      index = _checkInputIndex(input.getPK());
      model = get(index);
    }
    if (model == null) throw new IModelException(10004);
    
    if (_list.containsKey(index)) {
      _list.remove(index);
      _toDelList[index] = model;      
    }
    
    if (_toAddList.containsKey(index)) {
      _toAddList.remove(index);
    }
    
    if (_toUpdateList.containsKey(index)) {
      _toUpdateList.remove(index);
    }
  }
  void update(input) {
    String index = _checkInputIndex(input.getPK());
    var preModel = get(index);
    
    if (preModel == null) throw new IModelException(10005);
    
    _list[index] = input;
    if (_toAddList.containsKey(index)) {
      _toAddList[index] = input;
    }
    
    if (_toUpdateList.containsKey(index)) {
      _toUpdateList[index] = input;
    }
  }
  
  void markForDel([bool flag = true]) {
    _delFlag = flag;
  }
  
  Map toList([bool filterOn = false]) {
    Map result = {};
    _list.forEach((i, child) {
      result[i] = child.toList(filterOn);
    });
    return result;
  }
  Map toArray([bool filterOn = false]) {
    Map result = {};
    _list.forEach((i, child) {
      result[i] = child.toArray(filterOn);
    });
    return result;
  }
  Map toAbb([bool filterOn = false]) {
    Map result = {};
    _list.forEach((i, child) {
      result[i] = child.toAbb(filterOn);
    });
    return result;
  }
}