import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
              child: Container(
                color: Colors.lightBlueAccent,
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
                              style: TextStyle(color: Colors.white, fontSize: 15),
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
                        ListTile(
                          title: Text('Today Cash In'),
                          trailing: Text('100'),
                        ),
                        // ListTile(
                        //   title: Text('Today Expense'),
                        //   trailing: Text('50'),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
