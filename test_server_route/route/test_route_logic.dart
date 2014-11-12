part of lib_test_server_route;

class TestRouteLogic {
  TestRouteLogic() {
  }

  static createGroup(WebSocket ws, String api, Map params) {
    ws.add(JSON.encode({"echo": "$api done."}));
  }

  static echo(WebSocket ws, String api, Map params) {
    ws.add(JSON.encode({"echo": "$api done."}));
  }
}
