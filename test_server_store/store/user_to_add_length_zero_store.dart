/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */


part of lib_test_server_store;

class UserToAddLengthZeroStore {
  static Future add(UserToAddLengthZero model) {
    return UserToAddLengthZeroMariaDBStore.add(model)
    .then((_) => UserToAddLengthZeroRedisStore.add(model))
    .then((UserToAddLengthZero model) => model..setUpdatedList(false))
    ;
  }

  static Future set(UserToAddLengthZero model) {
    return UserToAddLengthZeroMariaDBStore.set(model)
    .then((_) => UserToAddLengthZeroRedisStore.set(model))
    .then((UserToAddLengthZero model) => model..setUpdatedList(false))
    ;
  }

  static Future get(id) {
    return UserToAddLengthZeroRedisStore.get(id)
    .then((UserToAddLengthZero model) {
      if (model.isExist()) return model;
      return UserToAddLengthZeroMariaDBStore.get(id);
    })
    ;
  }

  static Future del(UserToAddLengthZero model) {
    return UserToAddLengthZeroMariaDBStore.del(model)
    .then((_) => UserToAddLengthZeroRedisStore.del(model))
    ;
  }
}