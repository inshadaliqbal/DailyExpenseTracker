import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BarChartWeekly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Provider.of<MainEngine>(context)
          .weeklyExpenseAndIncome(), // Example year and month
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
  BarChartMonthly({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Provider.of<MainEngine>(context).monthlyExpenseAndIncome(),
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Provider.of<MainEngine>(context).dailyExpenseAndIncomeLast7Days(),
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
