import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

  @override
  Widget build(BuildContext context) {
    var currentExpenseListFunc =
        dbHelper.getWeeklyExpensesAndIncomeForLast7DaysList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Statistics'),
        backgroundColor: Colors.white,
        iconTheme:
            IconThemeData(color: Colors.black), // Adjust app bar icon color
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentChart = BarChartDaily();
                      currentExpenseListFunc =
                          dbHelper.getWeeklyExpensesAndIncomeForLast7DaysList();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Daily',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentChart = BarChartWidget();
                      currentExpenseListFunc =
                          dbHelper.getWeeklyExpensesAndIncomeForLast7DaysList();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Weekly',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentChart = BarChartMonthly(year: DateTime.now().year);
                      currentExpenseListFunc = dbHelper
                          .getMonthlyExpensesAndIncomeList(DateTime.now().year);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Monthly',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
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
          ExpenseList(inputFunction: currentExpenseListFunc),
        ],
      ),
    );
  }
}

class ExpenseList extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> inputFunction;

  ExpenseList({Key? key, required this.inputFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: inputFunction,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var transaction = data[index];
                bool isIncome = transaction["amountType"] == 'income';
                IconData arrowIcon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;
                Color amountColor = isIncome ? Colors.green : Colors.red;
                double amountValue = transaction["amount"] * (isIncome ? 1 : -1);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onLongPress: (){
                      Provider.of<MainEngine>(context,listen: false).deleteExpense(transaction['datetime'], transaction['amount']);
                    },


                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(
                          arrowIcon,
                          color: amountColor,
                        ),
                        title: Text(
                          transaction["title"],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Date: ${DateTime.parse(transaction["datetime"]).day}/${DateTime.parse(transaction["datetime"]).month}',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        trailing: Text(
                          '${amountValue.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: amountColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}


class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getWeeklyExpensesAndIncome(
          2024, 7), // Example year and month
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;

          return BarChart(
            BarChartData(
              barGroups: data.map((weekData) {
                double totalExpenses =
                    (weekData['totalExpenses'] as num).toDouble();
                double totalIncome =
                    (weekData['totalIncome'] as num).toDouble();
                int week = int.parse(weekData['week'].split('-')[1]);

                return BarChartGroupData(
                  x: week,
                  barRods: [
                    BarChartRodData(
                      toY: totalExpenses,
                      color: Colors.red,
                      width: 15,
                    ),
                    BarChartRodData(
                      toY: totalIncome,
                      color: Colors.green,
                      width: 15,
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String day = value.toInt().toString().padLeft(2, '0');
                      return Text(day);
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          );
        }
      },
    );
  }
}

class BarChartMonthly extends StatelessWidget {
  final int year;

  BarChartMonthly({required this.year});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getMonthlyExpensesAndIncome(year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;

          return BarChart(
            BarChartData(
              barGroups: data.map((monthData) {
                double totalExpenses =
                    (monthData['totalExpenses'] as num).toDouble();
                double totalIncome =
                    (monthData['totalIncome'] as num).toDouble();
                int month = int.parse(monthData['month'].split('-')[1]);

                return BarChartGroupData(
                  x: month,
                  barRods: [
                    BarChartRodData(
                      toY: totalExpenses,
                      color: Colors.red,
                      width: 15,
                    ),
                    BarChartRodData(
                      toY: totalIncome,
                      color: Colors.green,
                      width: 15,
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String day = value.toInt().toString().padLeft(2, '0');
                      return Text(day);
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          );
        }
      },
    );
  }
}

class BarChartDaily extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getDailyExpensesAndIncomeForLast7Days(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                barGroups: data.map((dayData) {
                  double totalExpenses =
                      (dayData['totalExpenses'] as num).toDouble();
                  double totalIncome =
                      (dayData['totalIncome'] as num).toDouble();
                  int day = int.parse(dayData['day'].split('-')[2]);

                  return BarChartGroupData(
                    x: day,
                    barRods: [
                      BarChartRodData(
                        toY: totalExpenses,
                        color: Colors.redAccent,
                        width: 10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: totalIncome,
                        color: Colors.greenAccent,
                        width: 10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String day = value.toInt().toString().padLeft(2, '0');
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            day,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.transparent),
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                gridData: FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: Colors.black.withOpacity(0.75),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toString(),
                        TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (event.isInterestedForInteractions &&
                        barTouchResponse != null &&
                        barTouchResponse.spot != null) {
                      final touchSpot = barTouchResponse.spot!;
                      print(
                          'Touched ${touchSpot.touchedRodData.toY} on day ${touchSpot.touchedBarGroup.x}');
                    }
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
