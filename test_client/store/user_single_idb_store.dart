/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

part of lib_test;

class UserSingleIndexedDBStore extends IIndexedDBStore {
  static const Map store = const {"type":"indexedDB","master":"GameIDB","objectStore":"UserSingle"};

  static Future add(UserSingle model) {
    if (model is! UserSingle) throw new IStoreException(22004);
    Map toAddAbb = model.toAddAbb(true);
    if (toAddAbb.length == 0) throw new IStoreException(22005);

    toAddAbb['_pk'] = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.add(toAddAbb)
    .then((addKey) {
      return model..setUpdatedList(false);
    }).catchError((e) {
      print(e);
      throw e;
    });
  }

  static _makeKey(UserSingle model) {
    var pk = model.getPK();
    if (pk is List) {
      if (pk.contains(null)) throw new IStoreException(22006);
    } else {
      if (pk == null) throw new IStoreException(22006);
    }
    return pk;
  }
}
    