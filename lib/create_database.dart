import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    String path = join(await getDatabasesPath(), 'mushrooms.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Mushrooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name_latin TEXT NOT NULL,
        name_polish TEXT,
        imagePath1 TEXT NOT NULL,
        imagePath2 TEXT NOT NULL,
        description TEXT,
        isEdible BOOLEAN
      )
    ''');
  }

  Future<int> insertMushroom(Map<String, dynamic> mushroom) async {
    Database db = await instance.database;
    return await db.insert('Mushrooms', mushroom);
  }

  Future<List<Map<String, dynamic>>> getMushrooms() async {
    Database db = await instance.database;
    return await db.query('Mushrooms');
  }
}
