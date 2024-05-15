import 'dart:developer';

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
    final results = await database.rawQuery(
      'SELECT * FROM $tablename WHERE user_ipaddress = ? LIMIT 1',
      [ipAddress],
    );
    if (results.isNotEmpty) {
      return User.fromSqfliteDatabase(results.first);
    }
    return null;
  }

  Future<int> create({required String user_ipaddress}) async {
    final existingUser = await fetchByIpAddress(user_ipaddress);
    if (existingUser == null) {
      // ตรวจสอบว่า existingUser เป็น null หรือไม่
      log("ไม่เจอ ID");
      final database = await DatabaseService().database;
      return await database.rawInsert(
        '''INSERT INTO $tablename (user_ipaddress, created_at,updated_at) VALUES (?, ?, ?)''',
        [
          user_ipaddress,
          DateTime.now().microsecondsSinceEpoch,
          DateTime.now().microsecondsSinceEpoch
        ],
      );
    }
    // ถ้ามี IP อยู่แล้ว ไม่ต้องทำอะไร
    log("เจอ ID");
    return 0;
  }

  Future<List<User>> fetchAll() async {
    final database = await DatabaseService().database;
    final users = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return users.map((user) => User.fromSqfliteDatabase(user)).toList();
  }
}
