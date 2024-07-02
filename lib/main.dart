import 'package:flutter/material.dart';

void main() {
  runApp(DailyExpenseTracker());
}

class DailyExpenseTracker extends StatefulWidget {
  DailyExpenseTracker({super.key});

  @override
  State<DailyExpenseTracker> createState() => _DailyExpenseTrackerState();
}

class _DailyExpenseTrackerState extends State<DailyExpenseTracker> {
  final List<String> _categories = ['Food', 'Transport', 'Entertainment', 'Utilities', 'Health', 'Other'];
  String _selectedCategory = 'Food';
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
            Text('Amount',style: TextStyle(color: Colors.black),),
            TextField(
              keyboardType: TextInputType.number,
            ),
            Text('Select Catogary',style: TextStyle(color: Colors.black),),
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
            Text('Write A Note',style: TextStyle(color: Colors.black),),
            TextField(

            ),
            Text('Set A Date',style: TextStyle(color: Colors.black),),

          ],
        ),
      ),
    );
  }
}
