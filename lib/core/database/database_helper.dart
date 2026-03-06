import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Check if running on web
    if (kIsWeb) {
      throw UnsupportedError(
        'SQLite is not supported on web. Use shared_preferences or IndexedDB instead.'
      );
    }
    
    _database = await _initDB('bmi_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final path = join(appDocDir.path, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        gender TEXT NOT NULL,
        dateOfBirth TEXT NOT NULL,
        height REAL NOT NULL,
        avatar TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // BMI Records table
    await db.execute('''
      CREATE TABLE bmi_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        weight REAL NOT NULL,
        height REAL NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        bmi REAL NOT NULL,
        category TEXT NOT NULL,
        notes TEXT,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Meals table (for dietary suggestions)
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        name TEXT NOT NULL,
        mealType TEXT NOT NULL,
        calories INTEGER NOT NULL,
        protein REAL NOT NULL,
        imageUrl TEXT,
        date TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // Close database
  Future<void> close() async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.close();
  }

  // Reset database (for testing)
  Future<void> resetDatabase() async {
    if (kIsWeb) return;
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final path = join(appDocDir.path, 'bmi_tracker.db');
    await deleteDatabase(path);
    _database = null;
  }
}
