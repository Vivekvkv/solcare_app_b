import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/components/horizontal_service_list.dart';
import 'package:solcare_app4/screens/services/components/service_grid.dart';
import 'package:solcare_app4/widgets/dynamic_footer.dart';
import 'package:solcare_app4/screens/services/components/service_card.dart';
import 'package:solcare_app4/screens/services/components/service_card_shimmer.dart';

class ServiceCollectionsView extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<ServiceModel> recentlyViewedServices;
  final List<ServiceModel> popularServices;
  final List<ServiceModel> trendingServices;
  final List<ServiceModel> nearbyServices;
  final List<ServiceModel> filteredServices;

  const ServiceCollectionsView({
    super.key,
    this.isLoading = false,
    this.error,
    this.recentlyViewedServices = const [],
    this.popularServices = const [],
    this.trendingServices = const [],
    this.nearbyServices = const [],
    this.filteredServices = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Use a regular non-sliver Column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recently viewed services
        if (recentlyViewedServices.isNotEmpty)
          _buildRecentlyViewedServices(),
        
        // Popular services section
        HorizontalServiceList(
          title: 'Popular Services',
          services: popularServices,
          icon: Icons.favorite,
          isLoading: isLoading,
        ),
        
        // Trending services section
        HorizontalServiceList(
          title: 'Trending Now',
          services: trendingServices,
          icon: Icons.trending_up,
          isLoading: isLoading,
        ),
        
        // Location-based services
        HorizontalServiceList(
          title: 'Services Near You',
          services: nearbyServices,
          icon: Icons.location_on,
          isLoading: isLoading,
        ),
        
        // All services heading
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${filteredServices.length} results'),
            ],
          ),
        ),
        
        // Services grid
        isLoading 
          ? _buildLoadingGrid()
          : error != null
            ? _buildErrorView(error!)
            : filteredServices.isEmpty
              ? _buildEmptyState()
              : ServiceGrid(services: filteredServices),
        
        // Dynamic footer
        const Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: DynamicFooter(),
        ),
        
        // Add some space at the bottom for floating button
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildRecentlyViewedServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.history, size: 20),
              SizedBox(width: 8),
              Text(
                'Recently Viewed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: recentlyViewedServices.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 180,
                child: Card(
                  margin: const EdgeInsets.all(4),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to service details
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              recentlyViewedServices[index].image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                        
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recentlyViewedServices[index].name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '₹${recentlyViewedServices[index].price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
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
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const ServiceCardShimmer(),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: $error',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pull down to refresh',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No services found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your filters or search query',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
