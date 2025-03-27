import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';

class ServiceHeader extends StatelessWidget {
  final ServiceModel service;

  const ServiceHeader({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            service.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Chip(
          label: Text(service.category),
          backgroundColor: 
              Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
