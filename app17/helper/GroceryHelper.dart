import 'model/Grocery.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GroceryHelper {
  static final String tableName = "groceries";

  static final GroceryHelper _groceryHelper = GroceryHelper._internal();
  Database _db;

  factory GroceryHelper() {
    return _groceryHelper;
  }

  GroceryHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title VARCHAR, "
        "qtd INTEGER, "
        "date DATETIME)";
    await db.execute(sql);
  }

  initDb() async {
    final dbPath = await getDatabasesPath();
    final dbLocal = join(dbPath, "bd_grocery.db");

    var db = await openDatabase(dbLocal, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveItem(Grocery grocery) async {
    var database = await db;
    int resultado = await database.insert(tableName, grocery.toMap());
    return resultado;
  }

  recoverGroceryList() async {
    var database = await db;
    String sql = "SELECT * FROM $tableName ORDER BY date DESC ";
    List anotacoes = await database.rawQuery(sql);
    return anotacoes;
  }

  Future<int> updateItem(Grocery grocery) async {
    var database = await db;
    return await database.update(tableName, grocery.toMap(),
        where: "id = ?", whereArgs: [grocery.id]);
  }

  Future<int> removeItem(int id) async {
    var database = await db;
    return await database.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}