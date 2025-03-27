import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';

class ServicePriceInfo extends StatelessWidget {
  final ServiceModel service;

  const ServicePriceInfo({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '₹${service.price.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.access_time,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          service.duration,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
