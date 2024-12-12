import 'package:flutter/material.dart';
import 'package:flutter_application_dam/Models/UserModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3001/user'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        _users = jsonResponse.map((userJson) => User.fromJson(userJson)).toList();
      } else {
        _error = 'Failed to load users. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.patch(
        Uri.parse('http://10.0.2.2:3001/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization headers if required
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // Update the user in the local list
        final index = _users.indexWhere((user) => user.id == userId);
        if (index != -1) {
          // Update local user data
          _users[index] = User(
            id: userId,
            name: userData['name'] ?? _users[index].name,
            email: userData['email'] ?? _users[index].email,
            roleId: _users[index].roleId,  // Preserve existing role
          );
          notifyListeners();
        }

        // Optionally refetch users to ensure latest data
        await fetchUsers();
      } else {
        throw Exception('Échec de la mise à jour de l\'utilisateur: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3001/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Remove the user from the local list
        _users.removeWhere((user) => user.id == userId);
        notifyListeners();
      } else {
        throw Exception('Échec de la suppression de l\'utilisateur: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}