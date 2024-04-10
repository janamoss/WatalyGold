import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/models/Result_ana.dart';

class Result_DB {
  final tablename = "result";

  Future<void> createtable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tablename (
      result_id INTEGER PRIMARY KEY AUTOINCREMENT,
      image_id INTEGER NOT NULL,
      collection_id INTEGER NOT NULL,
      another_note TEXT NOT NULL,
      quality TEXT NOT NULL,
      lenght INTEGER NOT NULL,
      width INTEGER NOT NULL,
      weight INTEGER NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      deleted_at DATETIME
    );
    """);
  }

  Future<int> create({required String user_ipaddress}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename (user_ipaddress,created_at) VALUES (?,?)''',
      [user_ipaddress, DateTime.now().microsecondsSinceEpoch],
    );
  }

  Future<List<Result>> fetchAll() async {
    final database = await DatabaseService().database;
    final results = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return results.map((result) => Result.fromSqfliteDatabase(result)).toList();
  }
}