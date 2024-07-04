import 'package:dailyexpensetracker/appbars.dart';
import 'package:dailyexpensetracker/buttons.dart';
import 'package:dailyexpensetracker/charts.dart';
import 'package:dailyexpensetracker/extracted_widgets.dart';
import 'package:dailyexpensetracker/main.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpensetracker/database.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  static const statisticPage = 'StatisticPage';

  StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final dbHelper = DatabaseHelper();
  Widget currentChart = BarChartDaily();
  List<Map<String, dynamic>> currentExpenseListFunc = Provider.of<MainEngine>(navigatorKey.currentState!.context).dailyExpenseAndIncomeLast7DaysList;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBarStatistics(),
      body: Consumer<MainEngine>(builder: (context, mainEngine, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatisticsPageAggregateButton(
                    buttonTitle: 'Daily',
                    buttonFunction: () {
                      setState(() {

                        currentChart = BarChartDaily();
                        currentExpenseListFunc =
                            mainEngine.dailyExpenseAndIncomeLast7DaysList;
                      });
                      print(currentExpenseListFunc);
                    },
                  ),
                  StatisticsPageAggregateButton(
                    buttonTitle: 'Weekly',
                    buttonFunction: () {
                      setState(() {
                        currentChart = BarChartWeekly();
                        currentExpenseListFunc =
                            mainEngine.weeklyExpenseAndIncomeList;
                      });
                    },
                  ),
                  StatisticsPageAggregateButton(
                    buttonTitle: 'Monthly',
                    buttonFunction: () {
                      setState(() {
                        currentChart = BarChartMonthly();
                        currentExpenseListFunc =
                            mainEngine.monthlyExpenseAndIncomeList;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: currentChart,
              ),
            ),
            ExpenseListStatisticsPage(inputFunction: currentExpenseListFunc),
          ],
        );
      }),
    );
  }
}
