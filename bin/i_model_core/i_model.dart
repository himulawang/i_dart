/**
 * This script is generated by I Maker
 * DO NOT MODIFY!
 */

abstract class IModel {
  String getAbb();
  String getName();
  String getListName();
  String getPKName();
  String getColumnCount();

  Map getColumns();
  Map getMapAbb();
  Map getMapFull();

  void setExist([bool exist = true]);
  bool isExist();

  void setPK(pk);
  getPK();

  bool isUpdated();
  void setUpdatedList(bool flag);

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
  Map toFull([bool filterOn = false]);
  Map toAbb([bool filterOn = false]);

  void fromList(List data, [bool changeUpdatedList = false]);
  void fromFull(Map data, [bool changeUpdatedList = false]);
  void fromAbb(Map data, [bool changeUpdatedList = false]);
}