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
      ON DELETE CASCADE
      ON UPDATE NO ACTION
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

  Future<List<Collection>> fetchAll() async {
    final database = await DatabaseService().database;
    final collections = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return collections.map((collection) => Collection.fromSqfliteDatabase(collection)).toList();
  }
}