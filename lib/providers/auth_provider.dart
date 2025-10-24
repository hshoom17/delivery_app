import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null && _token != null;

  // Private keys for SharedPreferences
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  /// Initialize auth state from stored data
  Future<void> initializeAuth() async {
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      final token = prefs.getString(_tokenKey);
      
      if (userJson != null && token != null) {
        final userData = json.decode(userJson) as Map<String, dynamic>;
        _user = User.fromJson(userData);
        _token = token;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to initialize authentication');
    } finally {
      _setLoading(false);
    }
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.login(email, password);
      
      if (response.success && response.user != null && response.token != null) {
        _user = response.user;
        _token = response.token;
        
        // Save to SharedPreferences
        await _saveAuthData();
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? 'Login failed');
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      
      if (response.success && response.user != null && response.token != null) {
        _user = response.user;
        _token = response.token;
        
        // Save to SharedPreferences
        await _saveAuthData();
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      // Call logout API if we have a token
      if (_token != null) {
        await _authService.logout(_token!);
      }
      
      // Clear stored data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
      
      // Clear current state
      _user = null;
      _token = null;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to logout');
    } finally {
      _setLoading(false);
    }
  }

  /// Save authentication data to SharedPreferences
  Future<void> _saveAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_user != null) {
        await prefs.setString(_userKey, json.encode(_user!.toJson()));
      }
      if (_token != null) {
        await prefs.setString(_tokenKey, _token!);
      }
    } catch (e) {
      debugPrint('Failed to save auth data: $e');
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error manually (for UI)
  void clearError() {
    _clearError();
  }

  /// Validate email format
  String? validateEmail(String email) {
    return _authService.validateEmail(email);
  }

  /// Validate password strength
  String? validatePassword(String password) {
    return _authService.validatePassword(password);
  }
}
