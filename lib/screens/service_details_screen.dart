import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/providers/cart_provider.dart';
import 'package:solcare_app4/screens/booking_screen.dart';

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

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required String name,
    required double rating,
    required String comment,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 16,
                ignoreGestures: true,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
              const SizedBox(width: 8),
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final service = serviceProvider.getServiceById(widget.serviceId);

    // Mock reviews data
    final reviews = [
      {
        'name': 'Raj Sharma',
        'rating': 5.0,
        'comment': 'Excellent service! The technician was knowledgeable and fixed my system quickly.',
        'date': '2 weeks ago',
      },
      {
        'name': 'Priya Patel',
        'rating': 4.5,
        'comment': 'Very professional team. They cleaned all my solar panels thoroughly.',
        'date': '1 month ago',
      },
      {
        'name': 'Amit Singh',
        'rating': 4.0,
        'comment': 'Good service but arrived a bit late. Otherwise very satisfactory.',
        'date': '2 months ago',
      },
      {
        'name': 'Neha Gupta',
        'rating': 5.0,
        'comment': 'Amazing service! The team was punctual and very professional.',
        'date': '3 months ago',
      },
      {
        'name': 'Vikram Reddy',
        'rating': 4.0,
        'comment': 'They did a good job. My system is working much better now.',
        'date': '3 months ago',
      },
    ];

    // Mock FAQs data
    final faqs = [
      {
        'question': 'How often should I clean my solar panels?',
        'answer': 'For optimal performance, we recommend cleaning your solar panels every 3-6 months, depending on your location and environmental factors like dust, pollution, and bird droppings.',
      },
      {
        'question': 'What happens during a maintenance service visit?',
        'answer': 'Our technicians will inspect the entire system, clean panels, check wiring and connections, inspect the inverter performance, and provide a detailed health report with recommendations.',
      },
      {
        'question': 'How long does the service take?',
        'answer': 'Most of our services take between 1-4 hours depending on the size of your system and the specific service being performed. The estimated duration for this service is ${service.duration}.',
      },
      {
        'question': 'Do I need to be present during the service?',
        'answer': 'While it\'s not mandatory, we recommend that you or someone familiar with your system is present at least at the beginning and end of the service for a brief discussion with our technician.',
      },
      {
        'question': 'Is there any warranty for this service?',
        'answer': 'Yes, all our services come with a 30-day satisfaction guarantee. If you encounter any issues related to the service within this period, we\'ll fix it at no additional cost.',
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: service.image.startsWith('http')
                  ? Image.network(
                      service.image,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      service.image,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          // Service Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Title & Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(service.category),
                        backgroundColor: 
                            Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price & Duration
                  Row(
                    children: [
                      Text(
                        '₹${service.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service.duration,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rating
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: service.popularity,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        ignoreGestures: true,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(width: 8),
                      Text(
                        service.popularity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${(service.popularity * 25).toInt()} reviews)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About this service',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Benefits
                  const Text(
                    'Benefits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBenefitItem(
                    icon: Icons.battery_charging_full,
                    title: 'Improved Efficiency',
                    description: 'Maximize your system\'s power output',
                  ),
                  _buildBenefitItem(
                    icon: Icons.attach_money,
                    title: 'Cost Savings',
                    description: 'Reduce long-term maintenance costs',
                  ),
                  _buildBenefitItem(
                    icon: Icons.update,
                    title: 'Extended Lifespan',
                    description: 'Prolong the life of your solar system',
                  ),

                  const SizedBox(height: 24),

                  // FAQs
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...faqs.take(_showAllFAQs ? faqs.length : 3).map((faq) => _buildFAQItem(
                        question: faq['question']!,
                        answer: faq['answer']!,
                      )),
                  if (faqs.length > 3)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllFAQs = !_showAllFAQs;
                        });
                      },
                      child: Text(
                        _showAllFAQs ? 'Show Less' : 'View All FAQs',
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showAllReviews = !_showAllReviews;
                          });
                        },
                        child: Text(_showAllReviews ? 'Show Less' : 'See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...reviews.take(_showAllReviews ? reviews.length : 3).map((review) => _buildReviewItem(
                        name: review['name'] as String,
                        rating: review['rating'] as double,
                        comment: review['comment'] as String,
                        date: review['date'] as String,
                      )),

                  const SizedBox(height: 100), // Space for the bottom action bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Add to Cart'),
                onPressed: () {
                  cartProvider.addItem(service);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${service.name} added to cart'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'View Cart',
                        onPressed: () {
                          Navigator.pop(context); // Close the detail screen
                          // Navigate to cart screen is handled by the FAB in main_screen.dart
                        },
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Book Now'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        preselectedService: service,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
