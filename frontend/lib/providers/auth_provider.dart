import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/user.dart'; // Assuming you have a User model

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get token => _token;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  // ==================== LOGIN ====================
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authService = AuthService();
      _token = await authService.login(username, password);

      if (_token != null) {
        // Save token & fetch user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        
        // Load user profile
        _currentUser = await authService.getCurrentUser(_token!);
        
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== REGISTER + AUTO-LOGIN ====================
  Future<bool> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String insuranceNumber,
    required List<String> comorbidities,
    required double weight,
    required double height,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authService = AuthService();
      final success = await authService.register(
        username,
        password,
        firstName,
        lastName,
        dateOfBirth,
        insuranceNumber,
        comorbidities,
        weight,
        height,
      );

      if (success) {
        // Auto-login after successful registration
        return await login(username, password);
      } else {
        _error = 'Registration failed (server error)';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== AUTO-LOGIN (APP START) ====================
  Future<bool> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _token = prefs.getString('token');
    if (_token != null) {
      try {
        final authService = AuthService();
        _currentUser = await authService.getCurrentUser(_token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        _token = null;
        _currentUser = null;
        await prefs.remove('token');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    
    _token = null;
    _currentUser = null;
    _isLoading = false;
    _error = null;
    
    notifyListeners();
  }

  // ==================== CLEAR ERROR ====================
  void clearError() {
    _error = null;
    notifyListeners();
  }
}