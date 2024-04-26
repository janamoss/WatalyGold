import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/models/Collection.dart';

class Collection_DB {
  final tablename = "collection";

  Future<void> createtable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tablename (
      collection_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      collection_name TEXT NOT NULL,
      collection_image TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      deleted_at DATETIME,
      FOREIGN KEY (user_id) REFERENCES user(user_id)
    );
    """);
  }

  Future<int> create(
      {required int user_id,
      required String collection_name,
      required String collection_image}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename (user_id,collection_name,collection_image,created_at,updated_at) VALUES (?,?,?,?,?)''',
      [
        user_id,
        collection_name,
        collection_image,
        DateTime.now().microsecondsSinceEpoch,
        DateTime.now().microsecondsSinceEpoch
      ],
    );
  }

  Future<List<Collection>> fetchAll() async {
    final database = await DatabaseService().database;
    final collections = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return collections
        .map((collection) => Collection.fromSqfliteDatabase(collection))
        .toList();
  }

  Future<void> delete(int collection_id) async {
    final database = await DatabaseService().database;
    await database.rawDelete(
      """DELETE FROM $tablename WHERE collection_id = ? """,[collection_id]
    );
  }
}
