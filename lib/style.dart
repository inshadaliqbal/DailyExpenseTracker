import 'package:flutter/material.dart';



ThemeData buildThemeData() {
  return ThemeData(

      brightness: Brightness.dark,
      primaryColor: Colors.black,
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.redAccent
      )
  );
}

BoxDecoration buildHomePageBoxDecoration() {
  return BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)));
}

InputDecoration MainTextFieldInputDecoration(String? label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(letterSpacing: 3,color: Colors.black),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.black),
      borderRadius: BorderRadius.circular(30),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
  );
}
