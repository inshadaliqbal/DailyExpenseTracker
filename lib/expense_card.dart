import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  Map<String,dynamic> expenseDetail;
  ExpenseCard({super.key,required this.expenseDetail});

  @override
  Widget build(BuildContext context) {
    print(expenseDetail);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${expenseDetail["amount"]} Dollars',style: TextStyle(color: Colors.white),),
                ),
                Text('Category'),
                Text('Date & Time'),
                Text('Note'),
                TextButton(
                  onPressed: () {

                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
                TextButton(onPressed: () {
                }, child: Text('Edit'))
              ],
            ),
          ),
        ));
  }
}
