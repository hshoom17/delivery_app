import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
  // 
  // IMPORTANT: Configure the baseUrl based on your testing environment:
  //
  // 1. Android Emulator: Use 'http://10.0.2.2:8000/api'
  //    - 10.0.2.2 is a special alias that points to localhost on your host machine
  //
  // 2. iOS Simulator: Use 'http://localhost:8000/api' or 'http://127.0.0.1:8000/api'
  //
  // 3. Physical Device (Android/iOS): Use your computer's IP address
  //    - Find your IP: Windows (ipconfig), Mac/Linux (ifconfig)
  //    - Format: 'http://192.168.1.X:8000/api' (replace X with your IP)
  //    - Ensure your phone and computer are on the same WiFi network
  //    - Ensure your firewall allows connections on port 8000
  //
  // 4. Laravel Server Setup:
  //    - Make sure Laravel is running: php artisan serve
  //    - Default Laravel port is 8000
  //    - Verify CORS is configured in config/cors.php
  //    - Test the API endpoint: http://[your-base-url]/api/foods
  //
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Auth Endpoints
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String logoutEndpoint = '/logout';
  static const String userEndpoint = '/user';
  
  // Restaurant Endpoints
  static const String restaurantsEndpoint = '/restaurants';
  
  // Food Endpoints
  static const String foodsEndpoint = '/foods';
  
  // Order Endpoints
  static const String ordersEndpoint = '/orders';
  
  // Category Endpoints
  static const String categoriesEndpoint = '/categories';
  
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
