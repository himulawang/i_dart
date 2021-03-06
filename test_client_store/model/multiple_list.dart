/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_client_store;

class MultipleList extends IList {
  static String _delimiter = ':';
  MultipleList(id, name) { _initPK([id, name]); }

  MultipleList.filledMap(id, name, Map dataList) {
    _initPK([id, name]);

    dataList.forEach((String i, Multiple model) {
      if (model is! Multiple) return;
      rawSet(model);
    });
  }

  MultipleList.filledList(id, name, List dataList) {
    _initPK([id, name]);

    dataList.forEach((Multiple model) {
      if (model is! Multiple) return;
      rawSet(model);
    });
  }

  _initPK(List pk) => pks = pk;

  setPK(id, name) => pks = [id, name];
  String getUnitedPK() {
    if (pks.contains(null)) throw new IModelException(10021);
    return pks.join(_delimiter);
  }

  Multiple get(gender, uniqueName) => list["${gender}${_delimiter}${uniqueName}"];

  void fromList(List dataList, [bool changeUpdatedList = false]) {
    if (dataList is! List) throw new IModelException(10012, [this.runtimeType]);

    dataList.forEach((List data) {
      Multiple model = new Multiple();
      model.fromList(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (get(model.getUnitedChildPK()) == null) {
          add(model);
        } else {
          set(model);
        }
      } else {
        rawSet(model);
      }
    });
  }
  void fromFull(Map dataList, [bool changeUpdatedList = false]) {
    if (dataList is! Map) throw new IModelException(10013, [this.runtimeType]);

    dataList.forEach((String i, Map data) {
      Multiple model = new Multiple();
      model.fromFull(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (get(model.getUnitedChildPK()) == null) {
          add(model);
        } else {
          set(model);
        }
      } else {
        rawSet(model);
      }
    });
  }
  void fromAbb(Map dataList, [bool changeUpdatedList = false]) {
    if (dataList is! Map) throw new IModelException(10014, [this.runtimeType]);

    dataList.forEach((String i, Map data) {
      Multiple model = new Multiple();
      model.fromAbb(data, changeUpdatedList);
      if (changeUpdatedList) {
        if (get(model.getUnitedChildPK()) == null) {
          add(model);
        } else {
          set(model);
        }
      } else {
        rawSet(model);
      }
    });
  }
}
