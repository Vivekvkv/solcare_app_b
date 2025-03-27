import 'package:flutter/material.dart';

class ServiceDescription extends StatelessWidget {
  final String description;

  const ServiceDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this service',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
