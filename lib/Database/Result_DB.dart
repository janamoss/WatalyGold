import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/models/Result_ana.dart';

class Result_DB {
  final tablename = "result";

  Future<void> createtable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tablename (
      result_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      collection_id INTEGER,
      another_note TEXT NOT NULL,
      quality TEXT NOT NULL,
      lenght INTEGER NOT NULL,
      width INTEGER NOT NULL,
      weight INTEGER NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      deleted_at DATETIME,
      FOREIGN KEY (user_id) REFERENCES user(user_id),
      FOREIGN KEY (collection_id) REFERENCES collection(collection_id)
      ON DELETE SET NULL
    );
    """);
  }

  Future<int> create(
      {required int user_id,
      required String another_note,
      required String quality,
      required double lenght,
      required double width,
      required double weight}) async {
    final database = await DatabaseService().database;
    print(await DatabaseService().database);
    // print("ทำงานอยู่จ้า");
    // print(user_id);
    // print(another_note);
    // print(quality);
    // print(lenght);
    return await database.rawInsert(
      '''INSERT INTO $tablename (user_id,another_note,quality,lenght,width,weight,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?)''',
      [
        user_id,
        another_note,
        quality,
        lenght,
        width,
        weight,
        DateTime.now().microsecondsSinceEpoch,
        DateTime.now().microsecondsSinceEpoch,
      ],
    );
    // return
    // print(id);
    //  id;
  }

  Future<List<Result>> fetchAll() async {
    final database = await DatabaseService().database;
    final results = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return results.map((result) => Result.fromSqfliteDatabase(result)).toList();
  }

  Future<List<Result>> fetchResultinCol() async {
    final database = await DatabaseService().database;
    final results = await database.rawQuery(
        '''SELECT * FROM $tablename WHERE collection_id IS NULL ORDER BY COALESCE(updated_at,created_at)''');
    return results.map((result) => Result.fromSqfliteDatabase(result)).toList();
  }

  Future<Result> fetchsomeresult(int result_id) async {
    final database = await DatabaseService().database;
    final results = await database.rawQuery(
        '''SELECT * FROM $tablename WHERE result_id = ? ''', [result_id]);
    return Result.fromSqfliteDatabase(results.first);
  }

  Future<void> delete(int result_id) async {
    final database = await DatabaseService().database;
    await database.rawDelete(
        """DELETE FROM $tablename WHERE result_id = ? """, [result_id]);
  }

  Future<int> updatecollection(int collection_id, int result_id) async {
    final database = await DatabaseService().database;
    return await database.update(
      tablename,
      {
        'collection_id': collection_id != 0 ? collection_id : null
      }, // ตรวจสอบว่า collection_id ไม่ใช่ 0 ก่อนอัปเดต
      where: 'result_id = ?',
      whereArgs: [result_id],
    );
  }

  Future<List<Result>> fetchCountReinCol(int collection_id) async {
    final database = await DatabaseService().database;
    final results = await database.rawQuery(
        '''SELECT * FROM $tablename WHERE collection_id = ? ORDER BY COALESCE(updated_at,created_at)''',
        [collection_id]);
    return results.map((result) => Result.fromSqfliteDatabase(result)).toList();
  }
}
