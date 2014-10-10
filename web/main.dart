import "dart:convert";
import "dart:io";
import "package:stream/stream.dart";

void main() {
  new StreamServer(uriMapping: {
    "/about": about,
  }).start();
}

void about(HttpConnect connect) {
  Map info = {"name": 'ila'};
  connect.response//..headers.contentType = contentType['json']
  ..write(JSON.encode(info));
}