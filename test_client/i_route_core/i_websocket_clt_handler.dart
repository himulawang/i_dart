part of lib_test_route;

class IWebSocketClientHandler {
  String _url;
  int _retryDuration;

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

  onMessage(data) {
    try {
      Map json = JSON.decode(data);
    } catch (e) {
      throw new IRouteClientException(50001);
    }

    if (json is! Map ||
        !json.containsKey('a') ||
        !json.containsKey('r') ||
        !json.containsKey('d')
    ) {
      throw new IRouteClientException(50002);
    }

    var api = json['a'];
    var data = json['d'];
    var resultCode = json['r'];

    if (api is! String || !clientRoute.containsKey(api)) {
      throw new IRouteClientException(50003, [api]);
    }

    if (json['r'] != 0) {
      // TODO exception handler
    }

    if (data is! Map) throw new IRouteClientException(50004);

    // invoke handler
    clientRoute[api]['handler'](this, api, data);
  }

  void send(String api, Map reqParam) {
    var req = {
        "a": api,
        "p": reqParam,
    };

    ws.send(JSON.encode(req));
  }
}
