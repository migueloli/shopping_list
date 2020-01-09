import 'package:rxdart/rxdart.dart';
import 'package:shopping_list/models/item/item.dart';
import 'package:shopping_list/models/item/item_dao.dart';

enum ProcessStatus {
  IDLE,
  LOAD,
  ERROR
}

class ShoppingList {

  final ItemDao _dao = ItemDao();
  List<Item> _pendList = List<Item>();
  List<Item> _compList = List<Item>();

  final BehaviorSubject<List<Item>> _pendController = BehaviorSubject();
  Stream<List<Item>> get outPend => _pendController.stream;

  final BehaviorSubject<ProcessStatus> _stPendController = BehaviorSubject.seeded(ProcessStatus.IDLE);
  Stream<ProcessStatus> get outStPend => _stPendController.stream;

  final BehaviorSubject<List<Item>> _compController = BehaviorSubject();
  Stream<List<Item>> get outComp => _compController.stream;

  final BehaviorSubject<ProcessStatus> _stCompController = BehaviorSubject.seeded(ProcessStatus.IDLE);
  Stream<ProcessStatus> get outStComp => _stCompController.stream;

  ShoppingList() {
    _pendController.add(_pendList);
    _compController.add(_compList);
  }

  Future addItem(Item item) async {
    item = await _dao.insert(item);

    if(item.id > 0){
      if(item.status == 0) {
        _pendList.add(item);
        _pendController.add(_pendList);
      } else if(item.status == 1){
        _compList.add(item);
        _compController.add(_compList);
      }
    }
  }

  Future removeItem(Item item) async {
    var result = await _dao.delete(item.id);
    if(result > 0) {
      if(item.status == 0){
        _pendList.remove(item);
        _pendController.add(_pendList);
      } else if(item.status == 1){
        _compList.remove(item);
        _compController.add(_compList);
      }
    }
  }

  Future updateItem(Item item) async {
    int posPend = _pendList.indexOf(item);
    if(posPend > -1) {
      _pendList.removeAt(posPend);
      _pendController.add(_pendList);
    }
    int posRead = _compList.indexOf(item);
    if(posRead > -1) {
      _compList.removeAt(posRead);
      _compController.add(_compList);
    }

    await _dao.update(item);

    if(item.status == 0){
      if(posPend > -1) {
        _pendList.insert(posPend, item);
      }else{
        _pendList.add(item);
      }
      _pendController.add(_pendList);
    } else if(item.status == 1){
      if(posRead > -1) {
        _compList.insert(posRead, item);
      } else {
        _compList.add(item);
      }
      _compController.add(_compList);
    }
  }

  Future getPendingItens() async {
    try {
      _pendList.clear();
      (await _dao.select(st: 0)).forEach((map) {
        _pendList.add(Item.fromMap(map));
      });
    } catch(e) {
      print(e.toString());
    } finally {
      _pendController.add(_pendList);
    }
  }

  Future getCompletedItens() async {
    try {
      _compList.clear();
      (await _dao.select(st: 1)).forEach((map) {
        _compList.add(Item.fromMap(map));
      });
    } catch(e) {
      print(e.toString());
    } finally {
      _compController.add(_compList);
    }
  }

  void dispose() {
    _pendController.close();
    _stPendController.close();

    _compController.close();
    _stCompController.close();
  }

}