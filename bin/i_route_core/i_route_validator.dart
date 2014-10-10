class IRouteValidator {
  static const ALLOW_NONE = 'n';
  static const ALLOW_EMPTY = 'e';
  static const REQUIRED = 'r';

  static const NUMBER = 'n';
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
          validateEach(params[key], allowType, dataType, api, key);
          return;
        }
        return;
      }

      if (allowType == ALLOW_EMPTY) {
        if (!params.containsKey(key)) throw new IRouteException(30001, [api, key]);

        var value = params[key];
        if (value is String && value.length == 0) return;
        if ((value is List || value is Map) && value.length == 0) return;

        validateEach(params[key], allowType, dataType, api, key);
        return;
      }

      if (allowType == REQUIRED) {
        if (!params.containsKey(key)) throw new IRouteException(30002, [api, key]);

        validateEach(params[key], allowType, dataType, api, key);
        return;
      }

    });

  }

  static validateEach(value, String allowType, String dataType, String api, String key) {
    switch (dataType) {
      case STRING:
        if (value is! String) throw new IRouteException(30003, [api, key, 'String', value.runtimeType]);
        if (value.length == 0) throw new IRouteException(30004, [api, key, 'String']);
        break;
      case NUMBER:
        if (value is! num) throw new IRouteException(30003, [api, key, 'Number', value.runtimeType]);
        break;
      case UNSIGNED_NUMBER:
        if (value is! num || (value is num && value < 0)) {
          throw new IRouteException(30003, [api, key, 'Unsigned Number', value.runtimeType]);
        }
        break;
      case DOUBLE:
        if (value is! double) throw new IRouteException(30003, [api, key, 'Double', value.runtimeType]);
        break;
      case MAP:
        if (value is! Map) throw new IRouteException(30003, [api, key, 'Map', value.runtimeType]);
        if (value.length == 0) throw new IRouteException(30004, [api, key, 'Map']);
        break;
      case LIST:
        if (value is! List) throw new IRouteException(30003, [api, key, 'List', value.runtimeType]);
        if (value.length == 0) throw new IRouteException(30004, [api, key, 'List']);
        break;
      case JSON:
        if (value is! Map && value is! List) throw new IRouteException(30003, [api, key, 'Json', value.runtimeType]);
        if (value.length == 0) throw new IRouteException(30004, [api, key, 'Json']);
        break;
      case BOOL:
        if (value is! bool) throw new IRouteException(30003, [api, key, 'Boolean']);
        break;
    }
  }
}
