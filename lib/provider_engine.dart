import 'package:dailyexpensetracker/database.dart';
import 'package:flutter/cupertino.dart';

class MainEngine extends ChangeNotifier {
  final dbHelper = DatabaseHelper();
  double _totalMoney = 0.0;
  double _todaysCashIn = 0.0; // Placeholder for actual logic
  double _todaysExpense = 0.0;
  double get totalMoney => _totalMoney;
  double get todaysCashIn => _todaysCashIn;
  double get todaysExpense => _todaysExpense;
  var _todaysTransactionList;
  var _dailyExpenseAndIncomeLast7Days;
  var _dailyExpenseAndIncomeLast7DaysList;

  List<Map<String, dynamic>> get todaysTransactionList =>
      _todaysTransactionList;

  void fetchData() async {
    _totalMoney = await dbHelper.getTotalMoneyForCurrentMonth();
    _todaysCashIn = await dbHelper
        .getTodaysTotalIncome(); // Replace with actual logic to fetch today's cash in
    _todaysExpense = await dbHelper.getTodaysTotalSpending();
    _todaysTransactionList = await dbHelper.getTodaysExpenses();
    _dailyExpenseAndIncomeLast7DaysList =
        await dbHelper.getWeeklyExpensesAndIncomeForLast7DaysList();
    _dailyExpenseAndIncomeLast7Days =
        await dbHelper.getDailyExpensesAndIncomeForLast7Days();
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> dailyExpenseAndIncomeLast7Days() async {
    return _dailyExpenseAndIncomeLast7Days;
  }

  Future<List<Map<String, dynamic>>>
      dailyExpenseAndIncomeLast7DaysList() async {
    return _dailyExpenseAndIncomeLast7DaysList;
  }

  void addExpense(Expense newExpense) async {
    await dbHelper.insertExpense(newExpense);
    fetchData();
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> expenseList(
      Future<List<Map<String, dynamic>>> inputFunction) async {
    print(inputFunction);
    List<Map<String, dynamic>> expenseList = await inputFunction;
    return expenseList;
  }

  Future<double> getMonthlyBalance() async {
    return await dbHelper.getTotalMoneyForCurrentMonth();
  }

  void deleteExpense(String datetime, double amount) {
    dbHelper.deleteRow(datetime, amount);
    notifyListeners();
  }

  void updateFunction(String datetime, double amount) {}
}
