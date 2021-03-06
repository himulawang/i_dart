/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_server_store;

class UserListStore {
  static Future set(UserList list) {
    return UserListMariaDBStore.set(list)
    .then((_) => UserListRedisStore.set(list))
    .then((UserList list) => list..resetAllToList())
    ;
  }

  static Future get(id) {
    return UserListRedisStore.get(id)
    .then((UserList list) {
      if (list.isExist()) return list;
      return UserListMariaDBStore.get(id);
    })
    ;
  }

  static Future del(UserList list) {
    return UserListMariaDBStore.del(list)
    .then((_) => UserListRedisStore.del(list))
    ;
  }
}
