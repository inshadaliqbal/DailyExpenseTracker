import 'package:dailyexpensetracker/add_expense.dart';
import 'package:dailyexpensetracker/add_income.dart';
import 'package:dailyexpensetracker/bottombar.dart';
import 'package:dailyexpensetracker/database.dart';
import 'package:dailyexpensetracker/expense.dart';
import 'package:dailyexpensetracker/home_page.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:dailyexpensetracker/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DailyExpenseTracker());
}

class DailyExpenseTracker extends StatelessWidget {
  const DailyExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MainEngine(),
        builder: (context, MainEngine) {
          return MaterialApp(
            initialRoute: BottomBar.bottomBar,
            routes: {
              HomePage.homePage:(context)=> HomePage(),
              BottomBar.bottomBar: (context) => BottomBar(),
              AddExpense.addExpense: (context) => AddExpense(),
              AddIncome.addIncome: (context) => AddIncome(),
              StatisticsPage.statisticPage: (context) => StatisticsPage()
            },
          );
        });
  }
}
