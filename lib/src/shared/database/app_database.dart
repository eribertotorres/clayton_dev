import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final class AppDatabase {
  static const _databaseName = 'todos.db';
  static const _databaseVersion = 1;

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY,
        todo TEXT NOT NULL,
        completed INTEGER NOT NULL,
        userId INTEGER NOT NULL
      )
    ''');
  }
}
