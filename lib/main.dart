import 'package:dailyexpensetracker/add_expense.dart';
import 'package:dailyexpensetracker/add_income.dart';
import 'package:dailyexpensetracker/bottombar.dart';
import 'package:dailyexpensetracker/home_page.dart';
import 'package:dailyexpensetracker/notifications.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:dailyexpensetracker/statistics_page.dart';
import 'package:dailyexpensetracker/style.dart';
import 'package:dailyexpensetracker/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

void main() {
  initNotifications();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();


  runApp(
    DailyExpenseTracker(),
  );
}

class DailyExpenseTracker extends StatelessWidget {

  const DailyExpenseTracker({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainEngine(),
      builder: (context, mainEngine) {
        return MaterialApp(
          initialRoute: WelcomeScreen.welcome_screen,
          theme: buildThemeData(),
          routes: {
            HomePage.homePage: (context) => HomePage(),
            BottomBar.bottomBar: (context) => BottomBar(),
            AddExpense.addExpense: (context) => AddExpense(),
            AddIncome.addIncome: (context) => AddIncome(),
            StatisticsPage.statisticPage: (context) => StatisticsPage(),
            WelcomeScreen.welcome_screen: (context) => WelcomeScreen()
          },
        );
      },
    );
  }
}

