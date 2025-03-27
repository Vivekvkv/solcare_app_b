import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/components/service_card.dart';
import 'package:solcare_app4/screens/services/components/service_card_shimmer.dart';

class HorizontalServiceList extends StatelessWidget {
  final String title;
  final List<ServiceModel> services;
  final IconData icon;
  final bool isLoading;

  const HorizontalServiceList({
    super.key,
    required this.title,
    required this.services,
    required this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty && !isLoading) {
      return const SizedBox.shrink(); // Don't show empty sections
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 180,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ServiceCard(service: services[index]),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ServiceCardShimmer(),
          ),
        );
      },
    );
  }
}
