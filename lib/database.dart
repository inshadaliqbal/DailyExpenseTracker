import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'expenses';

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If _database is null, initialize it
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get a location using path_provider
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'expenses.db');

    // Open/create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        datetime TEXT
      )
    ''');
  }

  Future<int> insertExpense(Expense expense) async {
    Database db = await database;
    return await db.insert(tableName, expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        datetime: DateTime.parse(maps[i]['datetime']),
      );
    });
  }

  Future<List<Map<String, dynamic>>> getExpensesGroupedByMonth() async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT strftime('%Y', datetime) AS year, strftime('%m', datetime) AS month, SUM(amount) AS total
    FROM expenses
    GROUP BY year, month
    ORDER BY year DESC, month DESC
  ''');
  }

  Future<List<Map<String, dynamic>>> getExpensesGroupedByWeek() async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y', datetime) AS year,
      strftime('%m', datetime) AS month,
      strftime('%W', datetime) AS week,
      SUM(amount) AS total
    FROM expenses
    GROUP BY year, month, week
    ORDER BY year DESC, month DESC, week DESC
  ''');
  }

}

class Expense {
  final int? id;
  final String? title;
  final double? amount;
  final DateTime? datetime;

  Expense(
      {this.id,
      required this.title,
      required this.amount,
      required this.datetime});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'datetime': datetime!.toIso8601String(),
    };
  }
}
