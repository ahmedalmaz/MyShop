import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myshop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> authenticate(
      String email, String password, String method) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=AIzaSyD_oSC9RAwdmu6rsSEKwpVX2CHJV7vsA4Q');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']['message']);
      }
      _token = extractedData['idToken'];
      _userId = extractedData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(extractedData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
          {'token': _token, 'userId': userId, 'expiryDate': _expiryDate.toIso8601String()});
      prefs.setString('userData', userData);

      // print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }
  Future<bool> tryLogIn() async{
    final prefs= await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedData=json.decode(prefs.getString('userData')) as Map <String , Object>;
    final expiryTime=DateTime.parse(extractedData['expiryDate']);

    if (expiryTime.isBefore(DateTime.now())){
      return false;
    }
    _token=extractedData['token'];
    _userId=extractedData['userId'];
    _expiryDate=expiryTime;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs= await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }
}
