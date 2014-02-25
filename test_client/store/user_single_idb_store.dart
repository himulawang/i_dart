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
      if (e is Event) {
        if (e.target.error.message == 'Key already exists in the object store.') {
          throw new IStoreException(22007);
        }
        throw e.target.error;
      }
      throw e;
    });
  }

  static Future set(UserSingle model) {
    if (model is! UserSingle) throw new IStoreException(22008);

    // model has not been updated
    if (!model.isUpdated()) {
      new IStoreException(27001);
      Completer completer = new Completer();
      completer.complete(model);
      return completer.future;
    }

    // indexedDB do not like redis, put(set) will overwrite the whole key
    // so we use toSet filter the whole _args
    Map toSetAbb = {};
    UserSingle._mapAbb.forEach((abb, i) {
      if (UserSingle._columns[i]['toSet']) return;
      toSetAbb[abb] = model._args[i];
    });
    if (toSetAbb.length == 0) throw new IStoreException(22009);

    toSetAbb['_pk'] = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.put(toSetAbb)
    .then((setKey) {
      return model..setUpdatedList(false);
    }).catchError(_handleErr);
  }

  static Future get(id) {
    UserSingle model = new UserSingle()..setPK(id);

    var pk = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.getObject(pk)
    .then((result) {
      if (result == null) return model;
      return model..fromAbb(result)..setExist();
    }).catchError(_handleErr);
  }

  static Future del(UserSingle model) {
    if (model is! UserSingle) throw new IStoreException(22010);

    var pk = _makeKey(model);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);

    return handler.delete(pk).catchError(_handleErr);
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

  static _handleErr(e) {
    if (e is Event)  throw e.target.error;
    throw e;
  }
}
    