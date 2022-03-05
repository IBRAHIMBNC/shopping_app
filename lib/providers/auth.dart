import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/models/http-exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? expiryDate;
  String? _userId;
  Timer? _authTime;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        expiryDate != null &&
        expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final extracteData =
        json.decode(prefs.getString('userData')!) as Map<String, Object>;
    final expiryTime = DateTime.parse(extracteData['expiryDate'] as String);
    if (expiryTime.isBefore(DateTime.now())) return false;
    _token = extracteData['token'] as String?;
    _userId = extracteData['userId'] as String?;
    expiryDate = expiryTime;
    notifyListeners();
    autoLogOut();
    return true;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCFv40NhREN6g5ikxCgeOEz9Q5K1iTqYi0';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final decodeResponse = json.decode(response.body);
      if (decodeResponse['error'] != null)
        throw HttpException(messege: decodeResponse['error']['message']);
      _token = decodeResponse['idToken'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(decodeResponse['expiresIn'])));
      _userId = decodeResponse['localId'];
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final loginData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': expiryDate!.toIso8601String()
      });
      prefs.setString('userData', loginData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    expiryDate = null;
    if (_authTime != null) {
      _authTime!.cancel();
      _authTime = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autoLogOut() {
    if (_authTime != null) {
      _authTime!.cancel();
    }
    var expiryTime = expiryDate!.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: expiryTime), logOut);
  }
}
