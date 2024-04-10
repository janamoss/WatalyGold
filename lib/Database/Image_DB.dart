import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/models/Collection.dart';

class Image_DB {
  final tablename = "image";

  Future<void> createtable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tablename (
      image_id INTEGER PRIMARY KEY AUTOINCREMENT,
      result_id INTEGER NOT NULL,
      image_status TEXT NOT NULL,
      image_name TEXT NOT NULL,
      image_url TEXT NOT NULL,
      image_lenght INTEGER NOT NULL,
      image_width INTEGER NOT NULL,
      image_weight INTEGER NOT NULL,
      flaws_percent INTEGER NOT NULL,
      brown_spot INTEGER NOT NULL,
      color TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      deleted_at DATETIME,
      FOREIGN KEY (result_id) REFERENCES result(result_id)
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