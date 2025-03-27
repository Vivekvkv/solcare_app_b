import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcare_app4/models/service_model.dart'; 
import 'package:solcare_app4/screens/services/providers/services_providers.dart';
import 'package:solcare_app4/screens/services/components/index.dart';
import 'package:solcare_app4/screens/services/components/service_filter_bar.dart';
import 'package:solcare_app4/screens/services/components/service_category_carousel.dart';
import 'package:solcare_app4/screens/services/components/services_faq_section.dart';
import 'package:solcare_app4/widgets/dynamic_footer.dart';
import 'package:solcare_app4/widgets/universal_app_header.dart';
import 'package:solcare_app4/screens/home/components/footer_section.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  // Remove _isResidential property
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  
  // Filter state variables
  final Set<String> _selectedServiceTypes = {};
  final Set<String> _selectedUrgency = {};
  final Set<String> _selectedPriceRange = {};
  final Set<String> _selectedRating = {};
  final Set<String> _selectedAvailability = {};
  
  // Filter option lists
  final List<String> _serviceTypes = [
    'Cleaning', 'Inspection', 'Repair', 'Emergency', 
    'Optimization', 'Protection', 'Replacement', 'Other'
  ];
  
  final List<String> _urgencyOptions = ['Regular', 'Emergency'];
  final List<String> _priceRangeOptions = ['Low', 'Medium', 'High'];
  final List<String> _ratingOptions = ['4+ Stars', '3+ Stars', 'All Ratings'];
  final List<String> _availabilityOptions = ['Immediate', 'Scheduled'];

  Future<void> _refreshServices() async {
    return await ref.refresh(servicesProvider.future);
  }
  
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    
    // Update the search query in the provider
    ref.read(searchQueryProvider.notifier).state = query;
    
    // Refresh services to apply the search
    _refreshServices();
  }
  
  void _toggleFilter(String filter, Set<String> filterSet) {
    setState(() {
      if (filterSet.contains(filter)) {
        filterSet.remove(filter);
      } else {
        filterSet.add(filter);
      }
    });
    // Refresh data to apply filters
    _refreshServices();
  }
  
  // Helper method to filter services by selected criteria
  List<ServiceModel> _applyFilters(List<ServiceModel> services) {
    if (_selectedServiceTypes.isEmpty && 
        _selectedUrgency.isEmpty && 
        _selectedPriceRange.isEmpty && 
        _selectedRating.isEmpty && 
        _selectedAvailability.isEmpty) {
      return services;
    }
    
    return services.where((service) {
      // Filter by service type
      if (_selectedServiceTypes.isNotEmpty && 
          !_selectedServiceTypes.contains(service.category)) {
        return false;
      }
      
      // Filter by urgency (mock data - in a real app, this would check an urgency field)
      if (_selectedUrgency.isNotEmpty) {
        final isEmergency = service.name.toLowerCase().contains('emergency');
        if (_selectedUrgency.contains('Emergency') && !isEmergency) {
          return false;
        }
        if (_selectedUrgency.contains('Regular') && isEmergency) {
          return false;
        }
      }
      
      // Filter by price range
      if (_selectedPriceRange.isNotEmpty) {
        if (_selectedPriceRange.contains('Low') && service.price > 1000) {
          return false;
        }
        if (_selectedPriceRange.contains('Medium') && 
            (service.price < 1000 || service.price > 3000)) {
          return false;
        }
        if (_selectedPriceRange.contains('High') && service.price < 3000) {
          return false;
        }
      }
      
      // Filter by rating
      if (_selectedRating.isNotEmpty) {
        if (_selectedRating.contains('4+ Stars') && service.popularity < 4.0) {
          return false;
        }
        if (_selectedRating.contains('3+ Stars') && service.popularity < 3.0) {
          return false;
        }
      }
      
      // Filter by availability (mock implementation)
      if (_selectedAvailability.isNotEmpty) {
        // In a real app, this would check an availability field
        final isImmediate = service.name.toLowerCase().contains('quick') || 
                            service.name.toLowerCase().contains('emergency');
        if (_selectedAvailability.contains('Immediate') && !isImmediate) {
          return false;
        }
        if (_selectedAvailability.contains('Scheduled') && isImmediate) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }
  
  // Organize services into categories
  Map<String, List<ServiceModel>> _organizeServicesByCategory(List<ServiceModel> services) {
    final Map<String, List<ServiceModel>> categorizedServices = {
      'Cleaning Services (Most Commonly Booked)': [],
      'Inspection & Health Check Services': [],
      'Repair & Fixing Services': [],
      'Emergency Repair Services (Urgent Fixes)': [],
      'Performance Optimization Services': [],
      'Protection & Safety Services': [],
      'Replacement & Upgradation Services': [],
    };
    
    for (final service in services) {
      if (service.category == 'Cleaning') {
        categorizedServices['Cleaning Services (Most Commonly Booked)']!.add(service);
      } else if (service.category == 'Inspection') {
        categorizedServices['Inspection & Health Check Services']!.add(service);
      } else if (service.category == 'Repair') {
        categorizedServices['Repair & Fixing Services']!.add(service);
      } else if (service.category == 'Emergency') {
        categorizedServices['Emergency Repair Services (Urgent Fixes)']!.add(service);
      } else if (service.category == 'Optimization') {
        categorizedServices['Performance Optimization Services']!.add(service);
      } else if (service.category == 'Protection') {
        categorizedServices['Protection & Safety Services']!.add(service);
      } else if (service.category == 'Replacement') {
        categorizedServices['Replacement & Upgradation Services']!.add(service);
      }
    }
    
    return categorizedServices;
  }

  @override
  Widget build(BuildContext context) {
    // Access providers data
    final asyncServices = ref.watch(servicesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final isSmallScreen = MediaQuery.of(context).size.width < 600; // Check for small screen

    return Scaffold(
      // Use the exact AppHeader from the home screen
      body: Column(
        children: [
          // Replace the old app header with the universal header
          UniversalAppHeader(
            headerType: AppHeaderType.services,
            searchController: _searchController,
            onSearch: _handleSearch,
            scrollController: _scrollController,
            searchSuggestions: const ['Panel cleaning', 'Inverter repair', 'Efficiency check'],
          ),
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshServices,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Remove residential/commercial toggle section
                    
                    // Responsive filter bar with reduced padding for mobile
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 2.0 : 4.0,
                      ),
                      child: ServiceFilterBar(
                        serviceTypes: _serviceTypes,
                        urgencyOptions: _urgencyOptions,
                        priceRangeOptions: _priceRangeOptions,
                        ratingOptions: _ratingOptions,
                        availabilityOptions: _availabilityOptions,
                        selectedServiceTypes: _selectedServiceTypes,
                        selectedUrgency: _selectedUrgency,
                        selectedPriceRange: _selectedPriceRange,
                        selectedRating: _selectedRating,
                        selectedAvailability: _selectedAvailability,
                        onServiceTypeToggled: (type) => _toggleFilter(type, _selectedServiceTypes),
                        onUrgencyToggled: (urgency) => _toggleFilter(urgency, _selectedUrgency),
                        onPriceRangeToggled: (price) => _toggleFilter(price, _selectedPriceRange),
                        onRatingToggled: (rating) => _toggleFilter(rating, _selectedRating),
                        onAvailabilityToggled: (availability) => _toggleFilter(availability, _selectedAvailability),
                        onClearFilters: () {
                          setState(() {
                            _selectedServiceTypes.clear();
                            _selectedUrgency.clear();
                            _selectedPriceRange.clear();
                            _selectedRating.clear();
                            _selectedAvailability.clear();
                          });
                          _refreshServices();
                        },
                        isMobile: isSmallScreen, // Pass down mobile flag
                      ),
                    ),
                    
                    // Main content - Service Categories
                    asyncServices.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text('Error: $error'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _refreshServices,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      data: (services) {
                        // Apply search filtering if needed
                        final filteredServices = searchQuery.isEmpty
                            ? services
                            : services.where((service) => 
                                service.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                service.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                service.shortDescription.toLowerCase().contains(searchQuery.toLowerCase())
                              ).toList();
                        
                        // Apply selected filters
                        final appliedFilteredServices = _applyFilters(filteredServices);
                        
                        // Organize by category
                        final categorizedServices = _organizeServicesByCategory(appliedFilteredServices);
                        
                        // Display empty state if no services match filters
                        if (appliedFilteredServices.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.filter_list_off, size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'No services found. Try adjusting your filters.',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        // Build category carousels with special visibility on mobile
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // For mobile screens, show a hint about scrolling horizontally
                            if (isSmallScreen)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.swipe, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Swipe horizontally to see more services',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Display each category that has services
                            // For mobile screens, prioritize most important categories first
                            if (isSmallScreen) 
                              ...prioritizeCategoriesForMobile(categorizedServices)
                            else
                              ...categorizedServices.entries
                                  .where((entry) => entry.value.isNotEmpty)
                                  .map((entry) => ServiceCategoryCarousel(
                                        title: entry.key,
                                        services: entry.value,
                                      )),
                            
                            // FAQ Section - show less content on small screens
                            if (!isSmallScreen || searchQuery.isEmpty)
                              const ServicesFAQSection(),
                            
                            // Dynamic footer
                            const SizedBox(height: 20),
                            const FooterSection(),
                            const SizedBox(height: 60), // Bottom padding
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Add a Cart button for quick access
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to cart with proper implementation
          Navigator.pushNamed(context, '/cart'); // Replace with your actual cart route
        },
        tooltip: 'View Cart',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
  
  // New helper method to prioritize and limit categories on mobile
  List<Widget> prioritizeCategoriesForMobile(Map<String, List<ServiceModel>> categorizedServices) {
    // Define priority order for categories
    final priorityOrder = [
      'Cleaning Services (Most Commonly Booked)',
      'Emergency Repair Services (Urgent Fixes)',
      'Repair & Fixing Services',
      'Inspection & Health Check Services',
      'Performance Optimization Services',
      'Protection & Safety Services',
      'Replacement & Upgradation Services',
    ];
    
    // Create a list to store categories in priority order
    final prioritizedCategories = <MapEntry<String, List<ServiceModel>>>[];
    
    // Add categories in priority order if they have services
    for (final categoryName in priorityOrder) {
      final services = categorizedServices[categoryName];
      if (services != null && services.isNotEmpty) {
        prioritizedCategories.add(MapEntry(categoryName, services));
      }
    }
    
    // Return widgets for each category WITHOUT ANY PADDING between them
    return prioritizedCategories.map((entry) => ServiceCategoryCarousel(
      title: entry.key,
      services: entry.value,
    )).toList();
  }
}

// Search delegate for services
class ServiceSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;
  
  ServiceSearchDelegate({required this.ref});
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }
  
  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text(
              'Enter a search term to find services',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          )
        ],
      );
    }
    
    // Update search query in provider
    ref.read(searchQueryProvider.notifier).state = query;
    
    // Get filtered services
    final asyncServices = ref.watch(searchServicesProvider(query));
    
    return asyncServices.when(
      data: (services) {
        if (services.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  'No services found for your search',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              )
            ],
          );
        }
        
        return ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(service.image),
              ),
              title: Text(service.name),
              subtitle: Text(service.shortDescription),
              onTap: () {
                close(context, service.id);
                // Add to recently viewed
                ref.read(recentlyViewedServicesProvider.notifier).addService(service);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}