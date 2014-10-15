part of lib_test_route;

class IWebSocketClientHandler {
  String _url;
  int _retryDuration;
  Map<Completer> _session;

  // async
  int _messageId = 0;

  WebSocket ws;

  connect(String url, [int retryDuration = 3000]) {
    _url = url;
    _retryDuration = retryDuration;

    ws = new WebSocket(url);

    var completer = new Completer();

    ws.onOpen.first.then((_) {
      onConnected();

      ws.onClose.first.then((_) {
        print('Connection disconnected.');
        onDisconnected();
      });

      completer.complete();
    });

    ws.onError.first.then((_) {
      print('Failed to connect.');
      onDisconnected();
    });

    return completer.future;
  }

  onConnected() {
    ws.onMessage.listen((e) {
      onMessage(e.data);
    });
  }

  onDisconnected() {
    new Timer(new Duration(milliseconds: _retryDuration), () {
      connect(_url, _retryDuration);
    });
  }

  onMessage(body) {
    ILog.info('Message received: $body');

    Map json;
    try {
      json = JSON.decode(body);
    } catch (e) {
      throw new IRouteClientException(50001, [body]);
    }

    if (json is! Map ||
        !json.containsKey('a') ||
        !json.containsKey('r') ||
        !json.containsKey('d')
    )  throw new IRouteClientException(50002, [body]);

    var api = json['a'];
    var data = json['d'];
    var resultCode = json['r'];

    if (resultCode != 0) {
      throw new IRouteClientException(50003, [api, resultCode, data]);
    }

    if (api is! String || !clientRoute.containsKey(api)) {
      throw new IRouteClientException(50004, [api]);
    }

    if (data is! Map) throw new IRouteClientException(50005);

    // invoke handler
    clientRoute[api]['handler'](this, api, data);
  }

  req(String api, Map reqParam) {
    var req = {
        'a': api,
        'p': reqParam,
    };

    ws.send(JSON.encode(req));

    var sessionId = uuid.v4();
    var completer = new Completer();
    _session[sessionId] = completer;
    return completer.future;
  }

  sendBlob(Blob b) {
    ws.sendBlob(b);
  }

  reqAsync(String api, Map reqParam) {
    var req = {
        'a': api,
        'p': reqParam,
        'mi': _messageId,
    };

    ws.send(JSON.encode(req));

    var completer = new Completer();
    _session[_messageId.toString()] = completer;
    ++_messageId;
    return completer.future;
  }

}
