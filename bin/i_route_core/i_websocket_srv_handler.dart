class IWebSocketServerHandler {
  static handle(WebSocket ws) {
    ws.map((body) => JSON.decode(body))
    .listen((Map json) {

      // check valid framework request
      if (json is! Map || !json.containsKey('a') || !json.containsKey('p')) {
        // invalid request parameters
        new IRouteServerException(30102, [JSON.encode(json)]);
        return;
      }

      var api = json['a'];
      var params = json['p'];

      // check api & params type
      if (api is! String) {
        new IRouteServerException(30103, [api]);
        return;
      }
      if (params is! Map) {
        new IRouteServerException(30104, [api]);
        return;
      }

      // check api is valid
      if (!serverRoute.containsKey(api)) {
        new IRouteServerException(30105, [api]);
        return;
      }

      ILog.info('API $api is called with params: ${JSON.encode(json)}.');

      // check params
      try {
        IRouteValidator.validateAll(params, serverRoute[api]['params'], api);
        serverRoute[api]['handler'](ws, api, params);
      } catch (e) {
        return;
      }
    }, onError: (error) {
      print('bad WS request');
      print(error);
      new IRouteServerException(30101);
    });
  }
}
