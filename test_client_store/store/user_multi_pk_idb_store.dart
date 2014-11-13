/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_client_store;

class UserMultiPKIndexedDBStore extends IIndexedDBStore {
  static const String OBJECT_STORE_PK_NAME = '_pk';
  static const String OBJECT_STORE_VALUE_NAME = 'value';

  static const String _objectStore = 'PK';
  static const String _key = 'UserMultiPK';
  static const String _modelName = 'UserMultiPK';

  static const Map store = const {"type":"indexedDB","master":"GameIDB","objectStore":"PK","key":"UserMultiPK"};

  static Future set(UserMultiPK pk) {
    if (pk is! UserMultiPK) throw new IStoreException(30011, [_modelName]);
    if (!pk.isUpdated()) {
      new IStoreException(30502, [_modelName]);
      Completer completer = new Completer();
      completer.complete(pk);
      return completer.future;
    }

    num value = pk.get();
    if (value is! num) throw new IStoreException(30012);

    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);
    return handler.put({ OBJECT_STORE_PK_NAME: _key, OBJECT_STORE_VALUE_NAME: value })
    .then((setKey) {
      return pk..setUpdated(false);
    }).catchError(_handleErr);
  }

  static Future get() {
    UserMultiPK pk = new UserMultiPK();

    ObjectStore handler = new IIndexedDBHandlerPool().getReaderHandler(store);

    return handler.getObject(_key)
    .then((result) {
      if (result == null) return pk;
      return pk..set(result[OBJECT_STORE_VALUE_NAME])..setUpdated(false);
    }).catchError(_handleErr);
  }

  static Future del() {
    ObjectStore handler = new IIndexedDBHandlerPool().getWriteHandler(store);
    return handler.delete(_key).catchError(_handleErr);
  }

  static void _handleErr(e) {
    if (e is Event) throw e.target.error;
    throw e;
  }
}