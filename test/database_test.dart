import 'package:dailyexpensetracker/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MockDatabase extends Mock implements Database {}
class MockDirectory extends Mock implements Directory {}

void main() {
  group('DatabaseHelper', () {
    late DatabaseHelper dbHelper;
    late MockDatabase mockDatabase;
    late MockDirectory mockDirectory;

    setUp(() async {
      dbHelper = DatabaseHelper();
      mockDatabase = MockDatabase();
      mockDirectory = MockDirectory();

      when(() => mockDirectory.path).thenReturn('/mock/path');

      when(() => getApplicationDocumentsDirectory())
          .thenAnswer((_) => Future.value(mockDirectory));
    });

    test('should initialize database', () async {
      when(() => dbHelper.database).thenAnswer((_) => Future.value(mockDatabase));

      var database = await dbHelper.database;
      expect(database, isA<Database>());
    });

    test('should insert and retrieve expense', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      var id = await dbHelper.insertExpense(expense);
      expect(id, greaterThan(0));

      var expenses = await dbHelper.getExpenses();
      expect(expenses.length, greaterThan(0));
      expect(expenses.first.title, 'Test Expense');
    });

    test('should delete row', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);
      await dbHelper.deleteRow(expense.datetime!.toIso8601String());

      var expenses = await dbHelper.getExpenses();
      expect(expenses.where((e) => e.title == 'Test Expense').isEmpty, true);
    });

    test('should get today\'s expenses', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);

      var todayExpenses = await dbHelper.getTodaysExpenses();
      expect(todayExpenses.length, greaterThan(0));
    });

    test('should get today\'s spending', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);

      var totalSpending = await dbHelper.getTodaysTotalSpending();
      expect(totalSpending, greaterThan(0));
    });

    test('should get today\'s income', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'income');
      await dbHelper.insertExpense(expense);

      var totalIncome = await dbHelper.getTodaysTotalIncome();
      expect(totalIncome, greaterThan(0));
    });

    test('should get today\'s income entries', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'income');
      await dbHelper.insertExpense(expense);

      var todayIncome = await dbHelper.getTodaysIncome();
      expect(todayIncome.length, greaterThan(0));
    });

    test('should get weekly expenses and income list', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);

      var weeklyList = await dbHelper.getWeeklyExpensesAndIncomeList(DateTime.now().year, DateTime.now().month);
      expect(weeklyList.length, greaterThan(0));
    });

    test('should get weekly expenses and income for last 7 days list', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);

      var weeklyList = await dbHelper.getWeeklyExpensesAndIncomeForLast7DaysList();
      expect(weeklyList.length, greaterThan(0));
    });

    test('should get daily expenses and income for last 7 days', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);

      var dailyList = await dbHelper.getDailyExpensesAndIncomeForLast7Days();
      expect(dailyList.length, greaterThan(0));
    });

    test('should get weekly expenses and income', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);

      var weeklyExpensesAndIncome = await dbHelper.getWeeklyExpensesAndIncome(DateTime.now().year, DateTime.now().month);
      expect(weeklyExpensesAndIncome.length, greaterThan(0));
    });

    test('should get monthly expenses and income list', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);

      var monthlyList = await dbHelper.getMonthlyExpensesAndIncomeList(DateTime.now().year);
      expect(monthlyList.length, greaterThan(0));
    });

    test('should get monthly expenses and income', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'spend');
      await dbHelper.insertExpense(expense);

      var monthlyExpensesAndIncome = await dbHelper.getMonthlyExpensesAndIncome(DateTime.now().year);
      expect(monthlyExpensesAndIncome.length, greaterThan(0));
    });

    test('should get total money for current month', () async {
      var expense = Expense(title: 'Test Expense', amount: 10.0, datetime: DateTime.now(), amountType: 'income');
      await dbHelper.insertExpense(expense);

      var totalMoney = await dbHelper.getTotalMoneyForCurrentMonth();
      expect(totalMoney, greaterThan(0));
    });
  });
}
