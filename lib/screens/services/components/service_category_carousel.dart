import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/components/service_card.dart';
import 'package:solcare_app4/screens/service_details/service_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/cart_provider.dart';

class ServiceCategoryCarousel extends StatefulWidget {
  final String title;
  final List<ServiceModel> services;

  const ServiceCategoryCarousel({
    super.key,
    required this.title,
    required this.services,
  });

  @override
  State<ServiceCategoryCarousel> createState() => _ServiceCategoryCarouselState();
}

class _ServiceCategoryCarouselState extends State<ServiceCategoryCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.services.isEmpty) {
      return const SizedBox.shrink();
    }

    // Check if we're on a small screen (mobile)
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    // Get icon based on category title
    IconData categoryIcon = _getCategoryIcon(widget.title);
    
    // Calculate how many items per page
    final itemsPerPage = isSmallScreen ? 2 : 4;
    final pageCount = (widget.services.length / itemsPerPage).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category heading with ultra-compact design
        Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: isSmallScreen ? 4.0 : 8.0,
            bottom: 0, // No bottom padding
          ),
          child: Row(
            children: [
              Icon(
                categoryIcon, 
                color: Theme.of(context).colorScheme.primary,
                size: isSmallScreen ? 16 : 20, // Even smaller icon
              ),
              const SizedBox(width: 6), // Reduced spacing
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16, // Smaller text
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Show all services in this category
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 6 : 8,
                    vertical: 0, // No vertical padding
                  ),
                  minimumSize: const Size(0, 26), // Smaller minimum height
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Service items carousel
        SizedBox(
          height: isSmallScreen ? 200 : 220, // Slightly reduced height on mobile
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, pageIndex) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  itemsPerPage,
                  (itemIndex) {
                    final serviceIndex = pageIndex * itemsPerPage + itemIndex;
                    
                    // Check if this index exists in our services list
                    if (serviceIndex >= widget.services.length) {
                      return const Expanded(child: SizedBox());
                    }
                    
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          itemIndex == 0 ? 16.0 : isSmallScreen ? 4.0 : 8.0,
                          isSmallScreen ? 4.0 : 8.0,
                          itemIndex == itemsPerPage - 1 ? 16.0 : isSmallScreen ? 4.0 : 8.0,
                          0, // No bottom padding
                        ),
                        child: _buildResponsiveServiceCard(
                          context,
                          widget.services[serviceIndex],
                          isSmallScreen,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        
        // Add page indicators
        if (pageCount > 1)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pageCount,
                (index) => Container(
                  width: isSmallScreen ? 6 : 8,
                  height: isSmallScreen ? 6 : 8,
                  margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  // Adjusted to return smaller widths on mobile screens
  double _calculateItemWidth(double screenWidth) {
    if (screenWidth < 360) {
      return screenWidth * 0.7; // Even smaller on very small screens
    } else if (screenWidth < 600) {
      return screenWidth * 0.42; // Slightly narrower to fit more items
    } else if (screenWidth < 900) {
      return screenWidth * 0.3; // Medium screens - 3 items per view approximately
    } else {
      return 220; // Large screens - fixed width
    }
  }
  
  // Build a responsive service card with more compact layout
  Widget _buildResponsiveServiceCard(BuildContext context, ServiceModel service, bool isSmallScreen) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 4 : 6), // Even smaller radius
      ),
      elevation: 0.5, // Minimum elevation
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Use minimal vertical space
        children: [
          // Make image clickable
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsScreen(
                    serviceId: service.id,
                  ),
                ),
              );
            },
            child: AspectRatio(
              aspectRatio: isSmallScreen ? 16 / 7 : 16 / 8, // Even more compact ratio
              child: Image.asset(
                service.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, size: isSmallScreen ? 16 : 20),
                ),
              ),
            ),
          ),
          
          // Minimal padding content section
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 2.0 : 3.0), // Minimum padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Use minimal vertical space
              children: [
                // Name and price on same row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 10 : 12, // Smaller text
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₹${service.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 9 : 11, // Smaller price text
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                
                // Buttons with minimum spacing
                Padding(
                  padding: const EdgeInsets.only(top: 2), // Absolute minimum padding
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false).addItem(service);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${service.name} added to cart'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                width: 280,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero, // No padding
                            minimumSize: Size(0, isSmallScreen ? 20 : 24), // Even smaller height
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact, // More compact button
                            textStyle: TextStyle(fontSize: isSmallScreen ? 8 : 9),
                          ),
                          child: Text(isSmallScreen ? 'Add' : 'Add to Cart'),
                        ),
                      ),
                      
                      SizedBox(width: isSmallScreen ? 1 : 2), // Minimal gap
                      
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceDetailsScreen(
                                  serviceId: service.id,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero, // No padding
                            minimumSize: Size(0, isSmallScreen ? 20 : 24), // Even smaller height
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact, // More compact button
                            textStyle: TextStyle(fontSize: isSmallScreen ? 8 : 9),
                          ),
                          child: Text(isSmallScreen ? 'More' : 'Read More'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Cleaning Services':
        return Icons.cleaning_services;
      case 'Inspection & Health Check Services':
        return Icons.search;
      case 'Repair & Fixing Services':
        return Icons.build;
      case 'Emergency Repair Services':
        return Icons.warning;
      case 'Performance Optimization Services':
        return Icons.speed;
      case 'Protection & Safety Services':
        return Icons.security;
      case 'Replacement & Upgradation Services':
        return Icons.upgrade;
      case 'Other Solar System Services':
        return Icons.solar_power;
      default:
        return Icons.miscellaneous_services;
    }
  }
}
