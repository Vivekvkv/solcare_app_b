import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/models/service_model.dart';

class RecentViewedServices extends StatelessWidget {
  final List services;

  const RecentViewedServices({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently Viewed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Clear History',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/service_${service.id}.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                service.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${service.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Create a ServiceModel from Service directly
                            final serviceModel = ServiceModel(
                              id: service.id.toString(),
                              name: service.name,
                              description: 'Detailed description for ${service.name}',
                              shortDescription: 'Short description for ${service.name}',
                              price: service.price,
                              image: 'assets/images/service_${service.id}.jpg',
                              category: service.category,
                              duration: '${service.id % 3 + 1} hours',
                              popularity: service.popularity.toDouble(),
                              discount: service.discount,
                            );
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                  preselectedService: serviceModel,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text('Book'),
                        ),
                      ],
                    ),
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
