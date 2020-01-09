import 'package:path/path.dart';
import 'package:shopping_list/models/item/item_dao.dart';
import 'package:sqflite/sqflite.dart';

class BDHelper {
  static const version = 1;
  static const String bdName = "shopping_list.db";
  static final BDHelper _instance = BDHelper.internal();

  factory BDHelper() => _instance;

  BDHelper.internal();

  Database _db;
  Future<Database> get db async {
    if(_db == null){
      _db = await initDb();
    }

    return _db;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, bdName);

    return await openDatabase(path, version: version, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  void _onCreate(Database db, int newerVersion) async {
    await db.execute(ItemDao.getCreateSQL());
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {}

  Future<Null> close() async {
    Database dbContact = await db;
    dbContact.close();
  }

}