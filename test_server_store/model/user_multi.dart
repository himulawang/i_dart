/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_server_store;

class UserMulti extends IModel {
  static String _delimiter = ':';

  static const String _name = 'UserMulti';

  static const List _pk = const [0,1,3];
  static const List _pkColumns = const ["id","name","uniqueName"];
  static const List _listPKColumns = const ["id","name"];
  static const num _length = 5;
  static const List _columns = const [const {"i":0,"full":"id","abb":"i","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":true},const {"i":1,"full":"name","abb":"n","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":2,"full":"gender","abb":"g","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":3,"full":"uniqueName","abb":"un","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":4,"full":"value","abb":"v","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},];
  static const Map _mapAbb = const {"i":0,"n":1,"g":2,"un":3,"v":4};
  static const Map _mapFull = const {"id":0,"name":1,"gender":2,"uniqueName":3,"value":4};

  List _args;
  List<bool> _updatedList;
  bool _exist = false;

  UserMulti([List args = null]) : super() {
    if (args == null) {
      _args = new List.filled(_length, null);
    } else {
      if (args is! List) throw new IModelException(10010, [this.runtimeType, args]);
      if (args.length != _length) throw new IModelException(10009, [this.runtimeType, args.length, _length]);
      _args = args;
    }
    _updatedList = new List.filled(_length, false);
  }

  String getName() => _name;
  int getColumnCount() => _length;

  List getColumns() => _columns;
  Map getMapAbb() => _mapAbb;
  Map getMapFull() => _mapFull;

  void setExist([bool exist = true]) { _exist = exist; }
  bool isExist() => _exist;

  void setPK(idRaw, nameRaw, uniqueNameRaw) {
    id = idRaw;
    name = nameRaw;
    uniqueName = uniqueNameRaw;
  }
  List getPK() => [id, name, uniqueName];
  List getPKColumns() => _pkColumns;
  String getUnitedPK() {
    List pk = getPK();
    if (pk.contains(null)) throw new IModelException(10016, [pk]);
    return pk.join(_delimiter);
  }

  List getListPK() => [id, name];
  List getListPKColumns() => ["id","name"];
  String getUnitedListPK() {
    List listPK = getListPK();
    if (listPK.contains(null)) throw new IModelException(10020, [listPK]);
    return listPK.join(_delimiter);
  }

  List getChildPK() => [gender, uniqueName];
  String getUnitedChildPK() {
    List childPK = getChildPK();
    if (childPK.contains(null)) throw new IModelException(10018, [childPK]);
    return childPK.join(_delimiter);
  }

  List getWholePK() => [id, name, gender, uniqueName];
  String getUnitedWholePK() {
    List wholePK = getWholePK();
    if (wholePK.contains(null)) throw new IModelException(10019, [wholePK]);
    return wholePK.join(_delimiter);
  }

  void set id(v) {
    if (_args[0] == v) return;
    _args[0] = v;
    _updatedList[0] = true;
  }
  get id => _args[0];

  void set name(v) {
    if (_args[1] == v) return;
    _args[1] = v;
    _updatedList[1] = true;
  }
  get name => _args[1];

  void set gender(v) {
    if (_args[2] == v) return;
    _args[2] = v;
    _updatedList[2] = true;
  }
  get gender => _args[2];

  void set uniqueName(v) {
    if (_args[3] == v) return;
    _args[3] = v;
    _updatedList[3] = true;
  }
  get uniqueName => _args[3];

  void set value(v) {
    if (_args[4] == v) return;
    _args[4] = v;
    _updatedList[4] = true;
  }
  get value => _args[4];

  bool isUpdated() => _updatedList.any((bool e) => e);
  void setUpdatedList(bool flag) => _updatedList.fillRange(0, _length, flag);

  List toAddFixedList([bool filterOn = false]) {
    if (!filterOn) return _args.toList(growable: false);

    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (_columns[i]['toAdd']) continue;
      result[i] = _args[i];
    }
    return result;
  }
  List toAddList([bool filterOn = false]) {
    List result = [];
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toAdd']) continue;
      result.add(_args[i]);
    }
    return result;
  }
  Map toAddFull([bool filterOn = false]) {
    Map result = {};
    _mapFull.forEach((full, i) {
      if (filterOn && _columns[i]['toAdd']) return;
      result[full] = _args[i];
    });
    return result;
  }
  Map toAddAbb([bool filterOn = false]) {
    Map result = {};
    _mapAbb.forEach((abb, i) {
      if (filterOn && _columns[i]['toAdd']) return;
      result[abb] = _args[i];
    });
    return result;
  }

  List toSetFixedList([bool filterOn = false]) {
    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toSet']) continue;
      if (_updatedList[i]) result[i] = _args[i].toString();
    }
    return result;
  }
  List toSetList([bool filterOn = false]) {
    List result = [];
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toSet']) continue;
      if (_updatedList[i]) result.add(_args[i].toString());
    }
    return result;
  }
  Map toSetFull([bool filterOn = false]) {
    Map result = {};
    _mapFull.forEach((full, i) {
      if (filterOn && _columns[i]['toSet']) return;
      if (_updatedList[i]) result[full] = _args[i];
    });
    return result;
  }
  Map toSetAbb([bool filterOn = false]) {
    Map result = {};
    _mapAbb.forEach((abb, i) {
      if (filterOn && _columns[i]['toSet']) return;
      if (_updatedList[i]) result[abb] = _args[i];
    });
    return result;
  }

  List toFixedList([bool filterOn = false]) {
    List result = new List.filled(_length, null);
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toList']) continue;
      result[i] = _args[i];
    }
    return result;
  }
  List toList([bool filterOn = false]) {
    List result = [];
    for (num i = 0; i < _length; ++i) {
      if (filterOn && _columns[i]['toList']) continue;
      result.add(_args[i]);
    }
    return result;
  }
  Map toFull([bool filterOn = false]) {
    Map result = {};
    _mapFull.forEach((full, i) {
      if (filterOn && _columns[i]['toFull']) return;
      result[full] = _args[i];
    });
    return result;
  }
  Map toAbb([bool filterOn = false]) {
    Map result = {};
    _mapAbb.forEach((abb, i) {
      if (filterOn && _columns[i]['toAbb']) return;
      result[abb] = _args[i];
    });
    return result;
  }

  void fromList(List data, [bool changeUpdatedList = false]) {
    if (data is! List || data.length != _length) throw new IModelException(10006, [this.runtimeType, data.length, _length]);
    for (num i = 0; i < _args.length; ++i) {
      _args[i] = data[i];
    }
    if (changeUpdatedList) setUpdatedList(true);
  }
  void fromFull(Map data, [bool changeUpdatedList = false]) {
    if (data is! Map) throw new IModelException(10008, [this.runtimeType, data.length, _length]);

    _mapFull.forEach((String full, num i) {
      if (!data.containsKey(full)) return;
      _args[i] = data[full];
      if (changeUpdatedList) _updatedList[i] = true;
    });
  }
  void fromAbb(Map data, [bool changeUpdatedList = false]) {
    if (data is! Map) throw new IModelException(10007, [this.runtimeType, data.length, _length]);

    _mapAbb.forEach((String abb, num i) {
      if (!data.containsKey(abb)) return;
      _args[i] = data[abb];
      if (changeUpdatedList) _updatedList[i] = true;
    });
  }
}