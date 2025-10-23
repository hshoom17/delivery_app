import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://your-api-endpoint.com/api';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  
  // App Colors - Red-Orange Theme
  static const Color primaryGreen = Color(0xFFFF6B35); // Red-orange primary
  static const Color darkGreen = Color(0xFFE55A2B); // Darker red-orange
  static const Color lightGreen = Color(0xFFFF8A65); // Light red-orange
  static const Color darkGray = Color(0xFF2D3748);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color textGray = Color(0xFF757575);
  static const Color successGreen = Color(0xFF4CAF50); // Keep success green
  static const Color errorRed = Color(0xFFE53E3E);
  static const Color white = Color(0xFFFFFFFF);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, darkGreen],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightGreen, primaryGreen],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFFF4F0),
    ],
  );
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: darkGray,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 15,
    color: textGray,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Spacing
  static const double defaultPadding = 24.0;
  static const double smallPadding = 12.0;
  static const double largePadding = 32.0;
  
  // Border Radius
  static const double defaultRadius = 8.0;
  static const double buttonRadius = 8.0;
  
  // Animation Duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}
