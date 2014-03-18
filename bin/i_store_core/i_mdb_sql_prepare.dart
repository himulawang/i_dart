/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

class IMariaDBSQLPrepare {
  static String makeAdd(String table, Map mapFull, List columns) {
    List columnList = [];
    mapFull.forEach((full, i) {
      if (columns[i]['toAdd']) return;
      columnList.add(full);
    });
    if (columnList.length == 0) throw new IStoreException(21030);
    List values = new List.filled(columnList.length, '?');

    return 'INSERT INTO `${table}` (`${columnList.join("`, `")}`) VALUES (${values.join(", ")});';
  }

  static String makeSet(String table, IModel model) {
    Map toSetMap = model.toSetFull(true);
    if (toSetMap.length == 0) throw new IStoreException(21031);
    List columns = [];
    toSetMap.forEach((column, value) => columns.add("`${column}` = ?"));

    return 'UPDATE `${table}` SET ${columns.join(", ")} WHERE ${_makeWhere(model)};';
  }

  static String makeGet(String table, IModel model) {
    Map toGetMap = model.getMapFull();
    if (toGetMap.length == 0) throw new IStoreException(21032);

    return 'SELECT `${toGetMap.keys.join("`, `")}` FROM `${table}` WHERE ${_makeWhere(model)};';
  }

  static String makeDel(String table, IModel model) {
    return 'DELETE FROM `${table}` WHERE ${_makeWhere(model)};';
  }

  // list
  static String makeListGet(String table, IModel model) {
    Map toGetMap = model.getMapFull();
    if (toGetMap.length == 0) throw new IStoreException(21032);

    List listPKColumns = model.getListPKColumns();
    if (listPKColumns.length == 0) throw new IStoreException(21043);

    return 'SELECT `${toGetMap.keys.join("`, `")}` FROM `${table}` WHERE `${listPKColumns.join('` = ? AND `')}` = ?';
  }

  static List makeWhereValues(IModel model, List list) {
    var pk = model.getPK();
    if (pk is List) {
      if (pk.contains(null)) throw new IStoreException(21027);
      list.addAll(pk);
    } else {
      if (pk == null) throw new IStoreException(21027);
      list.add(pk);
    }
    return list;
  }

  static String _makeWhere(IModel model) => '`${model.getPKColumns().join('` = ? AND `')}` = ?';
}
