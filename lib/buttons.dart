import 'package:flutter/material.dart';


class StatisticsPageAggregateButton extends StatelessWidget {
  String? buttonTitle;
  Function? buttonFunction;
  StatisticsPageAggregateButton(
      {super.key, required this.buttonTitle, required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        buttonFunction;
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          buttonTitle!,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class AddExpensesPageButton extends StatelessWidget {
  String? buttonTitle;
  Function? buttonFunction;
  AddExpensesPageButton(
      {super.key, required this.buttonTitle, this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        buttonFunction!();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16),
        textStyle: TextStyle(fontSize: 16),
      ),
      child: Center(
          child: Text(buttonTitle!, style: TextStyle(color: Colors.white))),
    );
  }
}
