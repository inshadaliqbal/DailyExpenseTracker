import 'package:dailyexpensetracker/add_expense.dart';
import 'package:dailyexpensetracker/add_income.dart';
import 'package:flutter/material.dart';

class MyBottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 200,
      color: Colors.white,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, AddIncome.addIncome);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  color: Colors.green.shade300,
                  child: Center(
                    child: Text(
                      'Income',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, AddExpense.addExpense);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  color: Colors.red.shade300,
                  child: Center(
                    child: Text(
                      'Expense',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
