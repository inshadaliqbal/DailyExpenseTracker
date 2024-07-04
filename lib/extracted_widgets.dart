import 'dart:ui';

import 'package:dailyexpensetracker/buttons.dart';
import 'package:dailyexpensetracker/expense_card.dart';
import 'package:flutter/services.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'provider_engine.dart';
import 'package:flutter/material.dart';


class HomePageExpenseRow extends StatelessWidget {
  MainEngine mainEngine;
  HomePageExpenseRow({
    super.key,required this.mainEngine
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    '\$${mainEngine.todaysCashIn.toStringAsFixed(2)}',
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
                    '\$${mainEngine.todaysExpense.toStringAsFixed(2)}',
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
    );
  }
}

class HomePageExpenseList extends StatelessWidget {
  MainEngine mainEngine;
  HomePageExpenseList({super.key, required this.mainEngine});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount:
        mainEngine.todaysTransactionList.length,
        itemBuilder: (context, index) {
          var transaction =
          mainEngine.todaysTransactionList[index];
          print(transaction["datetime"]);
          bool isIncome = transaction["amountType"] == 'income';
          bool isSpend = transaction["amountType"] == 'spend';
          bool isPositive = transaction["amount"] >= 0;

          return Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GestureDetector(
              onLongPress: () {
                mainEngine.deleteExpense(transaction["datetime"]);
              },
              onTap: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Label',
                  pageBuilder: (context, anim1, anim2) {
                    return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: ExpenseCard(
                          expenseDetail: transaction,
                        ));
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return FadeTransition(
                      opacity: anim1,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 200),
                );
              },
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
                      color: isIncome
                          ? Colors.green
                          : Colors.red, // Green for income, red for spend
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExpenseListStatisticsPage extends StatelessWidget {
  final List<Map<String, dynamic>> inputFunction;

  ExpenseListStatisticsPage({Key? key, required this.inputFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(inputFunction);
    return Expanded(
      child: ListView.builder(
        itemCount: inputFunction.length,
        itemBuilder: (context, index) {
          var transaction = inputFunction[index];
          bool isIncome = transaction["amountType"] == 'income';
          IconData arrowIcon =
          isIncome ? Icons.arrow_upward : Icons.arrow_downward;
          Color amountColor = isIncome ? Colors.green : Colors.red;
          double amountValue = transaction["amount"] * (isIncome ? 1 : -1);

          return Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GestureDetector(
              onLongPress: () {
                Provider.of<MainEngine>(context, listen: false).deleteExpense(
                    transaction['datetime']);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    arrowIcon,
                    color: amountColor,
                  ),
                  title: Text(
                    transaction["title"],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${DateTime.parse(transaction["datetime"]).day}/${DateTime.parse(transaction["datetime"]).month}',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: Text(
                    '${amountValue.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: amountColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddExpensePagesDropDown extends StatelessWidget {
  const AddExpensePagesDropDown({
    super.key,
    required String selectedCategory,
    required List<String> categories,
    required Function dropDownFunction,
  })  : _selectedCategory = selectedCategory,
        _categories = categories,
        _dropDownFunction = dropDownFunction;

  final String _selectedCategory;
  final List<String> _categories;
  final Function _dropDownFunction;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
      value: _selectedCategory,
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(
            category,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        _dropDownFunction(newValue);
      },
    );
  }
}

class DateTimePickerWidget extends StatelessWidget {
  Function? updateDateTime;
  DateTimePickerWidget({this.updateDateTime});
  DateTime? _selectedDateTime;

  Future<void> pickDateTime(BuildContext context) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(const Duration(days: 3652)),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );

    if (dateTime != null) {
      _selectedDateTime = dateTime;
      updateDateTime!(_selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddExpensesPageButton(buttonTitle: 'Pick Date And Time',buttonFunction: () {
          pickDateTime(context);
        },),
        SizedBox(height: 20),
        Text(
          _selectedDateTime != null
              ? 'Selected DateTime: $_selectedDateTime'
              : 'No DateTime selected',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}


class LabelAddExpensePages extends StatelessWidget {
  String? text;
  LabelAddExpensePages({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text!,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class AddExpensesTextField extends StatelessWidget {
  Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;
  AddExpensesTextField({
    super.key,this.inputFormatters,this.keyboardType,this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

