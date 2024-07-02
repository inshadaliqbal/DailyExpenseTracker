
import 'package:dailyexpensetracker/database.dart';
import 'package:flutter/cupertino.dart';

class MainEngine extends ChangeNotifier{
  final dbHelper = DatabaseHelper();
  var todaysTransactionList;

  void todaysTransaction() async {
    await dbHelper.database;
    todaysTransactionList = await dbHelper.getTodaysExpenses();
    notifyListeners();
  }

  Future<double?> todaysSpend() async {
    double? todaysSpendValue;
    var todaysSpend = await dbHelper.getTodaysSpend();
    for(Map<String,dynamic> i in todaysSpend){
      todaysSpendValue = todaysSpendValue !+ i['amount'];
    }
    print(todaysSpendValue);
    return todaysSpendValue;
  }
}