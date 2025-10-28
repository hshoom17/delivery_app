import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../services/menu_service.dart';

class MenuProvider extends ChangeNotifier {
  final MenuService _menuService = MenuService();
  
  List<MenuItem> _menuItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<MenuItem> get menuItems => _menuItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<MenuItem> get availableItems => _menuItems.where((item) => item.available).toList();

  /// Load menu items from the backend
  Future<void> loadMenuItems() async {
    _setLoading(true);
    _clearError();

    try {
      final items = await _menuService.getMenuItems();
      _menuItems = items;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load menu items: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh menu items
  Future<void> refreshMenuItems() async {
    await loadMenuItems();
  }

  /// Get menu item by ID
  MenuItem? getMenuItemById(int id) {
    try {
      return _menuItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
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
}
