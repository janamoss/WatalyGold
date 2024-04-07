import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/models/User.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _iniialize();
    return _database!;
  }

  Future<String> get fullpath async {
    const name = "watalygold.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _iniialize() async {
    final path = await fullpath;
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version) async =>
      await User_db().createtable(database);
}
