/* Part of I Framework Model library
 * 
 */

part of lib_i_model;

class IPK {
  int _pk;
  bool _updated = false;
  bool _delSync = false;
  
  void set(int pk) {
    _pk = pk;
    _updated = true;        
  }
  
  int get() {
    return _pk;
  }
  
  int incr([int val = 1]) {
    _pk += val;
    _updated = true;
    return _pk;
  }
  
  void reset() {
    set(0);
  }
  
  void markDelSync({bool tag: true}) {
    _delSync = tag;
  }
}