import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cart_item_model.dart';
import '../utils/constants.dart';

class CartItemRow extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemRow({
    super.key,
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        border: Border.all(color: AppConstants.lightGray),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 60,
              child: cartItem.menuItem.imageUrl != null && cartItem.menuItem.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: cartItem.menuItem.imageUrl!,
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
                          size: 24,
                        ),
                      ),
                    )
                  : Container(
                      color: AppConstants.lightGray,
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: AppConstants.textGray,
                        size: 24,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.menuItem.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.darkGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  '\$${cartItem.menuItem.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppConstants.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity controls
          Row(
            children: [
              // Decrease button
              GestureDetector(
                onTap: onDecrease,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppConstants.lightGray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: AppConstants.darkGray,
                    size: 18,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Quantity
              Text(
                '${cartItem.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.darkGray,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Increase button
              GestureDetector(
                onTap: onIncrease,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 8),
          
          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.delete_outline,
                color: AppConstants.errorRed,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
