import 'package:dailyexpensetracker/pages/add_expense.dart';
import 'package:dailyexpensetracker/pages/add_income.dart';
import 'package:flutter/material.dart';

class MyBottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose an option',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOptionCard(
                context,
                title: 'Income',
                color: Colors.green.shade300,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AddIncome.addIncome);
                },
              ),
              _buildOptionCard(
                context,
                title: 'Expense',
                color: Colors.red.shade300,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AddExpense.addExpense);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, {required String title, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

