
import 'package:dailyexpensetracker/database.dart';
import 'package:flutter/cupertino.dart';

class MainEngine extends ChangeNotifier{
  final dbHelper = DatabaseHelper();
  var todaysTransactionList;

  void todaysTransaction() async {
    todaysTransactionList = await dbHelper.getTodaysExpenses();
    notifyListeners();
  }
}