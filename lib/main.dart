import 'package:flutter/material.dart';
import 'package:expenses_tracker/expenses.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 96, 59, 101));
var kDarkColorScheme = ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 5, 99, 125), brightness: Brightness.dark);

void main() => runApp(ExpenseTracker());

class ExpenseTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker App',
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,

        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.onSecondaryContainer,
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      home: Expenses(),
    );
  }
}