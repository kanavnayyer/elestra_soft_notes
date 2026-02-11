import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'expenses.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE expenses(
          id TEXT PRIMARY KEY,
          title TEXT,
          amount REAL,
          currency TEXT,
          category TEXT,
          date TEXT,
          isSynced INTEGER,
          updatedAt TEXT
        )
        ''');
      },
    );

    return _database!;
  }
}
