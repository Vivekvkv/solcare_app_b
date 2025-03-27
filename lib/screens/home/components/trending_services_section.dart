import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/services_screen.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';
import 'package:solcare_app4/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:solcare_app4/screens/service_details/service_details_screen.dart';
import 'package:solcare_app4/screens/main_screen.dart'; // Add MainScreen import

class TrendingServicesSection extends StatefulWidget {
  final List<ServiceModel> trendingServices;
  final bool useCompactLayout;

  const TrendingServicesSection({
    super.key,
    required this.trendingServices,
    this.useCompactLayout = false,
  });

  @override
  State<TrendingServicesSection> createState() => _TrendingServicesSectionState();
}

class _TrendingServicesSectionState extends State<TrendingServicesSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.trendingServices.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // This helps avoid unnecessary height
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('View All'),
                onPressed: () {
                  // Instead of pushing a new screen, navigate to services tab
                  MainScreen.navigateToServicesTab(context);
                },
              ),
            ],
          ),
        ),
        
        // Using the same height as featured services for consistency
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate card width similar to featured services section
              double cardWidth;
              if (constraints.maxWidth > 1200) {
                cardWidth = constraints.maxWidth / 5;
              } else if (constraints.maxWidth > 800) {
                cardWidth = constraints.maxWidth / 4;
              } else if (constraints.maxWidth > 600) {
                cardWidth = constraints.maxWidth / 3.2;
              } else {
                cardWidth = constraints.maxWidth / (widget.useCompactLayout ? 1.8 : 2.2);
              }
              
              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: widget.trendingServices.length,
                itemBuilder: (context, index) {
                  final service = widget.trendingServices[index];
                  // Create mock discount data (alternating between different values)
                  final discount = 10 + (index % 3) * 5; // 10%, 15%, 20%
                  
                  return TrendingServiceCard(
                    service: service,
                    discount: discount,
                    cardWidth: cardWidth,
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'No trending services available right now',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class TrendingServiceCard extends StatelessWidget {
  final ServiceModel service;
  final int discount;
  final double cardWidth;

  const TrendingServiceCard({
    super.key,
    required this.service,
    required this.discount,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: cardWidth,
      height: 180, // Fixed height to prevent overflow
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2, // Same elevation as featured cards
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with tags - make clickable
            InkWell(
              onTap: () => _navigateToServiceDetails(context),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Service image
                    service.image.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: service.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.home_repair_service,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Image.asset(
                          service.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.home_repair_service,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    
                    // Trending badge
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.trending_up, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Trending',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Display discount tag only if there's a discount
                    if (discount > 0)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            '$discount% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                    // Rating badge removed as requested
                  ],
                ),
              ),
            ),

            // Content area
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service title
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Price row
                  Row(
                    children: [
                      if (discount > 0)
                        Text(
                          '₹${(service.price + (service.price * discount / 100)).toStringAsFixed(0)}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      if (discount > 0) const SizedBox(width: 4),
                      Text(
                        'Starting from',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '₹${service.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '/1KW',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Button area - now with Read More and Book Now buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // Read More button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _navigateToServiceDetails(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        minimumSize: const Size(0, 30),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Read More',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 4), // Small gap between buttons
                  
                  // Book Now button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _navigateToBooking(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        minimumSize: const Size(0, 30),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to navigate to service details
  void _navigateToServiceDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsScreen(serviceId: service.id),
      ),
    );
  }

  // Helper method to navigate to booking screen
  void _navigateToBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(preselectedService: service),
      ),
    );
  }
}
