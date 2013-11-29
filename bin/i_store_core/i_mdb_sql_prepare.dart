part of lib_i_model;

class IMariaDBSQLPrepare {
  static String makeAdd(M model) {
    Map toAddMap = model.toAddFull(true);
    if (toAddMap.length == 0) throw new IStoreException(21030);
    List values = new List.filled(toAddMap.length, '?');

    return 'INSERT INTO `${model.getName()}` (`${toAddMap.keys.join("`, `")}`) VALUES (${values.join(", ")});';
  }

  static String makeSet(M model) {
    Map toSetMap = model.toSetFull(true);
    if (toSetMap.length == 0) throw new IStoreException(21031);
    List columns = [];
    toSetMap.forEach((column, value) => columns.add("`${column}` = ?"));

    return 'UPDATE `${model.getName()}` SET ${columns.join(", ")} WHERE `${model.getPKName()}` = ?;';
  }

  static String makeGet(M model) {
    Map toGetMap = model.getMapFull();
    if (toGetMap.length == 0) throw new IStoreException(21032);

    return 'SELECT `${toGetMap.keys.join("`, `")}` FROM `${model.getName()}` WHERE `${model.getPKName()}` = ?;';
  }

  static String makeDel(M model) {
    return 'DELETE FROM `${model.getName()}` WHERE `${model.getPKName()}` = ?;';
  }
}
