import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isVerified = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isVerified => _isVerified;

  Future<void> verifyOtp(String otp) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:3001/auth/verify-otp/675b71ecf6c6c967a17f690f'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'otp': otp}),
      );

      if (response.statusCode == 201) {
        _isVerified = true;
      } else {
        _error = 'Invalid OTP. Please try again.';
      }
    } catch (e) {
      _error = 'Failed to verify OTP. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}