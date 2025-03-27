import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final double totalAmount;
  final int itemCount;
  final int rewardPoints;

  const CartSummary({
    super.key,
    required this.totalAmount,
    required this.itemCount,
    required this.rewardPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal ($itemCount ${itemCount == 1 ? 'item' : 'items'})',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            Text(
              '₹${totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Service Fee',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const Text(
              '₹0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '₹${totalAmount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.stars,
              size: 16,
              color: Colors.amber,
            ),
            const SizedBox(width: 4),
            Text(
              'You\'ll earn $rewardPoints reward points with this order',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
