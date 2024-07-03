import 'package:dailyexpensetracker/database.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  static const statisticPage = 'StatisticPage';
  StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final dbHelper = DatabaseHelper();
  Widget currentChart = BarChartWidget();
  @override
  Widget build(BuildContext context) {
    var expenseListFunction = dbHelper.getWeeklyExpensesAndIncomeForLast7DaysList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentChart = BarChartDaily();
                    expenseListFunction = dbHelper.getWeeklyExpensesAndIncomeForLast7DaysList();
                  });
                },
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.all(5),
                  child: Text(
                    'Daily',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    expenseListFunction = dbHelper.getWeeklyExpensesAndIncomeList(DateTime.now().year, DateTime.now().month);
                    currentChart = BarChartWidget();

                  });
                },
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.all(5),
                  child: Text(
                    'Weekly',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  expenseListFunction = dbHelper.getMonthlyExpensesAndIncomeList(DateTime.now().year);
                  setState(() {
                    currentChart = BarChartMonthly(year: 2024);

                  });
                },
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.all(5),
                  child: Text(
                    'Monthly',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.all(5),
                  child: Text(
                    'Yearly',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Container(height: 300, width: 400, child: currentChart),
          ExpenseList(inputFunction: expenseListFunction)
        ],
      ),
    );
  }
}

class ExpenseList extends StatelessWidget {
  Future<List<Map<String,dynamic>>> inputFunction;
  final dbHelper = DatabaseHelper();
  ExpenseList({super.key, required this.inputFunction});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<MainEngine>(context).expenseList(inputFunction),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;
          print(data);
          return Expanded(
            child: ListView.builder(
              itemCount: data
                  .length,
              itemBuilder: (context, index) {
                var transaction = data[index];
                print(transaction);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        Icons.local_grocery_store,
                        color: Colors.blueAccent,
                      ),
                      title: Text(transaction["title"]),
                      subtitle: Text(
                        'Amount: \$${transaction["amount"]}',
                      ),
                      trailing: Text(
                        '\$${transaction["amount"]}',
                        style: TextStyle(
                          color: transaction["amount"] > 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
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
  final dbHelper = DatabaseHelper();
  BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getWeeklyExpensesAndIncome(2024, 7),
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
                double totalIncome = (weekData['totalIncome']).toDouble();
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
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
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
  final dbHelper = DatabaseHelper();

  BarChartMonthly({required this.year});

  @override
  Widget build(BuildContext context) {
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
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
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
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
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
          return BarChart(
            BarChartData(
              barGroups: data.map((dayData) {
                double totalExpenses =
                (dayData['totalExpenses'] as num).toDouble();
                double totalIncome =
                (dayData['totalIncome'] as num).toDouble();
                String day = dayData['day'].split('-')[2];

                return BarChartGroupData(
                  x: int.parse(day),
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
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
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
