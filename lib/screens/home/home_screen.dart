import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/providers/theme_provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/providers/booking_provider.dart'; // Add this for global search
import 'package:solcare_app4/screens/profile/profile_screen.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';
import 'package:solcare_app4/screens/services/services_screen.dart';
import 'package:solcare_app4/screens/home/components/index.dart';
import 'package:solcare_app4/screens/home/components/featured_services_carousel.dart';
import 'package:solcare_app4/screens/home/components/trending_services_section.dart' as home_components;
import 'package:solcare_app4/screens/home/components/subscription_plans_section.dart';
import 'package:solcare_app4/screens/home/components/customer_reviews_section.dart';
import 'package:solcare_app4/screens/home/components/quick_consultation_section.dart';
import 'package:solcare_app4/widgets/service_card.dart';
import 'package:solcare_app4/widgets/universal_app_header.dart';
import 'package:solcare_app4/widgets/reels/home_reels_section.dart';
import 'package:solcare_app4/widgets/ai_chatbot/floating_chatbot_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  bool _isScrolled = false;
  // Add these variables for global search
  List<dynamic> _globalSearchResults = [];
  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.offset > 10 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 10 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }
  
  // Enhanced search function for global search
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
      
      if (query.isEmpty) {
        _globalSearchResults = [];
        return;
      }
      
      // Start building global search results
      _performGlobalSearch(query);
    });
  }
  
  // New method: Perform global search across different sections
  void _performGlobalSearch(String query) {
    final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    
    final List<dynamic> results = [];
    final lowercaseQuery = query.toLowerCase();
    
    // Search in trending services
    results.addAll(serviceProvider.trendingServices
        .where((service) =>
            service.name.toLowerCase().contains(lowercaseQuery) ||
            service.shortDescription.toLowerCase().contains(lowercaseQuery))
        .toList());
    
    // Search in featured services
    results.addAll(serviceProvider.featuredServices
        .where((service) =>
            service.name.toLowerCase().contains(lowercaseQuery) ||
            service.shortDescription.toLowerCase().contains(lowercaseQuery))
        .toList());
    
    try {
      // Search in all services - use services getter as fallback if allServices isn't available
      if (serviceProvider.allServices != null) {
        results.addAll(serviceProvider.allServices
            .where((service) =>
                service.name.toLowerCase().contains(lowercaseQuery) ||
                service.shortDescription.toLowerCase().contains(lowercaseQuery))
            .toList());
      } else {
        // Fallback to using services getter converted to ServiceModel
        results.addAll(serviceProvider.services
            .map((service) => serviceProvider.getServiceById(service.id.toString()))
            .where((service) =>
                service.name.toLowerCase().contains(lowercaseQuery) ||
                service.shortDescription.toLowerCase().contains(lowercaseQuery))
            .toList());
      }
    } catch (e) {
      print('Error searching all services: $e');
      // Don't add to results if there's an error
    }
    
    // Remove duplicates (services might be in multiple lists)
    final Map<String, dynamic> uniqueResults = {};
    for (var item in results) {
      if (item.id != null) {
        uniqueResults[item.id] = item;
      }
    }
    
    setState(() {
      _globalSearchResults = uniqueResults.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    // For notification badge
    final hasNotifications = profileProvider.profile.rewardPoints > 0;
    
    final trendingServices = serviceProvider.trendingServices;
    final featuredServices = serviceProvider.featuredServices;

    // Use global search results when searching, otherwise use trending services
    final displayedServices = _isSearching 
        ? _globalSearchResults 
        : trendingServices;
            
    // Calculate search bar width based on screen size
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          // Replace custom header with UniversalAppHeader
          UniversalAppHeader(
            headerType: AppHeaderType.home,
            searchController: _searchController,
            onSearch: _handleSearch,
            scrollController: _scrollController,
            searchSuggestions: const ['Solar panel cleaning', 'Inverter maintenance', 'System check'],
          ),
          
          // Add space between header and content
          const SizedBox(height: 16),
          
          // Content Area
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Only show search results when searching, otherwise show regular content
                    if (_isSearching) ...[
                      // Search results header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Search Results for "$_searchQuery"',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                _handleSearch('');
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ),
                      
                      // Display search results or no results message
                      displayedServices.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No results found for "$_searchQuery"',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Try different keywords or browse our services',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Services section header
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Text(
                                  'Services (${displayedServices.length})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Horizontal list of service cards
                              SizedBox(
                                height: 270,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: displayedServices.length,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      width: 220,
                                      child: ServiceCard(
                                        service: displayedServices[index],
                                        showAddToCart: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                      
                      // Info about global search
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Search is looking across all services, categories, and content.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ] else ...[
                      // Regular content when not searching
                      // Featured Services Section
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 180,
                            maxHeight: 280,
                          ),
                          child: FeaturedServicesCarousel(
                            services: featuredServices,
                            useCompactLayout: MediaQuery.of(context).size.width < 400,
                          ),
                        ),
                      ),
                    
                      // Trending Services Section with adaptive height
                      if (_searchQuery.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 180,
                              maxHeight: 280,
                            ),
                            child: home_components.TrendingServicesSection(
                              trendingServices: trendingServices,
                              useCompactLayout: MediaQuery.of(context).size.width < 400,
                            ),
                          ),
                        ),
                      
                      // Top Services Section - NEW ADDITION
                      if (_searchQuery.isEmpty)
                        const TopServicesSection(),

                      // Solcare Shorts Section - NEW ADDITION
                      if (_searchQuery.isEmpty)
                        const HomeReelsSection(),

                      const SizedBox(height: 24),
                      
                      // Interactive Tools Section - NEW ADDITION
                      if (_searchQuery.isEmpty)
                        const InteractiveToolsSection(),
                      
                      // Seasonal Offers Section - NEW ADDITION
                      if (_searchQuery.isEmpty)
                        const SeasonalOffersSection(),
                      
                      // // User's Solar System Dashboard - NEW ADDITION
                      // we will use it later.
                      // if (_searchQuery.isEmpty)
                      //   const SolarSystemDashboard(),
                      
                      // Subscription Plans Section - NEW ADDITION
                      if (_searchQuery.isEmpty)
                        const SubscriptionPlansSection(),
                      
                      // Referral Program Section - NEW ADDITION
                      if (_searchQuery.isEmpty)
                        const ReferralProgramSection(),
                      
                      // Customer Reviews Section - NEW ADDITION
                      if (_searchQuery.isEmpty)
                        const CustomerReviewsSection(),
                      
                      // Quick Consultation Section - NEW ADDITION
                      if (_searchQuery.isEmpty)
                        const QuickConsultationSection(),
                      
                      const SizedBox(height: 20),

                      // Interactive Carousel
                      // const CarouselSection(),

                      // const SizedBox(height: 16),

                      // Search results section (only when searching)
                      if (_searchQuery.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Search Results for "$_searchQuery"',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _handleSearch('');
                                },
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        ),

                      if (_searchQuery.isNotEmpty)
                        if (displayedServices.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No services found for "$_searchQuery"',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 270,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: displayedServices.length,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 220,
                                  child: ServiceCard(
                                    service: displayedServices[index],
                                    showAddToCart: true,
                                  ),
                                );
                              },
                            ),
                          ),

                      const SizedBox(height: 16),

                      // Reels Section (removed to avoid duplication)
                      // if (_searchQuery.isEmpty)
                      //   const ReelsSection(),

                      const SizedBox(height: 24),

                      // // CTA Section
                      // CTASection(
                      //   onBookNow: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const BookingScreen(),
                      //     ),
                      //   ),
                      //   onExplore: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const ServicesScreen(),
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 24),

                      // Footer
                      const FooterSection(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingChatbotButton(),
    );
  }
}
