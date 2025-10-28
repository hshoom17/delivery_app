import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_item_model.dart';
import '../services/order_service.dart';

class CartProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _orderNotes;

  // Getters
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get orderNotes => _orderNotes;
  bool get isEmpty => _cartItems.isEmpty;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Add item to cart
  void addItem(MenuItem menuItem) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );

    if (existingItemIndex >= 0) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(CartItem(menuItem: menuItem, quantity: 1));
    }
    notifyListeners();
  }

  /// Remove item from cart
  void removeItem(MenuItem menuItem) {
    _cartItems.removeWhere((item) => item.menuItem.id == menuItem.id);
    notifyListeners();
  }

  /// Update item quantity
  void updateQuantity(MenuItem menuItem, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItem);
      return;
    }

    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );

    if (existingItemIndex >= 0) {
      _cartItems[existingItemIndex].quantity = quantity;
      notifyListeners();
    }
  }

  /// Increase item quantity
  void increaseQuantity(MenuItem menuItem) {
    addItem(menuItem);
  }

  /// Decrease item quantity
  void decreaseQuantity(MenuItem menuItem) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );

    if (existingItemIndex >= 0) {
      if (_cartItems[existingItemIndex].quantity > 1) {
        _cartItems[existingItemIndex].quantity--;
      } else {
        _cartItems.removeAt(existingItemIndex);
      }
      notifyListeners();
    }
  }

  /// Get quantity of specific item in cart
  int getItemQuantity(MenuItem menuItem) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );
    return existingItemIndex >= 0 ? _cartItems[existingItemIndex].quantity : 0;
  }

  /// Check if item is in cart
  bool isItemInCart(MenuItem menuItem) {
    return _cartItems.any((item) => item.menuItem.id == menuItem.id);
  }

  /// Clear cart
  void clearCart() {
    _cartItems.clear();
    _orderNotes = null;
    notifyListeners();
  }

  /// Set order notes
  void setOrderNotes(String? notes) {
    _orderNotes = notes;
    notifyListeners();
  }

  /// Place order
  Future<Map<String, dynamic>> placeOrder(String token) async {
    if (_cartItems.isEmpty) {
      return {
        'success': false,
        'message': 'Cart is empty',
      };
    }

    _setLoading(true);
    _clearError();

    try {
      // Convert cart items to order items
      final orderItems = _cartItems.map((cartItem) => OrderItem(
        foodId: cartItem.menuItem.id,
        quantity: cartItem.quantity,
        price: cartItem.menuItem.price,
      )).toList();

      final result = await _orderService.placeOrder(
        items: orderItems,
        totalPrice: totalPrice,
        notes: _orderNotes,
        token: token,
      );

      if (result['success']) {
        // Clear cart on successful order
        clearCart();
      }

      return result;
    } catch (e) {
      _setError('Failed to place order: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    } finally {
      _setLoading(false);
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
