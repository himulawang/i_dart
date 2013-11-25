part of lib_i_model;

abstract class IRedisStore {
  Future add(M model);
  Future get(num pk);
  Future set(M model);
}
