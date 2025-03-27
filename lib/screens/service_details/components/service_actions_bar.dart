import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';

class ServiceActionsBar extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onAddToCart;
  final VoidCallback onBookNow;

  const ServiceActionsBar({
    super.key,
    required this.service,
    required this.onAddToCart,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Add to Cart'),
              onPressed: onAddToCart,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Book Now'),
              onPressed: onBookNow,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
