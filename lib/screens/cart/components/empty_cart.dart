import 'package:flutter/material.dart';
import 'package:solcare_app4/screens/services/services_screen.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty cart image
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey[300],
            ),
            
            const SizedBox(height: 24),
            
            // Empty cart message
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Explore our services and add items to your cart',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Explore services button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServicesScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Explore Services'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
