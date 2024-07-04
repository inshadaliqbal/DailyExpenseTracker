import 'package:dailyexpensetracker/widgets/appbars.dart';
import 'package:dailyexpensetracker/widgets/buttons.dart';
import 'package:dailyexpensetracker/helpers/database.dart';
import 'package:dailyexpensetracker/widgets/extracted_widgets.dart';
import 'package:dailyexpensetracker/helpers/provider_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  static const addExpense = 'AddExpense';
  Map<String, dynamic>? spendDetails;
  AddExpense({super.key, this.spendDetails});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  void _saveExpense() async {
    Expense _newExpense = Expense(
        amount: double.parse(amount),
        title: _selectedCategory,
        datetime: _selectedDateTime,
        amountType: 'spend');
    Provider.of<MainEngine>(context, listen: false).addExpense(_newExpense);
  }

  final List<String> _categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Utilities',
    'Health',
    'Other'
  ];
  String _selectedCategory = 'Food';
  DateTime? _selectedDateTime;
  var amount;
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBarAddExpense(),
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
              buttonFunction: () {
                if (widget.spendDetails == null) {
                  _saveExpense();
                  Navigator.pop(context);
                } else {
                  Provider.of<MainEngine>(context, listen: false)
                      .deleteExpense(widget.spendDetails!['datetime']);
                  _selectedDateTime =
                      DateTime.parse(widget.spendDetails!["datetime"]);
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
