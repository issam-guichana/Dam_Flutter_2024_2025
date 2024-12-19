import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _token;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get errorMessage => _errorMessage;

  String? _error;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint('Attempting to log in...');
    debugPrint('Email: $email');
    debugPrint('Password: $password'); // Be cautious with sensitive data like passwords.

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint('Response received. Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      _isLoading = false;

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        debugPrint('Login successful. Token: ${responseBody['token']}');
        _token = responseBody['accessToken'];
        notifyListeners();
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        _errorMessage = errorResponse['message'] ?? 'Login failed';
        debugPrint('Login failed. Error message: $_errorMessage');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred: ${e.toString()}';
      debugPrint('Exception caught: $_errorMessage');
      notifyListeners();
      return false;
    }
  }
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      _isLoading = false;

      if (response.statusCode == 201) {
        // Successful signup
        notifyListeners();
        return true;
      } else {
        // Handle error response
        final responseBody = json.decode(response.body);
        _errorMessage = responseBody['message'] ?? 'Signup failed';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Network error. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    debugPrint('Logging out...');
    _token = null;
    _errorMessage = null;
    notifyListeners();
    debugPrint('Logged out successfully.');
  }
  Future<bool> forgotPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      _isLoading = false;

      if (response.statusCode == 201) {
        notifyListeners();
        return true;
      } else {
        _error = json.decode(response.body)['message'] ?? 'Failed to process request';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Connection error occurred';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
