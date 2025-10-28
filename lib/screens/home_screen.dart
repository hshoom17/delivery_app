import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/cart_item_row.dart';
import '../widgets/empty_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _notesController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load menu items when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MenuProvider>(context, listen: false).loadMenuItems();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CartBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: cartProvider.isEmpty ? null : _showCartBottomSheet,
                    icon: const Icon(Icons.shopping_cart),
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppConstants.errorRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartProvider.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<MenuProvider>(
        builder: (context, menuProvider, child) {
          if (menuProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryGreen,
              ),
            );
          }

          if (menuProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppConstants.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    menuProvider.errorMessage!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppConstants.errorRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => menuProvider.loadMenuItems(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (menuProvider.availableItems.isEmpty) {
            return const EmptyState(
              icon: Icons.restaurant_menu,
              title: 'No Menu Items',
              subtitle: 'Menu items are not available at the moment.',
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: menuProvider.availableItems.length,
            itemBuilder: (context, index) {
              final menuItem = menuProvider.availableItems[index];
              return Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return MenuItemCard(
                    menuItem: menuItem,
                    quantityInCart: cartProvider.getItemQuantity(menuItem),
                    onAddToCart: () => cartProvider.addItem(menuItem),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) return const SizedBox.shrink();
          
          return FloatingActionButton.extended(
            onPressed: _showCartBottomSheet,
            backgroundColor: AppConstants.primaryGreen,
            icon: const Icon(Icons.shopping_cart),
            label: Text('${cartProvider.itemCount}'),
          );
        },
      ),
    );
  }
}

class CartBottomSheet extends StatefulWidget {
  const CartBottomSheet({super.key});

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize notes with existing cart notes
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    _notesController.text = cartProvider.orderNotes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to place an order'),
          backgroundColor: AppConstants.errorRed,
        ),
      );
      return;
    }

    // Update notes
    cartProvider.setOrderNotes(_notesController.text.trim());

    final result = await cartProvider.placeOrder(authProvider.token!);

    if (mounted) {
      Navigator.pop(context); // Close bottom sheet
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] 
              ? AppConstants.successGreen 
              : AppConstants.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppConstants.lightGray,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Title
                    const Text(
                      'Your Order',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGray,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Cart items
                    Expanded(
                      child: cartProvider.isEmpty
                          ? const EmptyState(
                              icon: Icons.shopping_cart_outlined,
                              title: 'Your cart is empty',
                              subtitle: 'Add some items from the menu to get started.',
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: cartProvider.cartItems.length,
                              itemBuilder: (context, index) {
                                final cartItem = cartProvider.cartItems[index];
                                return CartItemRow(
                                  cartItem: cartItem,
                                  onIncrease: () => cartProvider.increaseQuantity(cartItem.menuItem),
                                  onDecrease: () => cartProvider.decreaseQuantity(cartItem.menuItem),
                                  onRemove: () => cartProvider.removeItem(cartItem.menuItem),
                                );
                              },
                            ),
                    ),
                    
                    if (!cartProvider.isEmpty) ...[
                      const SizedBox(height: 20),
                      
                      // Notes field
                      CustomTextField(
                        label: 'Special Instructions (Optional)',
                        hint: 'Any special requests for your order?',
                        icon: Icons.note_outlined,
                        controller: _notesController,
                        keyboardType: TextInputType.multiline,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Total and Place Order
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppConstants.lightGray,
                          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total (${cartProvider.itemCount} items)',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppConstants.textGray,
                                  ),
                                ),
                                Text(
                                  '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstants.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                            CustomButton(
                              text: 'Place Order',
                              onPressed: cartProvider.isLoading ? null : _placeOrder,
                              isLoading: cartProvider.isLoading,
                              width: 140,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
