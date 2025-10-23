import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Login user with email and password
  Future<AuthResponse> login(String email, String password) async {
    try {
      final loginRequest = LoginRequest(email: email, password: password);
      
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.loginEndpoint}'),
        headers: _headers,
        body: json.encode(loginRequest.toJson()),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }

  /// Register new user
  Future<AuthResponse> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final registerRequest = RegisterRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.registerEndpoint}'),
        headers: _headers,
        body: json.encode(registerRequest.toJson()),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Registration failed. Please try again.',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }

  /// Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(password)) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  /// Validate email format
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
