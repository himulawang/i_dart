/* Part of I Framework Model library
 * 
 */

part of lib_i_model;

class IModel {
  int _pk;
  num _length;
  List _args;
  List<bool> _updatedList;
  List _columns;
  Map _mapAbb;
  Map _mapFull;
  bool _addFlag = false;
  bool _delFlag = false;
  
  void setPK(pk) {
    _args[_pk] = pk;
  }  
  getPK() {
    return _args[_pk];
  }

  bool isUpdated() {
    for (var updated in _updatedList) {
      if (updated) return true;
    }
    return false;
  }
  
  List toAddList([bool filterOn = false]) {
    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toAdd']) continue;
      result[i] = _args[i];
    }
    return result;
  }
  Map toAddFull([bool filterOn = false]) {
    Map result = {};
    int i;
    _mapFull.forEach((full, detail) {
      i = detail['i'];
      if (filterOn && _columns[i]['toAdd']) return;
      result[full] = _args[i];
    });
    return result;
  }
  Map toAddAbb([bool filterOn = false]) {
    Map result = {};
    int i;
    _mapAbb.forEach((abb, detail) {
      i = detail['i'];
      if (filterOn && _columns[i]['toAdd']) return;
      result[abb] = _args[i];
    });
    return result;
  }
  
  List toUpdateList([bool filterOn = false]) {
    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toUpdate']) continue;
      if (_updatedList[i]) result[i] = _args[i].toString();
    }
    return result;
  }
  Map toUpdateFull([bool filterOn = false]) {
    Map result = {};
    int i;
    _mapFull.forEach((full, detail) {
      i = detail['i'];
      if (filterOn && _columns[i]['toUpdate']) return;
      result[full] = _args[i];
    });
    return result;
  }
  Map toUpdateAbb([bool filterOn = false]) {
    Map result = {};
    int i;
    _mapAbb.forEach((abb, detail) {
      i = detail['i'];
      if (filterOn && _columns[i]['toUpdate']) return;
      result[abb] = _args[i];
    });
    return result;
  }
  
  List toList([bool filterOn = false]) {
    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toList']) continue;
      if (_updatedList[i]) result[i] = _args[i].toString();
    }
    return result;
  }
  Map toArray([bool filterOn = false]) {
    Map result = {};
    int i;
    _mapFull.forEach((full, detail) {
      i = detail['i'];
      if (filterOn && _columns[i]['toArray']) return;
      result[full] = _args[i];
    });
    return result;
  }
  Map toAbb([bool filterOn = false]) {
    Map result = {};
    int i;
    _mapAbb.forEach((abb, detail) {
      i = detail['i'];
      if (filterOn && _columns[i]['toAbb']) return;
      result[abb] = _args[i];
    });
    return result;
  }

  void markForAdd([bool flag = true]) {
    _addFlag = flag;
  }
  void markForDel([bool flag = true]) {
    _delFlag = flag;
  }
}