import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/models/cart_item_model.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/providers/cart_provider.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItemModel> cartItems;
  final double Function(ServiceModel) getAdjustedPrice;

  const CartItemsList({
    super.key,
    required this.cartItems,
    required this.getAdjustedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        final adjustedPrice = getAdjustedPrice(item.service);
        final originalPrice = item.service.price;
        final bool isPriceAdjusted = adjustedPrice != originalPrice;
        
        return Dismissible(
          key: Key(item.service.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            margin: const EdgeInsets.only(bottom: 12),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Remove Item'),
                content: Text('Remove ${item.service.name} from your cart?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            Provider.of<CartProvider>(context, listen: false)
                .removeItem(item.service.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item.service.name} removed from cart'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(item.service);
                  },
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Top row with service name and remove button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: item.service.image.startsWith('http')
                              ? Image.network(
                                  item.service.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  ),
                                )
                              : Image.asset(
                                  item.service.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Service details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.service.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.service.duration,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (isPriceAdjusted) ...[
                              Row(
                                children: [
                                  Text(
                                    '₹${originalPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '₹${adjustedPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Text(
                                '₹${adjustedPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Remove button - positioned at the top right
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Remove Item'),
                              content: Text('Remove ${item.service.name} from your cart?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Provider.of<CartProvider>(context, listen: false)
                                        .removeItem(item.service.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${item.service.name} removed from cart'),
                                      ),
                                    );
                                  },
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                        color: Colors.red[400],
                        iconSize: 20,
                        tooltip: 'Remove item',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  const Divider(),
                  
                  // Bottom row with quantity controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isPriceAdjusted)
                        Expanded(
                          child: Text(
                            'Price adjusted for your system size',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      
                      // Quantity controls
                      Row(
                        children: [
                          const Text('Quantity: ', style: TextStyle(fontSize: 13)),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (item.quantity > 1) {
                                Provider.of<CartProvider>(context, listen: false)
                                    .decreaseQuantity(item.service.id);
                              } else {
                                // Show confirmation dialog for last item
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Remove Item'),
                                    content: Text('Remove ${item.service.name} from your cart?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Provider.of<CartProvider>(context, listen: false)
                                              .removeItem(item.service.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${item.service.name} removed from cart'),
                                            ),
                                          );
                                        },
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItem(item.service);
                            },
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
