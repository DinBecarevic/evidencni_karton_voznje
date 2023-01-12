import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1; //rabimo določit verzijo
  static final String _tableName="tasks"; //ime tabele

  static Future<void> initDb() async { //funkcija za inicializacijo baze
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "tasks.db"; //pot do baze
      _db = await openDatabase(
          _path,
          version: _version,
          onCreate:(db, version) {
            print("creating a new one");
            return db.execute( //izvedemo sql ukaz
                "CREATE TABLE $_tableName ("
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                    "title STRING, note TEXT, date STRING, "
                    "startTime STRING, endTime STRING, "
                    "remind INTEGER, repeat STRING, "
                    "color INTEGER,"
                    "isCompleted INTEGER)",
            );
          }); //če baze ni, jo ustvari
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async { //funkcija za vstavljanje podatkov v tabelo
    print("insert funkcija poklicana");
    return await _db?.insert(_tableName, task!.toJson())??1; //vstavimo podatke v tabelo
    //zgoraj prvo pogledamo če je databaza null ali ne
    //če je null vrne 1, če ni null pa vstavi podatke
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query funkcija poklicana");
    return await _db!.query(_tableName); //vrne vse podatke iz tabele
  }

  static delete(Task task) async{
    return await _db!.delete(_tableName, where: "id = ?", whereArgs: [task.id]); //where column = ? in gledamu še Args (argumente)
    //ko se delete izvrši vrne int
  }

  static update(int id) async { //funkcija za update (da lahko Uro označimo kot končano)
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [1, id]);
  }
}