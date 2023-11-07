import 'package:app_15_lista_de_tarefas/model/Tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TasksHelper {
  static final String tableName = "tasks";

  static final TasksHelper _tasksHelper = TasksHelper._internal();
  Database _db;

  factory TasksHelper() {
    return _tasksHelper;
  }

  TasksHelper._internal() {}

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
        "date DATETIME)";
    await db.execute(sql);
  }

  initDb() async {
    final dbPath = await getDatabasesPath();
    final dbLocal = join(dbPath, "bd_tasks.db");

    var db = await openDatabase(dbLocal, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveTask(Tasks task) async {
    var database = await db;
    int resultado = await database.insert(tableName, task.toMap());
    return resultado;
  }

  recoverTasks() async {
    var database = await db;
    String sql = "SELECT * FROM $tableName ORDER BY date DESC ";
    List anotacoes = await database.rawQuery(sql);
    return anotacoes;
  }

  Future<int> updateTask(Tasks task) async {
    var database = await db;
    return await database
        .update(tableName, task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

  Future<int> removeTask(int id) async {
    var database = await db;
    return await database.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}