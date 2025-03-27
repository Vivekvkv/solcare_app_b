import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/service_provider.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final trendingServices = serviceProvider.trendingServices;
    final featuredServices = serviceProvider.featuredServices;

    // Filter services if search query exists
    final filteredServices = _searchQuery.isEmpty
        ? trendingServices
        : trendingServices
            .where((service) =>
                service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                service.shortDescription.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      body: Column(
        children: [
          // Universal app header
          UniversalAppHeader(
            headerType: AppHeaderType.home,
            searchController: _searchController,
            onSearch: _handleSearch,
            scrollController: _scrollController,
            searchSuggestions: const ['Solar panel cleaning', 'Inverter maintenance', 'System check'],
          ),
          
          // Scrollable Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Implement refresh logic if needed
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured Services Section
                    if (_searchQuery.isEmpty)
                      FeaturedServicesCarousel(services: featuredServices),
                      
                    const SizedBox(height: 24),
                    
                    // Trending Services Section
                    if (_searchQuery.isEmpty)
                      home_components.TrendingServicesSection(trendingServices: trendingServices),
                    
                    // Top Services Section
                    if (_searchQuery.isEmpty)
                      const TopServicesSection(),

                    // Solcare Shorts Section - Using the pre-built component
                    if (_searchQuery.isEmpty)
                      const HomeReelsSection(),

                    const SizedBox(height: 24),
                    
                    // Interactive Tools Section
                    if (_searchQuery.isEmpty)
                      const InteractiveToolsSection(),
                    
                    // Seasonal Offers Section
                    if (_searchQuery.isEmpty)
                      const SeasonalOffersSection(),
                    
                    // Subscription Plans Section
                    if (_searchQuery.isEmpty)
                      const SubscriptionPlansSection(),
                    
                    // Referral Program Section
                    if (_searchQuery.isEmpty)
                      const ReferralProgramSection(),
                    
                    // Customer Reviews Section
                    if (_searchQuery.isEmpty)
                      const CustomerReviewsSection(),
                    
                    // Quick Consultation Section
                    if (_searchQuery.isEmpty)
                      const QuickConsultationSection(),
                    
                    const SizedBox(height: 20),

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
                      if (filteredServices.isEmpty)
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
                            itemCount: filteredServices.length,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 220,
                                child: ServiceCard(
                                  service: filteredServices[index],
                                  showAddToCart: true,
                                ),
                              );
                            },
                          ),
                        ),

                    const SizedBox(height: 16),

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
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open chatbot
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chatbot coming soon!'),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.chat_bubble),
      ),
    );
  }
}
