import 'dart:ui';

import 'package:dailyexpensetracker/appbars.dart';
import 'package:dailyexpensetracker/expense_card.dart';
import 'package:dailyexpensetracker/extracted_widgets.dart';
import 'package:dailyexpensetracker/style.dart';
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
      Provider.of<MainEngine>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomePageAppBar(),
      body: SafeArea(
        child: Consumer<MainEngine>(
          builder: (context, mainEngine, child) {
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: buildHomePageBoxDecoration(),
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
                          '\$ ${mainEngine.totalMoney.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        HomePageExpenseRow(mainEngine: mainEngine),
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
                        HomePageExpenseList(mainEngine: mainEngine),
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

