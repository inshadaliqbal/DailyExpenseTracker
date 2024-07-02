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
        amountType TEXT
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
        datetime: DateTime.parse(maps[i]['datetime'],
        ), amountType: maps[i]['amountType'],
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

  Future<List<Map<String, dynamic>>> getTodaysExpenses() async {
    Database db = await database;
    final today = DateTime.now();
    final todayString =
        today.toIso8601String().substring(0, 10); // Get 'YYYY-MM-DD'

    return await db.rawQuery('''
    SELECT * FROM expenses
    WHERE strftime('%Y-%m-%d', datetime) = ?
    ORDER BY datetime ASC
  ''', [todayString]);
  }

  Future<List<Map<String, dynamic>>> getTodaysSpend() async {
    Database db = await database;
    final today = DateTime.now();
    final todayString = today.toIso8601String().substring(0, 10); // Get 'YYYY-MM-DD'

    return await db.rawQuery('''
    SELECT * FROM expenses
    WHERE strftime('%Y-%m-%d', datetime) = ? AND dataType = 'spend'
    ORDER BY datetime ASC
  ''', [todayString]);
  }

  Future<List<Map<String, dynamic>>> getTodaysIncome() async {
    Database db = await database;
    final today = DateTime.now();
    final todayString = today.toIso8601String().substring(0, 10); // Get 'YYYY-MM-DD'

    return await db.rawQuery('''
    SELECT * FROM expenses
    WHERE strftime('%Y-%m-%d', datetime) = ? AND dataType = 'income'
    ORDER BY datetime ASC
  ''', [todayString]);
  }
  Future<void> deleteExpensesTable() async {
    Database db = await database;
    await db.execute('DROP TABLE IF EXISTS expenses');
  }
}

class Expense {
  final int? id;
  final String? title;
  final double? amount;
  final DateTime? datetime;
  final String? amountType;

  Expense(
      {this.id,
      required this.title,
      required this.amount,
      required this.datetime,
      required this.amountType});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'amountType': amountType,
      'datetime': datetime!.toIso8601String(),
    };
  }

}
