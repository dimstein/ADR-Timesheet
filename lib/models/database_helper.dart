import 'dart:async';

import 'package:adr_timesheet/models/timesheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'test.db'; //'MyTimesheet.db';
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

  Future<int> insertTime(Timesheet timesheet) async {
    final db = await instance.database;
    return db.insert(table, timesheet.toMap());
  }

  Future<int> updateTime(Timesheet timesheet) async {
    final db = await instance.database;
    return db.update(table, timesheet.toMap(),
        where: '$columnId = ?', whereArgs: [timesheet.id]);
  }

  Future<int> checkDate(Timesheet timesheet) async {
    final db = await instance.database;
    final idCheck =
        await db.query(table, where: 'date = ?', whereArgs: [timesheet.date]);
    return idCheck.isNotEmpty ? idCheck.first['_id'] : null;
  }

// All of the rows are returned as a list of maps, where each map is
// a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future<List<Timesheet>> grabAllTime() async{
    final db = await instance.database;
    final maps = await db.query(table, where: '_id > ?', whereArgs: [0]);
    return List.generate(
        maps.length,
        (i) => Timesheet(
            id: maps[i]['_id'],
            date: maps[i]['date'],
            hours: maps[i]['hours'],
            minutes: maps[i]['minutes']));
  }

  // Stream<List<dynamic>> streamAllTime() {
  //   final streamTime = grabAllTime();
  //   final controller = StreamController<List<Timesheet>>.broadcast();
  //   Stream<List<Timesheet>> _inTimesheet => controller.sink;
  //   controller.stream.listen((event) { })
  //   return stream;
  //
  // }




  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  void submitted(Timesheet timesheet, int uref){
      checkDate(timesheet).then((_uref) => _uref==null ?
    {
      insertTime(Timesheet(id: uref, date: timesheet.date, hours: timesheet.hours, minutes: timesheet.minutes))
      // not matching id in database so new id
    } :
    {
      updateTime(Timesheet(id: _uref, date: timesheet.date, hours: timesheet.hours, minutes: timesheet.minutes))
      // match id found so id is return value from checkDate()
    });



  }

  Future<int> grabRowsCount() async{
    return grabAllTime().then((timesheet) => timesheet.length);
  }

  Future<int> grabRowID(int query) async {
    return grabAllTime().then(
        (timesheet) => timesheet.indexWhere((element) => element.id == query));
  }
}
