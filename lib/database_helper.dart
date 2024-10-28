import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        containerId INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS entries');
    await _onCreate(db, newVersion);
  }

  Future<void> insertEntry(Map<String, dynamic> entry) async {
    final db = await database;
    await db.insert('entries', entry, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getEntriesByContainerId(int containerId) async {
    final db = await database;
    return await db.query('entries', where: 'containerId = ?', whereArgs: [containerId]);
  }

  // Dummy implementation for total calories; adjust logic as needed later.
  Future<int> getTotalCalories() async {
    // Return 0 for now since we don't have a calories column
    return 0; 
  }
}
