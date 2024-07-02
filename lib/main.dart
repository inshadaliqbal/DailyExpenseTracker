import 'package:dailyexpensetracker/database.dart';
import 'package:dailyexpensetracker/expense.dart';
import 'package:dailyexpensetracker/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

void main() {
  runApp(DailyExpenseTracker(

  ));
}

class DailyExpenseTracker extends StatelessWidget {
  const DailyExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
