import 'package:flutter/material.dart';

class SuccessHeader extends StatelessWidget {
  const SuccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        
        // Success icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Success message
        const Text(
          'Booking Successful!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Your booking has been confirmed',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
