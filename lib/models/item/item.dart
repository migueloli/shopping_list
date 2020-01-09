import 'package:shopping_list/models/item/item_dao.dart';

class Item {

  int id = 0;
  String description = "";
  int quantity;
  double value;
  int _dateCreated = 0;
  int _dateCompleted = 0;
  String barcode = "";
  String location = "";
  int status = 0;

  Item({this.id = 0, this.description, this.quantity, this.value,
    this.barcode, this.location, this.status = 0}) {
    if(this._dateCreated == 0) {
      this._dateCreated = DateTime.now().millisecondsSinceEpoch;
    }

    if(status > 0) {
      setCompletion();
    }
  }

  Item.fromMap(Map<String, dynamic> map) {
    id = map[ItemDao.id];
    description = map[ItemDao.description];
    quantity = map[ItemDao.quantity];
    value = map[ItemDao.value];
    _dateCreated = map[ItemDao.dateCreated];
    _dateCompleted = map[ItemDao.dateCompleted];
    barcode = map[ItemDao.barcode];
    location = map[ItemDao.location];
    status = map[ItemDao.status];
  }

  void setCompletion() {
    _dateCompleted = DateTime.now().millisecondsSinceEpoch;
    status = 1;
  }

  void cancelCompletion() {
    _dateCompleted = 0;
    status = 0;
  }

  String getTitle() {
    var title = description;
    if(quantity != null && quantity > 0){
      title += " X $quantity";
    }
    return title;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      ItemDao.description : description,
      ItemDao.quantity : quantity,
      ItemDao.value : value,
      ItemDao.dateCreated : _dateCreated,
      ItemDao.dateCompleted : _dateCompleted,
      ItemDao.barcode : barcode,
      ItemDao.location : location,
      ItemDao.status : status,
    };

    if(id > 0){
      map[ItemDao.id] = id;
    }

    return map;
  }

}