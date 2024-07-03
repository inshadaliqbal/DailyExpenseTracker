
import 'package:dailyexpensetracker/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MainEngine extends ChangeNotifier{
  final dbHelper = DatabaseHelper();
  var todaysTransactionList;
  var todaysSpendValue;

  void todaysTransaction() async {
    await dbHelper.database;
    todaysTransactionList = await dbHelper.getTodaysExpenses();
    notifyListeners();
  }

  Future<double> todaysSpend()async {
    todaysSpendValue = await dbHelper.getTodaysTotalSpending();
    return todaysSpendValue;
  }

  Future<List<Map<String,dynamic>>> expenseList(Future<List<Map<String, dynamic>>> inputFunction) async {
    print(inputFunction);
    List<Map<String,dynamic>> expenseList = await inputFunction;
    return expenseList;
  }

  Future<double> getMonthlyBalance() async {
    return await dbHelper.getTotalMoneyForCurrentMonth();
  }

}

class DashboardProvider with ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();

  double _totalMoney = 0.0;
  double _todaysCashIn = 0.0; // Placeholder for actual logic
  double _todaysExpense = 0.0;

  double get totalMoney => _totalMoney;
  double get todaysCashIn => _todaysCashIn;
  double get todaysExpense => _todaysExpense;

  Future<void> fetchDashboardData(BuildContext context) async {
    _totalMoney = await dbHelper.getTotalMoneyForCurrentMonth();
    _todaysCashIn = await dbHelper.getTodaysTotalIncome(); // Replace with actual logic to fetch today's cash in
    _todaysExpense = await dbHelper.getTodaysTotalSpending();
    notifyListeners();
  }
}
