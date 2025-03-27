import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcare_app4/models/service_model.dart'; // Added missing import for ServiceModel
import 'package:solcare_app4/screens/services/providers/services_providers.dart';
import 'package:solcare_app4/screens/services/components/index.dart';

class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage({super.key});

  @override
  ConsumerState<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends ConsumerState<ServicesPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore) {
      // Load more services when scrolling to bottom
      _loadMoreServices();
    }
  }

  Future<void> _loadMoreServices() async {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    // Simulate fetching more data
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshServices() async {
    // Use the repository to force refresh services
    final repository = ref.read(serviceRepositoryProvider);
    await repository.fetchServices(forceRefresh: true);
    
    // Invalidate providers to trigger UI refresh
    ref.invalidate(servicesProvider);
    ref.invalidate(popularServicesProvider);
    ref.invalidate(trendingServicesProvider);
  }

  void _handleSearch(String query) {
    // Update search query provider state
    ref.read(searchQueryProvider.notifier).state = query;
  }

  void _applyFilters() {
    // Close the filter panel and trigger a refresh
    Navigator.pop(context);
    
    // This will cause the data to be filtered according to current filter settings
    ref.invalidate(servicesProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Access providers data
    final asyncServices = ref.watch(servicesProvider);
    // Remove or use the filter variable
    // final filter = ref.watch(serviceFilterProvider);
    
    // Get services from various providers with proper type casting
    final List<ServiceModel> recentlyViewedServices = ref.watch(recentlyViewedServicesProvider);
    final List<ServiceModel> popularServices = ref.watch(popularServicesProvider);
    final List<ServiceModel> trendingServices = ref.watch(trendingServicesProvider);
    final List<ServiceModel> nearbyServices = ref.watch(nearbyServicesProvider).when(
      data: (data) => data,
      loading: () => <ServiceModel>[], // Explicit type for empty list
      error: (_, __) => <ServiceModel>[], // Explicit type for empty list
    );
    
    // Get current search query
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () {
              _showFilterPanel(context);
            },
          ),
        ],
      ),
      // IMPORTANT: Use a SingleChildScrollView + Column instead of CustomScrollView with Slivers
      // to avoid the RenderViewport/RenderSliver errors
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshServices,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ServiceSearchBar( // Fix: Use as widget, not method
                  onSearch: _handleSearch,
                ),
              ),
              
              // Main content
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
                  
                  // Fix: Use as widget, not method
                  return ServiceCollectionsView(
                    recentlyViewedServices: recentlyViewedServices,
                    popularServices: popularServices,
                    trendingServices: trendingServices,
                    nearbyServices: nearbyServices,
                    filteredServices: filteredServices,
                  );
                },
              ),
              
              // Loading indicator for pagination
              if (_isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: FilterPanel(
                  onApplyFilters: _applyFilters,
                  onResetFilters: () {
                    ref.read(serviceFilterProvider.notifier).state = ServiceFilter();
                    Navigator.pop(context);
                    ref.invalidate(servicesProvider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
