import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/models/User.dart';

class User_db {
  final tablename = "user";

  Future<void> createtable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tablename (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_ipaddress TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      deleted_at DATETIME
    );
    """);
  }

  Future<User?> fetchByIpAddress(String ipAddress) async {
    final database = await DatabaseService().database;
    final users = await database.query(
      tablename,
      where: 'user_ipaddress = ?',
      whereArgs: [ipAddress],
      limit: 1,
    );
    if (users.isNotEmpty) {
      return User.fromSqfliteDatabase(users.first);
    }
    return null;
  }

  Future<int> create({required String user_ipaddress}) async {
    final existingUser = await fetchByIpAddress(user_ipaddress);
    if (existingUser != null) {
      // ถ้ามี IP อยู่แล้ว
      return 0;
    }
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename (user_ipaddress,created_at) VALUES (?,?)''',
      [user_ipaddress, DateTime.now().microsecondsSinceEpoch],
    );
  }

  Future<List<User>> fetchAll() async {
    final database = await DatabaseService().database;
    final users = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return users.map((user) => User.fromSqfliteDatabase(user)).toList();
  }
}
