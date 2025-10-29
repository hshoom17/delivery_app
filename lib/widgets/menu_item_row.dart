import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/menu_item_model.dart';
import '../utils/constants.dart';

class MenuItemRow extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onAddToCart;
  final int quantityInCart;

  const MenuItemRow({
    super.key,
    required this.menuItem,
    required this.onAddToCart,
    this.quantityInCart = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        border: Border.all(
          color: AppConstants.primaryGreen.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGreen.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 70,
              height: 70,
              child: menuItem.imageUrl != null && menuItem.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: menuItem.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppConstants.lightGray,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppConstants.primaryGreen,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppConstants.lightGray,
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: AppConstants.textGray,
                          size: 28,
                        ),
                      ),
                    )
                  : Container(
                      color: AppConstants.lightGray,
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: AppConstants.textGray,
                        size: 28,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Item name and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuItem.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: menuItem.available
                        ? AppConstants.darkGray
                        : AppConstants.textGray,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${menuItem.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: menuItem.available
                        ? AppConstants.primaryGreen
                        : AppConstants.textGray,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Quantity display and Add button
          if (quantityInCart > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quantity badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$quantityInCart',
                    style: TextStyle(
                      color: AppConstants.primaryGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          
          // Add button (+)
          GestureDetector(
            onTap: menuItem.available ? onAddToCart : null,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: menuItem.available
                    ? AppConstants.primaryGreen
                    : AppConstants.lightGray,
                borderRadius: BorderRadius.circular(20),
                boxShadow: menuItem.available
                    ? [
                        BoxShadow(
                          color: AppConstants.primaryGreen.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

