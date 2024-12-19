import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> resetPassword(String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/auth/reset-password/675b71ecf6c6c967a17f690f'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'password': password}),
      );

      _isLoading = false;

      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        _error = json.decode(response.body)['message'] ?? 'Failed to reset password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Network error occurred';
      notifyListeners();
      return false;
    }
  }
}