import 'package:flutter/material.dart';

class ThemeType {
  final Color primarySwatch;
  final Color accentColor;
  final Color errorColor;
  ThemeType({
    @required this.primarySwatch,
    @required this.accentColor,
    @required this.errorColor,
  });
}

class ThemeTypes with ChangeNotifier {
  List<ThemeType> _themeTypes = [
    ThemeType(
      primarySwatch: Colors.purple,
      accentColor: Colors.deepOrange,
      errorColor: Colors.red,
    ),
    ThemeType(
      primarySwatch: Colors.pink,
      accentColor: Colors.blue,
      errorColor: Colors.greenAccent,
    ),
    ThemeType(
      primarySwatch: Colors.blue,
      accentColor: Colors.purple,
      errorColor: Colors.orange,
    ),
  ];

  List<ThemeType> get themeTypes {
    return [..._themeTypes];
  }

  int _themeTypeValue = 0;
  int get getThemeTypeValue {
    return _themeTypeValue;
  }

  void setThemeTypeValue(int value) {
    _themeTypeValue = value;
    notifyListeners();
  }

  void changeThemeTypeValue(int value) {
    _themeTypeValue = value;
    notifyListeners();
  }

  ThemeType getTheme() {
    return _themeTypes[_themeTypeValue];
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      accentColor: Colors.deepOrange,
    );
  }
}
