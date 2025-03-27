import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/providers/cart_provider.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';
import 'package:solcare_app4/utils/image_helper.dart';
import 'package:solcare_app4/screens/service_details/service_details_screen.dart';
import 'package:solcare_app4/screens/services/services_screen.dart'; 
import 'package:solcare_app4/screens/main_screen.dart'; // Add MainScreen import

class FeaturedServicesCarousel extends StatefulWidget {
  final List<ServiceModel> services;
  final bool useCompactLayout;

  const FeaturedServicesCarousel({
    super.key,
    required this.services,
    this.useCompactLayout = false,
  });

  @override
  State<FeaturedServicesCarousel> createState() => _FeaturedServicesCarouselState();
}

class _FeaturedServicesCarouselState extends State<FeaturedServicesCarousel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const isOnline = true;

    if (!isOnline || widget.services.isEmpty) {
      return _buildOfflineFallback();
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
                'Featured Services',
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
        
        // Further reduced height to eliminate overflow
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate card width to ensure exactly 5 cards are visible on larger screens
              double cardWidth;
              if (constraints.maxWidth > 1200) {
                // Extra large screens
                cardWidth = constraints.maxWidth / 5;
              } else if (constraints.maxWidth > 800) {
                // Tablet/larger screens - show 5 cards
                cardWidth = constraints.maxWidth / 4;
              } else if (constraints.maxWidth > 600) {
                // Medium screens
                cardWidth = constraints.maxWidth / 3.2;
              } else {
                // Phone screens
                cardWidth = constraints.maxWidth / (widget.useCompactLayout ? 1.8 : 2.2);
              }
              
              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: widget.services.length,
                itemBuilder: (context, index) {
                  final service = widget.services[index];
                  final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
                  final discount = serviceProvider.getDiscount(service);
                  
                  return FeaturedServiceCard(
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

  Widget _buildOfflineFallback() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off,
            color: Colors.grey,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Featured Services Available – Please Check Your Connection.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class FeaturedServiceCard extends StatelessWidget {
  final ServiceModel service;
  final int discount;
  final double cardWidth;

  const FeaturedServiceCard({
    super.key,
    required this.service,
    required this.discount,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    final serviceColor = ImageHelper.colorFromString(service.name);
    
    // Set fixed card height to completely control dimensions
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Reduced vertical margin
      width: cardWidth,
      height: 180, // Explicitly set card height
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use minimum space needed
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with discount tag - make clickable
            InkWell(
              onTap: () => _navigateToServiceDetails(context),
              child: SizedBox(
                height: 100, // Fixed image height
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    service.image.startsWith('http')
                        ? Image.network(
                            service.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: serviceColor.withOpacity(0.2),
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
                              color: serviceColor.withOpacity(0.2),
                              child: const Icon(
                                Icons.home_repair_service,
                                size: 40,
                                color: Colors.grey,
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
                  // Title
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
