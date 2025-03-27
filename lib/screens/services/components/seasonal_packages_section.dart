import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';
import 'package:solcare_app4/models/service_model.dart';

class SeasonalPackagesSection extends StatelessWidget {
  final List packages;

  const SeasonalPackagesSection({
    super.key,
    required this.packages,
  });

  @override
  Widget build(BuildContext context) {
    final currentSeason = _getCurrentSeason();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getSeasonIcon(currentSeason),
                color: Colors.amber.shade800,
              ),
              const SizedBox(width: 8),
              Text(
                '$currentSeason Packages',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Special maintenance packages to keep your solar system in prime condition',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          
          // Packages grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              
              return GestureDetector(
                onTap: () {
                  // Create a ServiceModel from Service directly
                  final serviceModel = ServiceModel(
                    id: package.id.toString(),
                    name: package.name,
                    description: 'Detailed description for ${package.name}',
                    shortDescription: 'Short description for ${package.name}',
                    price: package.price,
                    image: 'assets/images/service_${package.id}.jpg',
                    category: package.category,
                    duration: '${package.id % 3 + 1} hours',
                    popularity: package.popularity.toDouble(),
                    discount: package.discount,
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
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Package details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Save ${package.discount}%',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '₹${package.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Book button
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Create a ServiceModel from Service directly
                              final serviceModel = ServiceModel(
                                id: package.id.toString(),
                                name: package.name,
                                description: 'Detailed description for ${package.name}',
                                shortDescription: 'Short description for ${package.name}',
                                price: package.price,
                                image: 'assets/images/service_${package.id}.jpg',
                                category: package.category,
                                duration: '${package.id % 3 + 1} hours',
                                popularity: package.popularity.toDouble(),
                                discount: package.discount,
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
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: const Text('Book'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  String _getCurrentSeason() {
    final now = DateTime.now();
    final month = now.month;
    
    // Simple season determination based on month
    if (month >= 3 && month <= 5) return 'Spring';
    if (month >= 6 && month <= 8) return 'Summer';
    if (month >= 9 && month <= 11) return 'Autumn';
    return 'Winter';
  }
  
  IconData _getSeasonIcon(String season) {
    switch (season) {
      case 'Spring': return Icons.eco;
      case 'Summer': return Icons.wb_sunny;
      case 'Autumn': return Icons.spa;  // Changed from Icons.leaves which doesn't exist
      case 'Winter': return Icons.ac_unit;
      default: return Icons.calendar_today;
    }
  }
}
