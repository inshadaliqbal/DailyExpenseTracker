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
  var _weeklyExpenseAndIncome;
  var _weeklyExpenseAndIncomeList;
  var _monthlyExpenseAndIncome;
  var _monthlyExpenseAndIncomeList;

  List<Map<String, dynamic>> get todaysTransactionList =>
      _todaysTransactionList;

  List<Map<String, dynamic>> get dailyExpenseAndIncomeLast7DaysList =>
      _dailyExpenseAndIncomeLast7DaysList;

  List<Map<String, dynamic>> get weeklyExpenseAndIncomeList =>
      _weeklyExpenseAndIncomeList;

  List<Map<String, dynamic>> get monthlyExpenseAndIncomeList =>
      _monthlyExpenseAndIncomeList;



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
    _weeklyExpenseAndIncome = await dbHelper.getWeeklyExpensesAndIncome(
        DateTime.now().year, DateTime.now().month);
    _weeklyExpenseAndIncomeList = await dbHelper
        .getWeeklyExpensesAndIncomeList(DateTime.now().year, DateTime.now().month);
    _monthlyExpenseAndIncome = await dbHelper.getMonthlyExpensesAndIncome(DateTime.now().year);
    _monthlyExpenseAndIncomeList = await dbHelper.getMonthlyExpensesAndIncomeList(DateTime.now().year);
    print(_monthlyExpenseAndIncomeList);
    notifyListeners();
  }
  Future<List<Map<String, dynamic>>> monthlyExpenseAndIncome()async{
    return _monthlyExpenseAndIncome;
  }

  Future<List<Map<String, dynamic>>> weeklyExpenseAndIncome()async{
    return _weeklyExpenseAndIncome;
  }

  Future<List<Map<String, dynamic>>> dailyExpenseAndIncomeLast7Days() async {
    return _dailyExpenseAndIncomeLast7Days;
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

  void deleteExpense(String datetime) {
    dbHelper.deleteRow(datetime);
    notifyListeners();
  }

  void updateFunction(String datetime, double amount) {}
}
