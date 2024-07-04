import 'package:flutter/material.dart';

AppBar buildHomePageAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Center(
      child: Text(
        'Daily Expense Tracker',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  );
}

AppBar buildAppBarStatistics() {
  return AppBar(
    title: Text(
      'Expense Statistics',
      style: TextStyle(color: Colors.black),
    ),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black), // Adjust app bar icon color
  );
}

AppBar buildAppBarAddExpense() {
  return AppBar(
    title: Text(
      'Add Expense',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
  );
}
