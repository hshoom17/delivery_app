import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/menu_item_model.dart';
import '../utils/constants.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onAddToCart;
  final int quantityInCart;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.onAddToCart,
    this.quantityInCart = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.defaultRadius),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: menuItem.imageUrl != null && menuItem.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: menuItem.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppConstants.lightGray,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppConstants.lightGray,
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: AppConstants.textGray,
                          size: 40,
                        ),
                      ),
                    )
                  : Container(
                      color: AppConstants.lightGray,
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: AppConstants.textGray,
                        size: 40,
                      ),
                    ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  menuItem.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.darkGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // Description
                if (menuItem.description.isNotEmpty)
                  Text(
                    menuItem.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppConstants.textGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                const SizedBox(height: 8),
                
                // Price and Add Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      '\$${menuItem.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryGreen,
                      ),
                    ),
                    
                    // Add Button
                    GestureDetector(
                      onTap: menuItem.available ? onAddToCart : null,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: menuItem.available 
                              ? AppConstants.primaryGreen 
                              : AppConstants.textGray,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          quantityInCart > 0 ? Icons.check : Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Quantity indicator
                if (quantityInCart > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$quantityInCart in cart',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
