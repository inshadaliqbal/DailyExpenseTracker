
import 'package:dailyexpensetracker/database.dart';
import 'package:flutter/cupertino.dart';

class MainEngine extends ChangeNotifier{
  final dbHelper = DatabaseHelper();
  var todaysTransactionList;
  var todaysSpendValue;

  void todaysTransaction() async {
    await dbHelper.database;
    todaysTransactionList = await dbHelper.getTodaysExpenses();
    notifyListeners();
  }

  void todaysSpend() async {
    todaysSpendValue = 0;
    var todaysSpend = await dbHelper.getTodaysSpend();
    for(Map<String,dynamic> i in todaysSpend){
      todaysSpendValue = todaysSpendValue !+ i['amount'];
    }
    notifyListeners();
  }
}