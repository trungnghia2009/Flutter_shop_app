import 'package:flutter/material.dart';
import '../models/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeSet {
  purpleTheme,
  pinkTheme,
  blueTheme,
  darkTheme,
}

class ThemeDefinition {
  final Color primarySwatch;
  final Color accentColor;
  final Color errorColor;
  final Color buttonColor;
  ThemeDefinition({
    @required this.primarySwatch,
    @required this.accentColor,
    @required this.errorColor,
    @required this.buttonColor,
  });
}

class ThemeTypes with ChangeNotifier {
  List<ThemeDefinition> _themeTypes = [
    ThemeDefinition(
      primarySwatch: Colors.purple,
      accentColor: Colors.deepOrange,
      errorColor: Colors.red,
      buttonColor: Colors.purple,
    ),
    ThemeDefinition(
      primarySwatch: Colors.pink,
      accentColor: Colors.blue,
      errorColor: Colors.greenAccent,
      buttonColor: Colors.pink,
    ),
    ThemeDefinition(
      primarySwatch: Colors.blue,
      accentColor: Colors.purple,
      errorColor: Colors.orange,
      buttonColor: Colors.blue,
    ),
  ];

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeValue', _themeValue);
  }

  List<ThemeDefinition> get themeTypes {
    return [..._themeTypes];
  }

  void updateThemeValue(int value) {
    _themeValue = value;
  }

  int _themeValue;

  ThemeTypes(this._themeValue);

  Future<void> setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int temp = prefs.getInt('themeValue') ?? 0;
    _themeValue = temp;
    notifyListeners();
  }

  get getThemeTypeValue {
    return _themeValue;
  }

  void setThemeTypeValue(int value) {
    _themeValue = value;
    notifyListeners();
  }

  ThemeDefinition getTheme() {
    return _themeTypes[_themeValue];
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      accentColor: Colors.deepOrange,
      buttonColor: Colors.white,
    );
  }
}
