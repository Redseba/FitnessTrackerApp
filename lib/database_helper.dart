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
      version: 2, // Increment this if you change the schema
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Handle upgrades if needed
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Creating tables...");
    
    
    await db.execute(''' 
      CREATE TABLE entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        containerId INTEGER
      )
    ''');
    
    print("Created table: entries");

    await db.execute('''
      CREATE TABLE total_calories (
        id INTEGER PRIMARY KEY,
        total INTEGER
      )
    ''');
    
    print("Created table: total_calories");


    await db.execute('''
      CREATE TABLE logged_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entryTitle TEXT,
        sets INTEGER,
        reps INTEGER,
        caloriesBurnt INTEGER
      )
    ''');

    
    print("Created table: logged_entries");

    // Initialize total calories with 0
    await db.insert('total_calories', {'id': 1, 'total': 0});
    print("Initialized total calories with 0");
  }


  // Optional: Upgrade method
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion");
    // Handle schema changes if needed
  }


  Future<void> insertEntry(Map<String, dynamic> entry) async {
    final db = await database;
    await db.insert('entries', entry, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Map<String, dynamic>>> getEntriesByContainerId(int containerId) async {
    final db = await database;
    return await db.query('entries', where: 'containerId = ?', whereArgs: [containerId]);
  }


  Future<void> updateTotalCalories(int totalCalories) async {
    final db = await database;
    await db.insert(
      'total_calories',
      {'id': 1, 'total': totalCalories},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<int> getTotalCalories() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('total_calories', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first['total'] : 0;
  }


  Future<void> insertLoggedEntry(Map<String, dynamic> entry) async {
    final db = await database;
    await db.insert('logged_entries', entry, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Map<String, dynamic>>> getLoggedEntries() async {
    final db = await database;
    return await db.query('logged_entries');
  }
}