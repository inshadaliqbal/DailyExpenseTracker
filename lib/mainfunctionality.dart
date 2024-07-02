import 'package:dailyexpensetracker/database.dart';
import 'package:dailyexpensetracker/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';


class MainFunctionality extends StatefulWidget {
  MainFunctionality({super.key});

  @override
  State<MainFunctionality> createState() => _MainFunctionalityState();
}

class _MainFunctionalityState extends State<MainFunctionality> {
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

  void _saveExpense() async {
    Expense _newExpense = Expense(amount: double.parse(amount), title: _selectedCategory, datetime: _selectedDateTime);
    await dbHelper.insertExpense(_newExpense);
    print('Expense saved locally.');
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Expense',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount',
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              onChanged: (value){
                amount = value;
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,

            ),
            Text(
              'Select Catogary',
              style: TextStyle(color: Colors.black),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Category'),
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            Text(
              'Write A Note',
              style: TextStyle(color: Colors.black),
            ),
            TextField(),
            Text(
              'Set A Date',
              style: TextStyle(color: Colors.black),
            ),
            DateTimePickerWidget(updateDateTime: (value){
              _selectedDateTime = value;
            },),

            TextButton(
              onPressed: () {
                print(_selectedDateTime);
                _saveExpense();

              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () async{
                List<Expense> listExpense = await dbHelper.getExpenses();
                List<Map<String, dynamic>> monthAgg  = await dbHelper.getExpensesGroupedByWeek();
                print(monthAgg);
              },
              child: Text('Retrieve'),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimePickerWidget extends StatelessWidget {
  Function? updateDateTime;
  DateTimePickerWidget({this.updateDateTime});
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime(BuildContext context) async {
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
      // setState(() {
      _selectedDateTime = dateTime;
      // });
      updateDateTime!(_selectedDateTime);


    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            // Use Builder to obtain a valid context for the Navigator
            _pickDateTime(context);
          },
          child: Text('Pick Date and Time'),
        ),
        SizedBox(height: 20),
        Text(
          _selectedDateTime != null
              ? 'Selected DateTime: $_selectedDateTime'
              : 'No DateTime selected',
        ),
      ],
    );
  }
}
