import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const homePage = 'HomePage';

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blueAccent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          child: Icon(
                            Icons.supervised_user_circle,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Inshad Iqbal',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.notification_important_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Text('Balance'),
                    Text('\$472.00'),
                    Row(
                      children: [
                        Card(
                          child: Text('Today Cash In'),
                          color: Colors.greenAccent,
                        ),
                        Card(
                          child: Text('Today Expense'),
                          color: Colors.redAccent.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tranctions',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w800),
                    ),
                    Text('Todays')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.local_grocery_store,),
                    Text(Provider.of<MainEngine>(context).todaysTransactionList[1]["title"]),
                    Text('-\$240'),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
