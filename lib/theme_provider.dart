import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;

  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.purple),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      );

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
