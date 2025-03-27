import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final String bookingId;
  final VoidCallback onTrackService;
  final VoidCallback onBackToHome;

  const ActionButtons({
    super.key,
    required this.bookingId,
    required this.onTrackService,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Track Service button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onTrackService,
            icon: const Icon(Icons.location_on),
            label: const Text('Track Service'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Back to Home button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onBackToHome,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Back to Home'),
          ),
        ),
      ],
    );
  }
}
