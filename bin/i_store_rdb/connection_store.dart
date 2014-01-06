part of lib_i_model;

class ConnectionStore {
  static Future add(Connection model) {
    return
    ConnectionMariaDBStore.add(model)
    .then((_) => ConnectionRedisStore.add(model));
  }

  static Future set(Connection model) {
    return
    ConnectionMariaDBStore.set(model)
    .then((_) => ConnectionRedisStore.set(model));
  }

  static Future get(num pk) {
    return
    ConnectionRedisStore.get(pk)
    .then((model) {
      if (model.isExist()) return model;
      return ConnectionMariaDBStore.get(pk);
    });
  }

  static Future del(input) {
    return
    ConnectionMariaDBStore.del(input)
    .then((_) => ConnectionRedisStore.del(input));
  }
}
