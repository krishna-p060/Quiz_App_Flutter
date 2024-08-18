
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService with ChangeNotifier {
  String? _token;
  String? _username;

  bool get isAuthenticated => _token != null;
  String get username => _username ?? '';

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/login'),
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['token'];
      _username = username;
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/signup'),
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to sign up');
    }
  }

  void logout() {
    _token = null;
    _username = null;
    notifyListeners();
  }

  String? get token => _token;
}