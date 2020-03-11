import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _email;
  Timer _authTimer;
  DateTime _loginDate;

  // TODO: If we had a token and the token didn't expire
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get email {
    return _email;
  }

  DateTime get loginDate {
    return _loginDate;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCg9qng5l5x6zQjXueX4LG6bV_0btCOhPM';
    try {
      final respond = urlSegment == 'update'
          ? await http.post(url,
              body: json.encode({
                'idToken': _token,
                'password': password,
                'returnSecureToken': true,
              }))
          : await http.post(url,
              body: json.encode({
                'email': email,
                'password': password,
                'returnSecureToken': true,
              }));
      final respondData = json.decode(respond.body);
      if (respondData['error'] != null) {
        throw HttpException(message: respondData['error']['message']);
      }
      _token = respondData['idToken'];
      _userId = respondData['localId'];
      _email = respondData['email'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(respondData['expiresIn']),
        ),
      );
      print(
          'Token: $_token\nemail: $_email\nUserId: $_userId\nExpiresIn: ${respondData['expiresIn'].toString()}');
      _autoLogout();
      notifyListeners();
      // TODO: add shared preferences for storing login data
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'email': _email,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
      _loginDate = DateTime.now();
      print('Hey-----------------------------');
      print('Token: $_token\n'
          'email: $_email\nUserId: $_userId\nExpiresIn: ${respondData['expiresIn'].toString()}');
    } catch (error) {
      // TODO: if not internet connection
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> changePassword(String token, String password) async {
    return _authenticate(email, password, 'update');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 2));
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _email = extractedUserData['email'];
    _expiryDate = expiryDate;
    _loginDate = DateTime.now();
    notifyListeners();
    _autoLogout();
    print(
        'Token: $_token\nemail: $_email\nUserId: $_userId\nExpiresIn: $_expiryDate');
    return true;
  }

  Future<void> logout() async {
    print('logout ...');
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final currentThemeValue = prefs.getInt('themeValue');
    if (currentThemeValue == null) {
      prefs.setInt('themeValue', 0);
    }
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
