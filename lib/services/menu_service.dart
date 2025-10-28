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
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.foodsEndpoint}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Handle different response formats
        List<dynamic> itemsData;
        if (responseData['data'] != null) {
          itemsData = List<dynamic>.from(responseData['data']);
        } else if (responseData['foods'] != null) {
          itemsData = List<dynamic>.from(responseData['foods']);
        } else {
          itemsData = [];
        }

        return itemsData.map((item) => MenuItem.fromJson(item)).toList();
      } else {
        print('Failed to load menu items: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading menu items: $e');
      return [];
    }
  }

  /// Get menu items by category (if needed in the future)
  Future<List<MenuItem>> getMenuItemsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.foodsEndpoint}?category_id=$categoryId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        List<dynamic> itemsData;
        if (responseData['data'] != null) {
          itemsData = List<dynamic>.from(responseData['data']);
        } else if (responseData['foods'] != null) {
          itemsData = List<dynamic>.from(responseData['foods']);
        } else {
          itemsData = [];
        }

        return itemsData.map((item) => MenuItem.fromJson(item)).toList();
      } else {
        print('Failed to load menu items by category: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading menu items by category: $e');
      return [];
    }
  }
}
