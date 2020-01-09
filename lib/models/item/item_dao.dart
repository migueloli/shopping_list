import 'package:shopping_list/models/bd_helper.dart';
import 'package:shopping_list/models/item/item.dart';

class ItemDao {

  static final String table = "item";
  static final String id = "id";
  static final String description = "description";
  static final String quantity = "quantity";
  static final String value = "value";
  static final String dateCreated = "dateCreated";
  static final String dateCompleted = "dateCompleted";
  static final String barcode = "barcode";
  static final String location = "location";
  static final String status = "status";

  static String getCreateSQL() => "CREATE TABLE $table ("
      "$id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$description TEXT, "
      "$quantity INTEGER, "
      "$value REAL, "
      "$dateCreated INTEGER, "
      "$dateCompleted INTEGER, "
      "$barcode TEXT, "
      "$location TEXT, "
      "$status INTEGER "
      ");";

  final BDHelper _helper;

  ItemDao() : _helper = BDHelper.internal();

  Future<Item> insert(Item item) async {
    var db = await _helper.db;
    item.id = await db.insert(table, item.toMap());

    return item;
  }

  Future<int> delete(int itemId) async {
    var db = await _helper.db;
    return await db.delete(table, where: "$id = ?", whereArgs: [itemId]);
  }

  Future<int> update(Item item) async {
    var db = await _helper.db;
    return await db.update(
        table,
        item.toMap(),
        where: "$id = ?",
        whereArgs: [item.id]
    );
  }

  Future<List<Map<String, dynamic>>> select({int st = -1}) async {
    var db = await _helper.db;
    String where;
    List<String> args;
    if(st >= 0){
      where = "$status = ?";
      args= [st.toString()];
    }

    return await db.query(table, where: where, whereArgs: args);
  }
  
}