/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_model;

class User extends IModel {
  static String _delimiter = ':';

  static const String _name = 'User';

  static const List _pk = const [0];
  static const List _pkColumns = const ["id"];
  static const List _listPKColumns = const ["id"];
  static const num _length = 18;
  static const List _columns = const [const {"i":0,"full":"id","abb":"i","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":1,"full":"name","abb":"n","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":2,"full":"userName","abb":"un","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":3,"full":"uniqueName","abb":"un1","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":4,"full":"underworldName","abb":"un2","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":5,"full":"underworldName1","abb":"un3","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":6,"full":"underworldName2","abb":"un4","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":7,"full":"thisIsABitLongerAttribute","abb":"tiabla","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":8,"full":"testAddFilterColumn1","abb":"tafc1","toAdd":true,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":9,"full":"testAddFilterColumn2","abb":"tafc2","toAdd":true,"toSet":false,"toAbb":false,"toFull":false,"toList":false},const {"i":10,"full":"testSetFilterColumn1","abb":"tsfc1","toAdd":false,"toSet":true,"toAbb":false,"toFull":false,"toList":false},const {"i":11,"full":"testSetFilterColumn2","abb":"tsfc2","toAdd":false,"toSet":true,"toAbb":false,"toFull":false,"toList":false},const {"i":12,"full":"testFullFilterColumn1","abb":"tffc1","toAdd":false,"toSet":false,"toAbb":false,"toFull":true,"toList":false},const {"i":13,"full":"testFullFilterColumn2","abb":"tffc2","toAdd":false,"toSet":false,"toAbb":false,"toFull":true,"toList":false},const {"i":14,"full":"testAbbFilterColumn1","abb":"tafc3","toAdd":false,"toSet":false,"toAbb":true,"toFull":false,"toList":false},const {"i":15,"full":"testAbbFilterColumn2","abb":"tafc4","toAdd":false,"toSet":false,"toAbb":true,"toFull":false,"toList":false},const {"i":16,"full":"testListFilterColumn1","abb":"tlfc1","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":true},const {"i":17,"full":"testListFilterColumn2","abb":"tlfc2","toAdd":false,"toSet":false,"toAbb":false,"toFull":false,"toList":true},];
  static const Map _mapAbb = const {"i":0,"n":1,"un":2,"un1":3,"un2":4,"un3":5,"un4":6,"tiabla":7,"tafc1":8,"tafc2":9,"tsfc1":10,"tsfc2":11,"tffc1":12,"tffc2":13,"tafc3":14,"tafc4":15,"tlfc1":16,"tlfc2":17};
  static const Map _mapFull = const {"id":0,"name":1,"userName":2,"uniqueName":3,"underworldName":4,"underworldName1":5,"underworldName2":6,"thisIsABitLongerAttribute":7,"testAddFilterColumn1":8,"testAddFilterColumn2":9,"testSetFilterColumn1":10,"testSetFilterColumn2":11,"testFullFilterColumn1":12,"testFullFilterColumn2":13,"testAbbFilterColumn1":14,"testAbbFilterColumn2":15,"testListFilterColumn1":16,"testListFilterColumn2":17};

  List _args;
  List<bool> _updatedList;
  bool _exist = false;

  User([List args = null]) : super() {
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

  void setPK(idRaw) {
    id = idRaw;
  }
  getPK() => id;
  List getPKColumns() => _pkColumns;

  String getUnitedPK() {
    var pk = getPK();
    if (pk == null) throw new IModelException(10015);
    return getPK().toString();
  }
  List getListPK() => [id];
  List getListPKColumns() => ["id"];
  String getUnitedListPK() {
    List listPK = getListPK();
    if (listPK.contains(null)) throw new IModelException(10020, [listPK]);
    return listPK.join(_delimiter);
  }

  List getChildPK() => [name];
  String getUnitedChildPK() {
    List childPK = getChildPK();
    if (childPK.contains(null)) throw new IModelException(10018, [childPK]);
    return childPK.join(_delimiter);
  }

  List getWholePK() => [id, name];
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

  void set userName(v) {
    if (_args[2] == v) return;
    _args[2] = v;
    _updatedList[2] = true;
  }
  get userName => _args[2];

  void set uniqueName(v) {
    if (_args[3] == v) return;
    _args[3] = v;
    _updatedList[3] = true;
  }
  get uniqueName => _args[3];

  void set underworldName(v) {
    if (_args[4] == v) return;
    _args[4] = v;
    _updatedList[4] = true;
  }
  get underworldName => _args[4];

  void set underworldName1(v) {
    if (_args[5] == v) return;
    _args[5] = v;
    _updatedList[5] = true;
  }
  get underworldName1 => _args[5];

  void set underworldName2(v) {
    if (_args[6] == v) return;
    _args[6] = v;
    _updatedList[6] = true;
  }
  get underworldName2 => _args[6];

  void set thisIsABitLongerAttribute(v) {
    if (_args[7] == v) return;
    _args[7] = v;
    _updatedList[7] = true;
  }
  get thisIsABitLongerAttribute => _args[7];

  void set testAddFilterColumn1(v) {
    if (_args[8] == v) return;
    _args[8] = v;
    _updatedList[8] = true;
  }
  get testAddFilterColumn1 => _args[8];

  void set testAddFilterColumn2(v) {
    if (_args[9] == v) return;
    _args[9] = v;
    _updatedList[9] = true;
  }
  get testAddFilterColumn2 => _args[9];

  void set testSetFilterColumn1(v) {
    if (_args[10] == v) return;
    _args[10] = v;
    _updatedList[10] = true;
  }
  get testSetFilterColumn1 => _args[10];

  void set testSetFilterColumn2(v) {
    if (_args[11] == v) return;
    _args[11] = v;
    _updatedList[11] = true;
  }
  get testSetFilterColumn2 => _args[11];

  void set testFullFilterColumn1(v) {
    if (_args[12] == v) return;
    _args[12] = v;
    _updatedList[12] = true;
  }
  get testFullFilterColumn1 => _args[12];

  void set testFullFilterColumn2(v) {
    if (_args[13] == v) return;
    _args[13] = v;
    _updatedList[13] = true;
  }
  get testFullFilterColumn2 => _args[13];

  void set testAbbFilterColumn1(v) {
    if (_args[14] == v) return;
    _args[14] = v;
    _updatedList[14] = true;
  }
  get testAbbFilterColumn1 => _args[14];

  void set testAbbFilterColumn2(v) {
    if (_args[15] == v) return;
    _args[15] = v;
    _updatedList[15] = true;
  }
  get testAbbFilterColumn2 => _args[15];

  void set testListFilterColumn1(v) {
    if (_args[16] == v) return;
    _args[16] = v;
    _updatedList[16] = true;
  }
  get testListFilterColumn1 => _args[16];

  void set testListFilterColumn2(v) {
    if (_args[17] == v) return;
    _args[17] = v;
    _updatedList[17] = true;
  }
  get testListFilterColumn2 => _args[17];

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