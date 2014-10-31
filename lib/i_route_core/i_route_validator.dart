class IRouteValidator {
  static const ALLOW_NONE = 'n';
  static const ALLOW_EMPTY = 'e';
  static const REQUIRED = 'r';

  static const INT = 'i';
  static const UNSIGNED_NUMBER = 'u';
  static const BOOL = 'b';
  static const STRING = 's';
  static const DOUBLE = 'd';
  static const LIST = 'l';
  static const MAP = 'm';
  static const JSON = 'j';

  // TODO pre check
  static preCheckConfig(routeConfigs) {
    // call this function when server starts

    // check constraint length is 2
    // check allowType is valid
    // check dataType is valid

  }

  static validateAll(Map params, Map configs, String api) {
    configs.forEach((key, constraint) {
      String allowType = constraint.substring(0, 1);
      String dataType = constraint.substring(1);

      ILog.info('allowType: $allowType , dataType: $dataType .');

      if (allowType == ALLOW_NONE) {
        if (params.containsKey(key)) {
          validateEach(params[key], false, dataType, api, key);
          return;
        }
        return;
      }

      if (allowType == ALLOW_EMPTY) {
        if (!params.containsKey(key)) throw new IRouteServerException(41001, [api, key]);

        validateEach(params[key], true, dataType, api, key);
        return;
      }

      if (allowType == REQUIRED) {
        if (!params.containsKey(key)) throw new IRouteServerException(41002, [api, key]);

        validateEach(params[key], false, dataType, api, key);
        return;
      }

    });

  }

  static validateEach(value, bool allowEmpty, String dataType, String api, String key) {
    switch (dataType) {
      case STRING:
        if (value is! String) throw new IRouteServerException(41003, [api, key, 'String', value.runtimeType, value]);
        if (!allowEmpty && value.length == 0) throw new IRouteServerException(41004, [api, key, 'String']);
        break;
      case INT:
        if (value is! int) throw new IRouteServerException(41003, [api, key, 'Number', value.runtimeType, value]);
        break;
      case UNSIGNED_NUMBER:
        if (value is! int || (value is int && value < 0)) {
          throw new IRouteServerException(41003, [api, key, 'Unsigned Number', value.runtimeType, value]);
        }
        break;
      case DOUBLE:
        if (value is! double) throw new IRouteServerException(41003, [api, key, 'Double', value.runtimeType, value]);
        break;
      case MAP:
        if (value is! Map) throw new IRouteServerException(41003, [api, key, 'Map', value.runtimeType, value]);
        if (!allowEmpty && value.length == 0) throw new IRouteServerException(41004, [api, key, 'Map']);
        break;
      case LIST:
        if (value is! List) throw new IRouteServerException(41003, [api, key, 'List', value.runtimeType, value]);
        if (!allowEmpty && value.length == 0) throw new IRouteServerException(41004, [api, key, 'List']);
        break;
      case JSON:
        if (value is! Map && value is! List) throw new IRouteServerException(41003, [api, key, 'Json', value.runtimeType, value]);
        if (!allowEmpty && value.length == 0) throw new IRouteServerException(41004, [api, key, 'Json']);
        break;
      case BOOL:
        if (value is! bool) throw new IRouteServerException(41003, [api, key, 'Boolean', value.runtimeType, value]);
        break;
    }
  }
}
