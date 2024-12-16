import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), 'mushrooms.db');

    if (await File(dbPath).exists()) {
      await File(dbPath).delete();
    }

    ByteData data = await rootBundle.load('assets/mushrooms.db');
    List<int> bytes = data.buffer.asUint8List();
    await File(dbPath).writeAsBytes(bytes);

    return await openDatabase(dbPath);
  }

  Future<List<Map<String, dynamic>>> getMushrooms() async {
    Database db = await database;
    return await db.query('Mushrooms');
  }
}
