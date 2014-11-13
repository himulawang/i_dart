/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_server_store;

class UserMultiListStore {
  static Future set(UserMultiList list) {
    return UserMultiListMariaDBStore.set(list)
    .then((_) => UserMultiListRedisStore.set(list))
    .then((UserMultiList list) => list..resetAllToList())
    ;
  }

  static Future get(id, name) {
    return UserMultiListRedisStore.get(id, name)
    .then((UserMultiList list) {
      if (list.isExist()) return list;
      return UserMultiListMariaDBStore.get(id, name);
    })
    ;
  }

  static Future del(UserMultiList list) {
    return UserMultiListMariaDBStore.del(list)
    .then((_) => UserMultiListRedisStore.del(list))
    ;
  }
}
