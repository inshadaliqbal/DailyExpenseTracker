import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'expense';

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If _database is null, initialize it
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get a location using path_provider
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'expense.db');

    // Open/create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        datetime TEXT,
        amountType TEXT
      )
    ''');
  }

  Future<void> deleteRow(String datetime, double amount) async {
    Database db = await database;
    await db.delete(
      tableName,
      where: 'datetime = ? AND amount = ?',
      whereArgs: [datetime, amount],
    );
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

  Future<List<Map<String, dynamic>>> getTodaysExpenses() async {
    Database db = await database;
    final today = DateTime.now();
    final todayString =
        today.toIso8601String().substring(0, 10); // Get 'YYYY-MM-DD'

    return await db.rawQuery('''
    SELECT * FROM expense
    WHERE strftime('%Y-%m-%d', datetime) = ?
    ORDER BY datetime ASC
  ''', [todayString]);
  }

  Future<List<Map<String, dynamic>>> getTodaysSpend() async {
    Database db = await database;
    final today = DateTime.now();
    final todayString = today.toIso8601String().substring(0, 10); // Get 'YYYY-MM-DD'

    return await db.rawQuery('''
    SELECT * FROM expense
    WHERE strftime('%Y-%m-%d', datetime) = ? AND amountType = 'spend'
    ORDER BY datetime ASC
  ''', [todayString]);
  }
  Future<double> getTodaysTotalSpending() async {
    Database db = await database;
    final today = DateTime.now();
    final todayString = today.toIso8601String().substring(0, 10); // Get 'YYYY-MM-DD'

    List<Map<String, dynamic>> spendExpenses = await db.rawQuery('''
    SELECT amount FROM expense
    WHERE strftime('%Y-%m-%d', datetime) = ? AND amountType = 'spend'
    ORDER BY datetime ASC
  ''', [todayString]);

    double totalSpending = spendExpenses.fold(0, (previousValue, expense) {
      return previousValue + (expense['amount'] as num).toDouble();
    });

    return totalSpending;
  }

  Future<double> getTodaysTotalIncome() async {
    Database db = await database;
    final today = DateTime.now();
    final todayString = today.toIso8601String().substring(0, 10); // Get 'YYYY-MM-DD'

    List<Map<String, dynamic>> incomeExpenses = await db.rawQuery('''
    SELECT amount FROM expense
    WHERE strftime('%Y-%m-%d', datetime) = ? AND amountType = 'income'
    ORDER BY datetime ASC
  ''', [todayString]);

    double totalIncome = incomeExpenses.fold(0, (previousValue, income) {
      return previousValue + (income['amount'] as num).toDouble();
    });

    return totalIncome;
  }

  Future<List<Map<String, dynamic>>> getTodaysIncome() async {
    Database db = await database;
    final today = DateTime.now();
    final todayString = today.toIso8601String().substring(0, 10); // Get 'YYYY-MM-DD'

    return await db.rawQuery('''
    SELECT * FROM expense
    WHERE strftime('%Y-%m-%d', datetime) = ? AND dataType = 'income'
    ORDER BY datetime ASC
  ''', [todayString]);
  }
  Future<void> deleteExpensesTable() async {
    Database db = await database;
    await db.execute('DROP TABLE IF EXISTS expenses');
  }



  Future<List<Map<String, dynamic>>> getWeeklyExpensesAndIncomeList(int year, int month) async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y-%W', datetime) AS week,
      title,
      amountType,
      amount
    FROM expense
    WHERE strftime('%Y', datetime) = ? AND strftime('%m', datetime) = ?
    ORDER BY week ASC
  ''', [year.toString(), month.toString().padLeft(2, '0')]);
  }

  Future<List<Map<String, dynamic>>> getWeeklyExpensesAndIncomeForLast7DaysList() async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y-%W', datetime) AS week,
      title,
      amountType,
      datetime,
      amount
    FROM expense
    WHERE datetime >= date('now', '-7 days')
    ORDER BY week ASC
  ''');
  }


  Future<List<Map<String, dynamic>>> getDailyExpensesAndIncomeForLast7Days() async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y-%m-%d', datetime) AS day,
      SUM(CASE WHEN amountType = 'spend' THEN amount ELSE 0 END) AS totalExpenses,
      SUM(CASE WHEN amountType = 'income' THEN amount ELSE 0 END) AS totalIncome
    FROM expense
    WHERE datetime >= date('now', '-7 days')
    GROUP BY day
    ORDER BY day ASC
  ''');
  }



  Future<List<Map<String, dynamic>>> getWeeklyExpensesAndIncome(int year, int month) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT 
        strftime('%Y-%W', datetime) AS week,
        SUM(CASE WHEN amountType = 'spend' THEN amount ELSE 0 END) AS totalExpenses,
        SUM(CASE WHEN amountType = 'income' THEN amount ELSE 0 END) AS totalIncome
      FROM expense
      WHERE strftime('%Y', datetime) = ? AND strftime('%m', datetime) = ?
      GROUP BY week
      ORDER BY week ASC
    ''', [year.toString(), month.toString().padLeft(2, '0')]);
  }

  Future<List<Map<String, dynamic>>> getMonthlyExpensesAndIncomeList(int year) async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y-%m', datetime) AS month,
      title,
      amountType,
      amount
    FROM expense
    WHERE strftime('%Y', datetime) = ?
    ORDER BY month ASC
  ''', [year.toString()]);
  }


  Future<List<Map<String, dynamic>>> getMonthlyExpensesAndIncome(int year) async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y-%m', datetime) AS month,
      SUM(CASE WHEN amountType = 'spend' THEN amount ELSE 0 END) AS totalExpenses,
      SUM(CASE WHEN amountType = 'income' THEN amount ELSE 0 END) AS totalIncome
    FROM expense
    WHERE strftime('%Y', datetime) = ?
    GROUP BY month
    ORDER BY month ASC
  ''', [year.toString()]);
  }

  Future<double> getTotalMoneyForCurrentMonth() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      SUM(CASE WHEN amountType = 'income' THEN amount ELSE 0 END) - 
      SUM(CASE WHEN amountType = 'spend' THEN amount ELSE 0 END) AS totalMoney
    FROM expense
    WHERE strftime('%Y-%m', datetime) = strftime('%Y-%m', 'now')
  ''');

    if (result.isNotEmpty && result.first['totalMoney'] != null) {
      return (result.first['totalMoney'] as num).toDouble();
    } else {
      return 0.0;
    }
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
