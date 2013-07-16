/**
 * This script is generated by I Framework IMaker.dart
 * DO NOT MODIFY!
 */

part of lib_i_model;

class ConnectionBase extends IModel {
  ConnectionBase(args) : super(){
    _pk = 0;
    _columns = [{"i":0,"full":"id","abb":"i","toAdd":true,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false},{"i":1,"full":"name","abb":"n","toAdd":false,"toUpdate":true,"toAbb":false,"toArray":false,"toList":false},{"i":2,"full":"host","abb":"h","toAdd":false,"toUpdate":false,"toAbb":true,"toArray":false,"toList":false},{"i":3,"full":"toAddFilter","abb":"taf","toAdd":false,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false},{"i":4,"full":"toAddFilt","abb":"taf1","toAdd":false,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false}];
    _mapAbb = {"i":{"i":0,"full":"id","abb":"i","toAdd":true,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false},"n":{"i":1,"full":"name","abb":"n","toAdd":false,"toUpdate":true,"toAbb":false,"toArray":false,"toList":false},"h":{"i":2,"full":"host","abb":"h","toAdd":false,"toUpdate":false,"toAbb":true,"toArray":false,"toList":false},"taf":{"i":3,"full":"toAddFilter","abb":"taf","toAdd":false,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false},"taf1":{"i":4,"full":"toAddFilt","abb":"taf1","toAdd":false,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false}};
    _mapFull = {"id":{"i":0,"full":"id","abb":"i","toAdd":true,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false},"name":{"i":1,"full":"name","abb":"n","toAdd":false,"toUpdate":true,"toAbb":false,"toArray":false,"toList":false},"host":{"i":2,"full":"host","abb":"h","toAdd":false,"toUpdate":false,"toAbb":true,"toArray":false,"toList":false},"toAddFilter":{"i":3,"full":"toAddFilter","abb":"taf","toAdd":false,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false},"toAddFilt":{"i":4,"full":"toAddFilt","abb":"taf1","toAdd":false,"toUpdate":false,"toAbb":false,"toArray":false,"toList":false}};

    _args = args == null ? new List.filled(5, null) : args;
    _length = 5;
    _updatedList = new List.filled(5, false);
  }

  void set id(v) {
    if (_args[0] == v) return;
    _args[0] = v;
    _updatedList[0] = true;
  }
  get id => _args[0];

  void set name(v) {
    if (_args[1] == v) return;
    _args[1] = v;
    _updatedList[1] = true;
  }
  get name => _args[1];

  void set host(v) {
    if (_args[2] == v) return;
    _args[2] = v;
    _updatedList[2] = true;
  }
  get host => _args[2];

  void set toAddFilter(v) {
    if (_args[3] == v) return;
    _args[3] = v;
    _updatedList[3] = true;
  }
  get toAddFilter => _args[3];

  void set toAddFilt(v) {
    if (_args[4] == v) return;
    _args[4] = v;
    _updatedList[4] = true;
  }
  get toAddFilt => _args[4];
}