import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Database/Image_DB.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/models/User.dart';

class DatabaseService {
  Database? _database;
  bool? _databaseExists;

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
    _databaseExists = await databaseExists(path);
    if (!_databaseExists!) {
      var database = await openDatabase(path,
          version: 1, onCreate: create, singleInstance: true);
      return database;
    } else {
      var database = await openDatabase(path, singleInstance: true);
      return database;
    }
  }

  Future<bool> isDatabaseExists() async {
    final path = await fullpath;
    return await databaseExists(path);
  }

  Future<void> create(Database database, int version) async {
    await User_db().createtable(database);
    await Collection_DB().createtable(database);
    await Result_DB().createtable(database);
    await Image_DB().createtable(database);
  }
}
