part of lib_test_route;

class TestRouteLogic {
  static echo(WebSocket ws, String api, Map params) {
    print('Message received: ${JSON.encode(params)}');
  }

  static onUnknown(WebSocket ws, String api, Map params) {
    print('Message received: ${JSON.encode(params)}');
  }
}