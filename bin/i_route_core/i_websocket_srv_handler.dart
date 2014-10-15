class IWebSocketServerHandler {
  List pool = [];

  onMessage(ws) {
    pool.add(ws);

    ILog.info('A client connected, Online User: ${getConcurrentUser()}.');

    ws.map((body) {
      if (body is String) return JSON.decode(body);
      throw new IRouteServerException(40001, [body.runtimeType]);
    })
    .listen((Map json) {

      // check valid framework request
      if (json is! Map ||
          !json.containsKey('a') ||
          !json.containsKey('p') ||
          !json.containsKey('mi')
      ) {
        // invalid request parameters
        var error = new IRouteServerException(40002, [JSON.encode(json)]);
        resError(ws, error, {});
        return;
      }

      var api = json['a'];
      var params = json['p'];
      var messageId = json['mi'];

      // check api & params type
      if (api is! String) {
        var error = new IRouteServerException(40003, [api]);
        resError(ws, error, json);
        return;
      }
      if (params is! Map) {
        var error = new IRouteServerException(40004, [api]);
        resError(ws, error, json);
        return;
      }

      // check api is valid
      if (!serverRoute.containsKey(api)) {
        var error = new IRouteServerException(40005, [api]);
        resError(ws, error, json);
        return;
      }

      ILog.info('API $api is called with params: ${JSON.encode(json)}.');

      // check params
      try {
        IRouteValidator.validateAll(params, serverRoute[api]['params'], api);
        serverRoute[api]['handler'](this, api, params, messageId);
      } catch (e) {
        return;
      }
    }, onError: (e) {
      resError(ws, e, {});
    }, onDone: () {
      pool.remove(ws);
      ILog.info('A client disconnected, Online User: ${getConcurrentUser()}.');
    });

  }

  resError(WebSocket ws, IException error, Map json) {
    var api = json.containsKey('a') ? json['a'] : 'unknown';
    var messageId = json.containsKey('mi') ? json['mi'] : -1;

    var res = {
      'a': api,
      'r': error.code,
      'd': error.message,
      'mi': messageId,
    };
    ws.add(JSON.encode(res));
  }

  res(WebSocket ws, Map json, Map resParam) {
    var api = json['a'];
    var messageId = json['mi'];

    var res = {
      'a': 'on${IString.makeUpperFirstLetter(api)}',
      'r': 0,
      'd': resParam,
      'mi': messageId,
    };
    ws.add(JSON.encode(res));
  }

  getConcurrentUser() => pool.length;
}
