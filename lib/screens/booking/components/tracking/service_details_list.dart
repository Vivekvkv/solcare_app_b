import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';

class ServiceDetailsList extends StatelessWidget {
  final List<ServiceModel> services;

  const ServiceDetailsList({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(service.name),
                subtitle: Text(service.duration),
                trailing: Text(
                  '₹${service.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
