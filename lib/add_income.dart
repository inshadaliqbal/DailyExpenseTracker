import 'package:dailyexpensetracker/buttons.dart';
import 'package:dailyexpensetracker/database.dart';
import 'package:dailyexpensetracker/extracted_widgets.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddIncome extends StatefulWidget {
  static const addIncome = 'AddIncome';
  Map<String, dynamic>? incomeDetails;
  AddIncome({this.incomeDetails});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final List<String> _categories = [
    'Salary',
    'Credit',
    'Incentive',
    'Tip',
    'Loan',
    'Profit',
    'Other'
  ];
  String _selectedCategory = 'Salary';
  DateTime? _selectedDateTime;
  var amount;
  final dbHelper = DatabaseHelper();

  void _saveExpense() async {
    Expense _newExpense = Expense(
        amount: double.parse(amount),
        title: _selectedCategory,
        datetime: _selectedDateTime,
        amountType: 'income');

    Provider.of<MainEngine>(context, listen: false).addExpense(_newExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Income',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelAddExpensePages(text: 'Amount'),
            AddExpensesTextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = value;
                }),
            LabelAddExpensePages(text: 'Select Category'),
            AddExpensePagesDropDown(
              selectedCategory: _selectedCategory,
              categories: _categories,
              dropDownFunction: (_newValue) {
                setState(() {
                  _selectedCategory = _newValue!;
                });
              },
            ),
            LabelAddExpensePages(text: 'Write A Note'),
            AddExpensesTextField(),
            LabelAddExpensePages(
              text: 'Set A Date',
            ),
            DateTimePickerWidget(
              updateDateTime: (value) {
                _selectedDateTime = value;
              },
            ),
            SizedBox(height: 16),
            AddExpensesPageButton(
              buttonTitle: 'Save',
              buttonFunction: () async {
                if (widget.incomeDetails == null) {
                  _saveExpense();
                  Navigator.pop(context);
                } else {
                  Provider.of<MainEngine>(context, listen: false)
                      .deleteExpense(widget.incomeDetails!['datetime']);
                  _selectedDateTime =
                      DateTime.parse(widget.incomeDetails!["datetime"]);
                  _saveExpense();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
