import 'package:path/path.dart';
import 'package:project/data/todo.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "todo.db";
  static final _databaseVersion = 1;
  static final todoTable = "todo";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // 데이터 테이블 생성
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $todoTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date INTEGER DEFAULT 0,
        title String,
        memo String,
        color INTEGER,
        category String,
        done INTEGER DEFAULT 0
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  // insert, update, tododata
  Future<int> modifyTodo(Todo todo) async {
    Database db = await instance.database;

    if(todo.id == null) {
      Map<String, dynamic> row = {
        "title": todo.title,
        "memo": todo.memo,
        "category": todo.category,
        "color": todo.color,
        "done": todo.done,
        "date": todo.date,
      };
      return await db.insert(todoTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": todo.title,
        "memo": todo.memo,
        "category": todo.category,
        "color": todo.color,
        "done": todo.done,
        "date": todo.date,
      };
      return await db.update(todoTable, row, where: "id = ?", whereArgs: [todo.id]);
    }
  }

  // all list
  Future <List<Todo>> getAllTodo() async {
    Database db = await instance.database;

    List<Todo> todos = [];

    var queries = await db.query(todoTable);
    for (var q in queries) {
      todos.add(Todo(
        id: q["id"],
        title: q["title"],
        memo: q["memo"],
        category: q["category"],
        color: q["color"],
        done: q["done"],
        date: q["date"],
      ));
    }

    return todos;
  }

  // get list by date
  Future <List<Todo>> getTodoByDate(int date) async {
    Database db = await instance.database;

    List<Todo> todos = [];

    var queries = await db.query(todoTable, where: "date = ?", whereArgs: [date]);
    for (var q in queries) {
      todos.add(Todo(
        id: q["id"],
        title: q["title"],
        memo: q["memo"],
        category: q["category"],
        color: q["color"],
        done: q["done"],
        date: q["date"],
      ));
    }

    return todos;
  }
}