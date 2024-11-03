import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // Getters
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  // Method to handle sign in
  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();
    // Implement sign-in logic here
    // Update _isLoading and notifyListeners() accordingly
  }

  // Method to update email and password
  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }
}
