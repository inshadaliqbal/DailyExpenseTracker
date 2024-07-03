import 'package:dailyexpensetracker/database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  static const statisticPage = 'StatisticPage';
  StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense'),backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.all(5),
                  child: Text('Weekly',style: TextStyle(color: Colors.white),),
                ),
              ),
              GestureDetector(
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.all(5),
                  child: Text('Monthly',style: TextStyle(color: Colors.white),),
                ),
              ),
              GestureDetector(
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.all(5),
                  child: Text('Yearly',style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
          Container(
              height: 300,
              width: 400,
              child: BarChartWidget())
        ],
      ),
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
                double totalExpenses = (weekData['totalExpenses'] as num).toDouble();
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
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              ),
              borderData: FlBorderData(show: false),
            ),
          );
        }
      },
    );
  }
}
