/* Part of I Framework Model library
 * 
 */

part of lib_i_model;

abstract class IModel {
  void setPK(pk);
  getPK();

  bool isUpdated();

  List toAddFixedList([bool filterOn = false]);
  List toAddList([bool filterOn = false]);
  Map toAddFull([bool filterOn = false]);
  Map toAddAbb([bool filterOn = false]);

  List toSetFixedList([bool filterOn = false]);
  List toSetList([bool filterOn = false]);
  Map toSetFull([bool filterOn = false]);
  Map toSetAbb([bool filterOn = false]);

  List toFixedList([bool filterOn = false]);
  List toList([bool filterOn = false]);
  Map toArray([bool filterOn = false]);
  Map toAbb([bool filterOn = false]);

  void markForAdd([bool flag = true]);
  void markForDel([bool flag = true]);
}