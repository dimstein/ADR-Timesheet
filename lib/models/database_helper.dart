import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'MyDatabase.db';
  static final _databaseVersion = 1;

  static final table = 'my_table';

  static final columnId = '_id';
  static final columnDate = 'date';
  static final columnHours = 'hours';
  static final columnMinutes = 'minutes';

  //make a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//only have a single app-wide reference to database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

//this opens the database and creates if needed
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  //SQL code to create database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $table(
    $columnId INTEGER PRIMARY KEY,
    $columnDate TEXT NOT NULL,
    $columnHours INTEGER NOT NULL,
    $columnMinutes INTEGER NOT NULL
    )
    ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);
  }

// All of the rows are returned as a list of maps, where each map is
// a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async{
    final db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> queryRowCount() async {
    var db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table'));
    }
}
