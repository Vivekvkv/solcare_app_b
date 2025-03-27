import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/providers/cart_provider.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';
import 'package:solcare_app4/screens/service_details/components/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solcare_app4/models/service_model.dart'; // Add import for ServiceModel

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool _showAllFAQs = false;
  bool _showAllReviews = false;
  final PageController _imagePageController = PageController();
  int _currentImagePage = 0;

  // Mock service images
  List<String> getServiceImages(String baseImage) {
    // Generate mock variant images based on the main image
    if (baseImage.startsWith('http')) {
      // For network images
      return [
        baseImage,
        baseImage.replaceAll('.jpg', '_2.jpg'),
        baseImage.replaceAll('.jpg', '_3.jpg'),
        baseImage.replaceAll('.jpg', '_4.jpg'),
      ];
    } else {
      // For asset images, create variations
      String basePath = baseImage.split('.').first;
      String extension = baseImage.split('.').last;
      return [
        baseImage,
        '${basePath}_2.$extension',
        '${basePath}_3.$extension',
        '${basePath}_4.$extension',
      ];
    }
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final service = serviceProvider.getServiceById(widget.serviceId);

    // Generate mock images for the service
    final serviceImages = getServiceImages(service.image);

    // Mock data
    final reviews = MockDataProvider.getReviews();
    final faqs = MockDataProvider.getFAQs(service.duration);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced Image Carousel with PageView
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image PageView
                  PageView.builder(
                    controller: _imagePageController,
                    itemCount: serviceImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImagePage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: 'service_image_${service.id}',
                        child: serviceImages[index].startsWith('http')
                            ? Image.network(
                                serviceImages[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 50),
                                ),
                              )
                            : Image.asset(
                                serviceImages[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 50),
                                ),
                              ),
                      );
                    },
                  ),
                  
                  // Page indicator
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _imagePageController,
                        count: serviceImages.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Theme.of(context).colorScheme.primary,
                          dotColor: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              // Share button
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share feature coming soon')),
                    );
                  },
                ),
              ),
            ],
          ),

          // Service Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Title & Category
                  ServiceHeader(service: service),

                  const SizedBox(height: 16),

                  // Price & Duration
                  ServicePriceInfo(service: service),

                  const SizedBox(height: 16),

                  // Rating
                  ServiceRating(service: service),

                  const SizedBox(height: 24),

                  // Description
                  ServiceDescription(description: service.description),

                  const SizedBox(height: 24),

                  // Benefits
                  const ServiceBenefitsSection(),

                  const SizedBox(height: 24),

                  // FAQs
                  FAQsSection(
                    faqs: faqs,
                    showAllFAQs: _showAllFAQs,
                    toggleShowAllFAQs: () {
                      setState(() {
                        _showAllFAQs = !_showAllFAQs;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Reviews
                  ReviewsSection(
                    reviews: reviews,
                    showAllReviews: _showAllReviews,
                    toggleShowAllReviews: () {
                      setState(() {
                        _showAllReviews = !_showAllReviews;
                      });
                    },
                  ),

                  // Add some space for the bottom buttons
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 80,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Show service price
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '\$${service.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Add to cart button
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    // Add to cart button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          cartProvider.addItem(service);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${service.name} added to cart'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          elevation: 0,
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Book now button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to booking screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                preselectedService: service, // Fix: Use preselectedService parameter
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Book Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
