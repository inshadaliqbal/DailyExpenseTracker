import 'package:dailyexpensetracker/database.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  Map<String, dynamic>? spendDetails;
  static const addExpense = 'AddExpense';
  AddExpense({super.key,this.spendDetails});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
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
    Expense _newExpense = Expense(
        amount: double.parse(amount),
        title: _selectedCategory,
        datetime: _selectedDateTime,
        amountType: 'spend');
    Provider.of<MainEngine>(context,listen: false).addExpense(_newExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Expense',
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
            _buildLabel('Amount'),
            _buildTextField(
              onChanged: (value) {
                amount = value;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            _buildLabel('Select Category'),
            _buildDropdownButton(),
            _buildLabel('Write A Note'),
            _buildTextField(),
            _buildLabel('Set A Date'),
            DateTimePickerWidget(
              updateDateTime: (value) {
                _selectedDateTime = value;
              },
            ),
            SizedBox(height: 16),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    void Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
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

  Widget _buildDropdownButton() {
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
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedCategory = newValue!;
        });
      },
    );
  }


  Widget _buildSaveButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        if(widget.spendDetails == null){
          _saveExpense();
          Navigator.pop(context);
        }else{

          Provider.of<MainEngine>(context,listen: false).deleteExpense(widget.spendDetails!['datetime']);
          _selectedDateTime = DateTime.parse(widget.spendDetails!["datetime"]);
          _saveExpense();
          Navigator.pop(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16),
        textStyle: TextStyle(fontSize: 16),
      ),
      child: Center(child: Text('Save', style: TextStyle(color: Colors.white))),
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
      _selectedDateTime = dateTime;
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
            _pickDateTime(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: Text(
            'Pick Date and Time',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
