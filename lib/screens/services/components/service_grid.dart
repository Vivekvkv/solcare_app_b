import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/components/service_card.dart';

class ServiceGrid extends StatelessWidget {
  final List<ServiceModel> services;

  const ServiceGrid({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) => ServiceCard(service: services[index]),
      ),
    );
  }
}
