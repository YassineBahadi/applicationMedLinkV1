import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUser(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authService = AuthService();
      _user = await authService.getCurrentUser(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}