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
    // ค้นหาว่ามี collection_name ที่ซ้ำหรือไม่
    final existingCollection = await database.rawQuery(
      '''SELECT * FROM $tablename WHERE collection_name = ? AND user_id = ?''',
      [collection_name, user_id],
    );
    // ถ้าเจอ collection_name ที่ซ้ำแล้ว ให้ return 0
    if (existingCollection.isNotEmpty) {
      return 0;
    }
    // ถ้าไม่เจอ collection_name ที่ซ้ำ ให้ทำการเพิ่มข้อมูลใหม่
    return await database.rawInsert(
      '''INSERT INTO $tablename (user_id, collection_name, collection_image, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?)''',
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

    await database.transaction((txn) async {
      await txn.rawDelete("""DELETE FROM $tablename WHERE collection_id = ?""",
          [collection_id]);

      await txn.rawUpdate(
          """UPDATE result SET collection_id = NULL WHERE collection_id = ?""",
          [collection_id]);
    });
  }

  Future<int> updateCollection(
      {required int collection_id,
      required String collection_name,
      required String collection_image,
      required int user_id}) async {
    final database = await DatabaseService().database;

    final existingCollection = await database.rawQuery(
      '''SELECT * FROM $tablename WHERE collection_name = ? AND user_id = ?''',
      [collection_name, user_id],
    );
    // ถ้าเจอ collection_name ที่ซ้ำแล้ว ให้ return 0
    if (existingCollection.isNotEmpty) {
      return 0;
    }

    return await database.update(
      tablename,
      {
        'collection_name': collection_name,
        'collection_image': collection_image
      }, // ตรวจสอบว่า collection_id ไม่ใช่ 0 ก่อนอัปเดต
      where: 'collection_id = ?',
      whereArgs: [collection_id],
    );
  }

  Future<int> updatecolletiononlyImage({
    required int collection_id,
    required String collection_name,
    required String collection_image,
    required int user_id,
  }) async {
    final database = await DatabaseService().database;

    return await database.update(
      tablename,
      {
        'collection_image': collection_image,
      },
      where: 'collection_id = ?',
      whereArgs: [collection_id],
    );
  }
}
