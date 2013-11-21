/* Part of I Framework Model library
 * 
 */

part of lib_i_model;

abstract class IModel {
  void setPK(pk);
  getPK();

  bool isUpdated();
  
  List toAddList([bool filterOn = false]);
  Map toAddFull([bool filterOn = false]);
  Map toAddAbb([bool filterOn = false]);
  
  List toUpdateList([bool filterOn = false]);
  Map toUpdateFull([bool filterOn = false]);
  Map toUpdateAbb([bool filterOn = false]);
  
  List toList([bool filterOn = false]);
  Map toArray([bool filterOn = false]);
  Map toAbb([bool filterOn = false]);

  void markForAdd([bool flag = true]);
  void markForDel([bool flag = true]);
}