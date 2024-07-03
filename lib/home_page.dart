import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dailyexpensetracker/provider_engine.dart';

class HomePage extends StatefulWidget {
  static const homePage = 'HomePage';

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false)
          .fetchDashboardData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Daily Expense Tracker',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                letterSpacing: 1,
                fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<DashboardProvider>(
          builder: (context, dashboardProvider, child) {
            if (dashboardProvider.totalMoney == 0.0 &&
                dashboardProvider.todaysExpense == 0.0) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              child: Icon(
                                Icons.supervised_user_circle,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  'Inshad Iqbal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '\$ ${dashboardProvider.totalMoney.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Card(
                                color: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Today\'s Cash In',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '\$${dashboardProvider.todaysCashIn.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Card(
                                color: Colors.redAccent.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Today\'s Expense',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '\$${dashboardProvider.todaysExpense.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${DateTime.now().day} , ${DateTime.now().month}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: Provider.of<MainEngine>(context).todaysTransactionList.length,
                            itemBuilder: (context, index) {
                              var transaction = Provider.of<MainEngine>(context).todaysTransactionList[index];
                              print(transaction["datetime"]);
                              bool isIncome = transaction["amountType"] == 'income';
                              bool isSpend = transaction["amountType"] == 'spend';
                              bool isPositive = transaction["amount"] >= 0;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                  child: ListTile(
                                    leading: Icon(
                                      isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: isIncome ? Colors.green : Colors.red,
                                      size: 32, // Adjust size as needed
                                    ),
                                    title: Text(
                                      transaction["title"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Time: ${DateTime.parse(transaction["datetime"]).hour} : ${DateTime.parse(transaction["datetime"]).minute}', // Display absolute value
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    trailing: Text(
                                      '${isIncome ? '+' : '-'}\$${transaction["amount"].abs().toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: isIncome ? Colors.green : Colors.red, // Green for income, red for spend
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
