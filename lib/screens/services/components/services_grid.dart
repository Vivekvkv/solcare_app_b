import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/components/service_card.dart';

class ServicesGrid extends StatelessWidget {
  final List<ServiceModel> services;

  const ServicesGrid({
    Key? key,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No services found matching your criteria',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Get screen width to determine number of columns
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;
    
    if (width < 600) {
      crossAxisCount = 2; // Mobile - show 2 columns for more density
      childAspectRatio = 0.6; // Taller cards for mobile view
    } else if (width < 900) {
      crossAxisCount = 3; // Tablet - 3 columns
      childAspectRatio = 0.7;
    } else {
      crossAxisCount = 4; // Desktop - 4 columns
      childAspectRatio = 0.8;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return ServiceCard(service: services[index]);
      },
    );
  }
}
