import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dailyexpensetracker/database.dart';
import 'package:dailyexpensetracker/secret_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class MainEngine extends ChangeNotifier {
  final dbHelper = DatabaseHelper();
  bool? loadingBool = false;
  double _totalMoney = 0.0;
  double _todaysCashIn = 0.0; // Placeholder for actual logic
  double _todaysExpense = 0.0;
  double get totalMoney => _totalMoney;
  double get todaysCashIn => _todaysCashIn;
  double get todaysExpense => _todaysExpense;
  var _todaysTransactionList;
  var _dailyExpenseAndIncomeLast7Days;
  var _dailyExpenseAndIncomeLast7DaysList;
  var _weeklyExpenseAndIncome;
  var _weeklyExpenseAndIncomeList;
  var _monthlyExpenseAndIncome;
  var _monthlyExpenseAndIncomeList;
  var _userName;

  FirebaseAuth? _firebaseAuth;
  FirebaseFirestore? _firestore;
  String? currentUserEmail;

  List<Map<String, dynamic>> get todaysTransactionList =>
      _todaysTransactionList;

  List<Map<String, dynamic>> get dailyExpenseAndIncomeLast7DaysList =>
      _dailyExpenseAndIncomeLast7DaysList;

  List<Map<String, dynamic>> get weeklyExpenseAndIncomeList =>
      _weeklyExpenseAndIncomeList;

  List<Map<String, dynamic>> get monthlyExpenseAndIncomeList =>
      _monthlyExpenseAndIncomeList;


  void updateLoadingState(bool? changeValue) {
    loadingBool = changeValue;
    notifyListeners();
  }


  Future<bool> checkConnection() async {
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  String getUsername(){
    _userName = _firestore!
        .collection('users')
        .doc(currentUserEmail)
        .collection("name")
        .snapshots();
    print(_userName);
    return _userName;
  }

  Future<bool> signUP(String? email, String? password, String? name) async {
    updateLoadingState(true);
    if (await checkConnection()) {
      try {
        final newUser = await _firebaseAuth!
            .createUserWithEmailAndPassword(email: email!, password: password!);
        if (newUser != null) {
          currentUserEmail = email;
          createCollection(name);
          // showSnackBar(ContentType.success, "Success", "Successfully SignedUP");
          updateLoadingState(false);
          return true;
        } else {
          updateLoadingState(false);
          // showSnackBar(ContentType.failure, "Failed", "Failed to create user");
          return false;
        }
      } catch (e) {
        updateLoadingState(false);
        // showSnackBar(ContentType.failure, "Failed", "$e");
        return false;
      }
    } else {
      updateLoadingState(false);
      // showSnackBar(ContentType.failure, "Network Error",
      //     "Please check your network connection and try again");
      return false;
    }
  }

  Future<bool> signIN(String? email, String? password) async {
    updateLoadingState(true);
    if (await checkConnection()) {
      try {
        final user = await _firebaseAuth!
            .signInWithEmailAndPassword(email: email!, password: password!);

        if (user != null) {
          currentUserEmail = email;
          // showSnackBar(
          //     ContentType.success, "Success", "Successfully Signed In");
          updateLoadingState(false);
          return true;
        } else {
          updateLoadingState(false);
          // showSnackBar(ContentType.failure, "Failed", "Failed to Sign In");
          return false;
        }
      } catch (e) {
        updateLoadingState(false);
        // showSnackBar(ContentType.failure, "Failed", "$e");
        return false;
      }
    } else {
      updateLoadingState(false);
      // showSnackBar(ContentType.failure, "Network Error",
      //     "Please check your network connection and try again");
      return false;
    }
  }

  void createCollection(String? name) {
    _firestore!.collection('users').doc("$currentUserEmail").set({"name": name});
  }

  void intializeApp() async {
    updateLoadingState(true);
    if (await checkConnection()) {
      try {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: firebaseAPI,
            appId: firebaseAppID,
            messagingSenderId: 'sendid',
            projectId: 'futuregenai',
            storageBucket: 'myapp-b9yt18.appspot.com',
          ),
        );
        _firebaseAuth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        updateLoadingState(false);
      } catch (e) {
        updateLoadingState(false);
        // showSnackBar(ContentType.help, "ServerError",
        //     "There is an internal error for connecting to the server");
      }
    } else {
      updateLoadingState(false);
      // showSnackBar(ContentType.failure, "Network Error",
      //     "Please check your network connection and try again");
    }
  }



  void fetchData() async {
    bool? loadingBool = false;
    _totalMoney = await dbHelper.getTotalMoneyForCurrentMonth();
    _todaysCashIn = await dbHelper
        .getTodaysTotalIncome(); // Replace with actual logic to fetch today's cash in
    _todaysExpense = await dbHelper.getTodaysTotalSpending();
    _todaysTransactionList = await dbHelper.getTodaysExpenses();
    _dailyExpenseAndIncomeLast7DaysList =
        await dbHelper.getWeeklyExpensesAndIncomeForLast7DaysList();
    _dailyExpenseAndIncomeLast7Days =
        await dbHelper.getDailyExpensesAndIncomeForLast7Days();
    _weeklyExpenseAndIncome = await dbHelper.getWeeklyExpensesAndIncome(
        DateTime.now().year, DateTime.now().month);
    _weeklyExpenseAndIncomeList = await dbHelper
        .getWeeklyExpensesAndIncomeList(DateTime.now().year, DateTime.now().month);
    _monthlyExpenseAndIncome = await dbHelper.getMonthlyExpensesAndIncome(DateTime.now().year);
    _monthlyExpenseAndIncomeList = await dbHelper.getMonthlyExpensesAndIncomeList(DateTime.now().year);
    print(_monthlyExpenseAndIncomeList);
    notifyListeners();
  }
  Future<List<Map<String, dynamic>>> monthlyExpenseAndIncome()async{
    return _monthlyExpenseAndIncome;
  }

  Future<List<Map<String, dynamic>>> weeklyExpenseAndIncome()async{
    return _weeklyExpenseAndIncome;
  }

  Future<List<Map<String, dynamic>>> dailyExpenseAndIncomeLast7Days() async {
    return _dailyExpenseAndIncomeLast7Days;
  }




  void addExpense(Expense newExpense) async {
    await dbHelper.insertExpense(newExpense);
    fetchData();
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> expenseList(
      Future<List<Map<String, dynamic>>> inputFunction) async {
    print(inputFunction);
    List<Map<String, dynamic>> expenseList = await inputFunction;
    return expenseList;
  }

  bool? getLoadingBool() {
    return loadingBool;
  }


  Future<double> getMonthlyBalance() async {
    return await dbHelper.getTotalMoneyForCurrentMonth();
  }

  void deleteExpense(String datetime){
    dbHelper.deleteRow(datetime);
    notifyListeners();
  }

  void updateFunction(String datetime, double amount) {}
}
