import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';

class ServicesSummary extends StatelessWidget {
  final List<ServiceModel> services;

  const ServicesSummary({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (services.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Your cart is empty. Please add services to book.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        if (services.isNotEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: services.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(services[index].image),
                    radius: 20,
                  ),
                  title: Text(services[index].name),
                  subtitle: Text(services[index].duration),
                  trailing: Text(
                    '₹${services[index].price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
