import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'service_card.dart';

class LocationBasedSuggestionsSection extends StatelessWidget {
  final List<ServiceModel> services;

  const LocationBasedSuggestionsSection({
    Key? key,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Popular in Your Area',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 170,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ServiceCard(service: services[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
