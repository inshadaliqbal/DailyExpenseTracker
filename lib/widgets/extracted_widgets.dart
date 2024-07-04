import 'dart:ui';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:dailyexpensetracker/widgets/buttons.dart';
import 'package:dailyexpensetracker/widgets/expense_card.dart';
import 'package:dailyexpensetracker/style/style.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import '../helpers/provider_engine.dart';
import 'package:flutter/material.dart';

class HomePageExpenseRow extends StatelessWidget {
  MainEngine mainEngine;
  HomePageExpenseRow({super.key, required this.mainEngine});

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
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${mainEngine.todaysCashIn.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${mainEngine.todaysExpense.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
        itemCount: mainEngine.todaysTransactionList.length,
        itemBuilder: (context, index) {
          var transaction = mainEngine.todaysTransactionList[index];
          print(transaction["datetime"]);
          bool isIncome = transaction["amountType"] == 'income';
          print(transaction);
          if (transaction['title'] == null) {
            return Center(
              child: Text(
                'No Data; Add Transactions',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          }
        },
      ),
    );
  }
}

class ExpenseListStatisticsPage extends StatelessWidget {
  final List<Map<String, dynamic>> inputFunction;

  ExpenseListStatisticsPage({Key? key, required this.inputFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(inputFunction);
    return Expanded(
      child: ListView.builder(
        itemCount: inputFunction.length,
        itemBuilder: (context, index) {
          var transaction = inputFunction[index];
          bool isIncome = transaction["amountType"] == 'income';

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GestureDetector(
              onLongPress: () {
                Provider.of<MainEngine>(context, listen: false)
                    .deleteExpense(transaction['datetime']);
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
                    'Date: ${DateTime.parse(transaction["datetime"]).toString().substring(0, 10)}', // Display absolute value
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
        AddExpensesPageButton(
          buttonTitle: 'Pick Date And Time',
          buttonFunction: () {
            pickDateTime(context);
          },
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
  AddExpensesTextField(
      {super.key, this.inputFormatters, this.keyboardType, this.onChanged});

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

class MainButton extends StatelessWidget {
  String? title;
  Function? buttonFunction;
  MainButton({super.key, @required this.title, @required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          buttonFunction!();
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(
              color: Colors.black, width: 1), // Border color and width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Border radius
          ),
        ),
        child: Text(
          title!,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: Colors.black),
        ),
      ),
    );
  }
}

class buildSocialButton extends StatelessWidget {
  const buildSocialButton({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey[200],
      ),
      child: Image.asset(imagePath),
    );
  }
}

class MainTextField extends StatelessWidget {
  String? hintText;
  Function? textfieldFunction;
  MainTextField(
      {super.key, @required this.hintText, @required this.textfieldFunction});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        textfieldFunction!(value);
      },
      obscureText: true,
      decoration: MainTextFieldInputDecoration('Name'),
    );
  }
}

class BlurryHUD extends StatelessWidget {
  final Widget childWidget;

  BlurryHUD({Key? key, required this.childWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: Provider.of<MainEngine>(context).getLoadingBool(),
      blurEffectIntensity: 4,
      progressIndicator: ProgressIndicatorContainer(),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black,
      child: childWidget,
    );
  }
}

class ProgressIndicatorContainer extends StatelessWidget {
  const ProgressIndicatorContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: 300,
        minHeight: 100,
        minWidth: 100,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Loading Please Wait',
            style: TextStyle(fontSize: 20),
          ),
          SpinKitFadingCircle(
            color: Colors.white,
            size: 50.0,
          ),
        ],
      ),
    );
  }
}

class MainTextFieldSign extends StatelessWidget {
  final Function changeFunction;
  final String? label;

  MainTextFieldSign(
      {Key? key, required this.label, required this.changeFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
        child: TextFormField(
          style: TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => changeFunction(value),
          textAlign: TextAlign.left,
          decoration: MainTextFieldInputDecoration(label),
          validator: _validateEmail,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }
}

class MainTextFieldPassword extends StatelessWidget {
  final Function changeFunction;
  final String? label;

  MainTextFieldPassword(
      {Key? key, required this.label, required this.changeFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.visiblePassword,
          onChanged: (value) => changeFunction(value),
          textAlign: TextAlign.left,
          decoration: MainTextFieldInputDecoration(label),
          validator: _validatePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email address.';
  }
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email address.';
  }
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password.';
  }
  if (value.length < 7) {
    return 'Password should contain at least 6 characters';
  }
  return null;
}
