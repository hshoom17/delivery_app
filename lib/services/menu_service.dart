import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item_model.dart';
import '../utils/constants.dart';

class MenuService {
  static final MenuService _instance = MenuService._internal();
  factory MenuService() => _instance;
  MenuService._internal();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Get all menu items from the backend
  Future<List<MenuItem>> getMenuItems() async {
    final url = '${AppConstants.baseUrl}${AppConstants.foodsEndpoint}';
    print('[MenuService] Fetching menu items from: $url');
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      print('[MenuService] Response status code: ${response.statusCode}');
      print('[MenuService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print('[MenuService] Parsed response data: $responseData');
          
          // Handle different response formats
          List<dynamic> itemsData;
          if (responseData['data'] != null) {
            itemsData = List<dynamic>.from(responseData['data']);
            print('[MenuService] Found ${itemsData.length} items in "data" key');
          } else if (responseData['foods'] != null) {
            itemsData = List<dynamic>.from(responseData['foods']);
            print('[MenuService] Found ${itemsData.length} items in "foods" key');
          } else {
            print('[MenuService] Warning: No "data" or "foods" key found in response');
            print('[MenuService] Available keys: ${responseData.keys.toList()}');
            itemsData = [];
          }

          if (itemsData.isEmpty) {
            print('[MenuService] No menu items found in response');
            return [];
          }

          // Parse items with error handling for each item
          List<MenuItem> menuItems = [];
          for (int i = 0; i < itemsData.length; i++) {
            try {
              final item = MenuItem.fromJson(itemsData[i]);
              menuItems.add(item);
            } catch (e) {
              print('[MenuService] Error parsing item at index $i: $e');
              print('[MenuService] Item data: ${itemsData[i]}');
            }
          }

          print('[MenuService] Successfully parsed ${menuItems.length} menu items');
          return menuItems;
        } catch (e) {
          print('[MenuService] JSON parsing error: $e');
          print('[MenuService] Raw response body: ${response.body}');
          throw Exception('Failed to parse API response: $e');
        }
      } else {
        final errorMsg = 'API request failed with status ${response.statusCode}';
        print('[MenuService] $errorMsg');
        print('[MenuService] Response body: ${response.body}');
        throw Exception('$errorMsg: ${response.body}');
      }
    } on http.ClientException catch (e) {
      final errorMsg = 'Network error: Unable to reach the server. Please check your connection and ensure the Laravel server is running.';
      print('[MenuService] Network error: $e');
      throw Exception(errorMsg);
    } on FormatException catch (e) {
      final errorMsg = 'Invalid response format from server: $e';
      print('[MenuService] Format error: $e');
      throw Exception(errorMsg);
    } catch (e) {
      final errorMsg = 'Unexpected error loading menu items: $e';
      print('[MenuService] Unexpected error: $e');
      throw Exception(errorMsg);
    }
  }

  /// Get menu items by category (if needed in the future)
  Future<List<MenuItem>> getMenuItemsByCategory(int categoryId) async {
    final url = '${AppConstants.baseUrl}${AppConstants.foodsEndpoint}?category_id=$categoryId';
    print('[MenuService] Fetching menu items by category from: $url');
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      print('[MenuService] Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          
          List<dynamic> itemsData;
          if (responseData['data'] != null) {
            itemsData = List<dynamic>.from(responseData['data']);
          } else if (responseData['foods'] != null) {
            itemsData = List<dynamic>.from(responseData['foods']);
          } else {
            itemsData = [];
          }

          if (itemsData.isEmpty) {
            print('[MenuService] No menu items found for category $categoryId');
            return [];
          }

          // Parse items with error handling
          List<MenuItem> menuItems = [];
          for (int i = 0; i < itemsData.length; i++) {
            try {
              final item = MenuItem.fromJson(itemsData[i]);
              menuItems.add(item);
            } catch (e) {
              print('[MenuService] Error parsing item at index $i: $e');
            }
          }

          return menuItems;
        } catch (e) {
          print('[MenuService] JSON parsing error: $e');
          throw Exception('Failed to parse API response: $e');
        }
      } else {
        final errorMsg = 'API request failed with status ${response.statusCode}';
        print('[MenuService] $errorMsg');
        throw Exception('$errorMsg: ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('[MenuService] Network error: $e');
      throw Exception('Network error: Unable to reach the server. Please check your connection.');
    } catch (e) {
      print('[MenuService] Unexpected error: $e');
      throw Exception('Unexpected error loading menu items by category: $e');
    }
  }
}
