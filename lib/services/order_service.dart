import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_item_model.dart';
import '../utils/constants.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Place a new order
  Future<Map<String, dynamic>> placeOrder({
    required List<OrderItem> items,
    required double totalPrice,
    String? notes,
    required String token,
  }) async {
    try {
      final orderData = {
        'items': items.map((item) => item.toJson()).toList(),
        'total_price': totalPrice,
        'notes': notes ?? '',
      };

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.ordersEndpoint}'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
        body: json.encode(orderData),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Order placed successfully!',
          'order_id': responseData['order_id'] ?? responseData['id'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to place order. Please try again.',
        };
      }
    } catch (e) {
      print('Error placing order: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
      };
    }
  }

  /// Get order history (if needed in the future)
  Future<List<Map<String, dynamic>>> getOrderHistory(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.ordersEndpoint}'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        List<dynamic> ordersData;
        if (responseData['data'] != null) {
          ordersData = List<dynamic>.from(responseData['data']);
        } else if (responseData['orders'] != null) {
          ordersData = List<dynamic>.from(responseData['orders']);
        } else {
          ordersData = [];
        }

        return ordersData.cast<Map<String, dynamic>>();
      } else {
        print('Failed to load order history: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading order history: $e');
      return [];
    }
  }
}
