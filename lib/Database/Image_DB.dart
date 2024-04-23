import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/models/Collection.dart';
import 'package:watalygold/models/Image.dart';

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

  Future<int> insertdata(
      {required int result_id,
      required String image_status,
      required String image_name,
      required String image_url,
      required double image_lenght,
      required double image_width,
      required double image_weight,
      required double flaws_percent,
      required double brown_spot,
      required String color}) async {
    final database = await DatabaseService().database;
    print(database);
    return await database.rawInsert(
      '''INSERT INTO $tablename (result_id,image_status,image_name,image_url,image_lenght,image_width,image_weight,flaws_percent,brown_spot,color,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)''',
      [
        result_id,
        image_status,
        image_name,
        image_url,
        image_lenght,
        image_width,
        image_weight,
        flaws_percent,
        brown_spot,
        color,
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

  Future<List<Images>> fetchImageinResult(int result_id) async {
    final database = await DatabaseService().database;
    print(database);
    final images = await database.query(
      tablename,
      where: 'result_id = ?',
      whereArgs: [result_id],
      orderBy: 'COALESCE(updated_at, created_at)',
    );
    return images.map((image) => Images.fromSqfliteDatabase(image)).toList();
  }
}
