import 'package:flutter/material.dart';

class CustomerReviewsSection extends StatefulWidget {
  const CustomerReviewsSection({super.key});

  @override
  State<CustomerReviewsSection> createState() => _CustomerReviewsSectionState();
}

class _CustomerReviewsSectionState extends State<CustomerReviewsSection> {
  // Controller for auto-swiping carousel
  late PageController _pageController;
  int _currentPage = 0;
  
  // Mock data for customer reviews - in a real app this would come from a provider or API
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Rahul Sharma',
      'profileImage': 'https://randomuser.me/api/portraits/men/1.jpg',
      'rating': 4.5,
      'review': 'The service was excellent. My solar panels are now performing much better after the cleaning and maintenance. Would definitely recommend!',
      'beforeImage': 'https://example.com/before1.jpg',
      'afterImage': 'https://example.com/after1.jpg',
      'description': 'Improved efficiency by 25% after cleaning and fixing loose connections.',
    },
    {
      'name': 'Priya Patel',
      'profileImage': null, // Testing error handling
      'rating': 5.0,
      'review': 'Extremely satisfied with the service. The technician was very knowledgeable and fixed all the issues with my solar system. The improvement in performance is remarkable.',
      'beforeImage': 'https://example.com/before2.jpg',
      'afterImage': 'https://example.com/after2.jpg',
      'description': 'Complete system restoration after storm damage, output increased by 35%.',
    },
    {
      'name': 'Aditya Singh',
      'profileImage': 'https://randomuser.me/api/portraits/men/2.jpg',
      'rating': 4.0,
      'review': 'Good service, professional team. They fixed the inverter issues and cleaned all panels thoroughly.',
      'beforeImage': null, // Testing error handling
      'afterImage': null, // Testing error handling
      'description': 'Inverter optimization and panel cleaning resulted in 15% better performance.',
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.85, // Show a bit of the next card
    );
    
    // Start auto-swiping timer
    _startAutoSwipe();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _startAutoSwipe() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _reviews.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoSwipe(); // Restart the timer
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if we have any reviews
    if (_reviews.isEmpty) {
      return _buildNoReviewsAvailable();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'What Our Customers Say',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all reviews page (could be implemented later)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All reviews page coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        
        // Reviews Carousel
        SizedBox(
          height: 450, // Fixed height for the carousel
          child: PageView.builder(
            controller: _pageController,
            itemCount: _reviews.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return _buildReviewCard(review);
            },
          ),
        ),
        
        // Page Indicator Dots
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_reviews.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer info and rating
            Row(
              children: [
                _buildProfileImage(review['profileImage']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildRatingStars(review['rating']),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Review text
            Text(
              review['review'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            
            if (review['review'].length > 150)
              TextButton(
                onPressed: () {
                  // Show full review dialog
                  _showFullReviewDialog(context, review);
                },
                child: const Text('Read More'),
              ),
              
            const SizedBox(height: 16),
            
            // Before & After Section
            _buildBeforeAfterSection(
              review['beforeImage'],
              review['afterImage'],
              review['description'],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileImage(String? imageUrl) {
    if (imageUrl == null) {
      // Default avatar icon if no image
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade200,
        child: const Icon(
          Icons.person,
          size: 32,
          color: Colors.grey,
        ),
      );
    }
    
    return CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) {
        // Handle error loading image
        return;
      },
      child: null,
    );
  }
  
  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          // Full star
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index < rating.ceil() && rating.remainder(1) > 0) {
          // Half star
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          // Empty star
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }
  
  Widget _buildBeforeAfterSection(String? beforeImage, String? afterImage, String description) {
    if (beforeImage == null && afterImage == null) {
      // No images available
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'No before & after images available',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Before & After',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Before Image
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBeforeAfterImage(beforeImage, 'Before'),
                  const SizedBox(height: 4),
                  const Text(
                    'Before',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // After Image
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBeforeAfterImage(afterImage, 'After'),
                  const SizedBox(height: 4),
                  const Text(
                    'After',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBeforeAfterImage(String? imageUrl, String placeholder) {
    return GestureDetector(
      onTap: imageUrl != null ? () => _showFullImageDialog(context, imageUrl, placeholder) : null,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        clipBehavior: Clip.antiAlias,
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return _buildNoImagePlaceholder(placeholder);
                },
              )
            : _buildNoImagePlaceholder(placeholder),
      ),
    );
  }
  
  Widget _buildNoImagePlaceholder(String type) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          'No $type Image',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
  
  Widget _buildNoReviewsAvailable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'No customer reviews available yet.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Be the first to share your experience!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showFullReviewDialog(BuildContext context, Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            _buildProfileImage(review['profileImage']),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                review['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRatingStars(review['rating']),
              const SizedBox(height: 16),
              Text(review['review']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _showFullImageDialog(BuildContext context, String imageUrl, String type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$type Image',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.broken_image, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text('Failed to load image'),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
