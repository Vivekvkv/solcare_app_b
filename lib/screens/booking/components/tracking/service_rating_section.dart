import 'package:flutter/material.dart';

class ServiceRatingSection extends StatelessWidget {
  const ServiceRatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'How was your experience?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to rating screen or show rating dialog
            showDialog(
              context: context,
              builder: (ctx) => const AlertDialog(
                title: Text('Feature Coming Soon'),
                content: Text('Rating and review functionality will be available in the next update.'),
              ),
            );
          },
          icon: const Icon(Icons.star_border),
          label: const Text('Rate this service'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }
}
