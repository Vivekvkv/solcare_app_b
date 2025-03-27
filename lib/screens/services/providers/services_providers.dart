import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/utils/local_cache.dart';
import 'package:solcare_app4/utils/simple_http_client.dart';
import 'package:solcare_app4/data/services_data.dart';
import 'dart:async';
import 'dart:math';

// Models
class ServiceFilter {
  final List<String> categories;
  final RangeValues priceRange;
  final double minRating;
  final String sortBy;
  final bool isResidential;
  final String subscriptionType;

  ServiceFilter({
    this.categories = const [],
    this.priceRange = const RangeValues(0, 10000),
    this.minRating = 0.0,
    this.sortBy = 'Popularity',
    this.isResidential = true,
    this.subscriptionType = 'Monthly',
  });

  ServiceFilter copyWith({
    List<String>? categories,
    RangeValues? priceRange,
    double? minRating,
    String? sortBy,
    bool? isResidential,
    String? subscriptionType,
  }) {
    return ServiceFilter(
      categories: categories ?? this.categories,
      priceRange: priceRange ?? this.priceRange,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      isResidential: isResidential ?? this.isResidential,
      subscriptionType: subscriptionType ?? this.subscriptionType,
    );
  }
}

// Mock cache implementation
class LocalCache {
  static final Map<String, dynamic> _cache = {};

  static Future<void> put(String key, dynamic value) async {
    _cache[key] = value;
  }

  static dynamic get(String key) {
    return _cache[key];
  }

  static bool containsKey(String key) {
    return _cache.containsKey(key);
  }
}

// Mock HTTP client
class SimpleHttpClient {
  Future<Map<String, dynamic>> get(String url) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return mock data
    return {
      'status': 'success',
      'data': generateMockServices(),
    };
  }

  List<Map<String, dynamic>> generateMockServices() {
    // Generate mock service data similar to what the API would return
    return List.generate(20, (index) => {
      'id': 'service_${index + 1}',
      'name': 'Service ${index + 1}',
      'description': 'Description for service ${index + 1}',
      'shortDescription': 'Short description for service ${index + 1}',
      'price': (Random().nextDouble() * 5000 + 500).roundToDouble(),
      'image': 'assets/images/service_${(index % 10) + 1}.jpg',
      'category': ['Cleaning', 'Maintenance', 'Repair', 'Installation'][index % 4],
      'duration': '${(index % 3) + 1} hours',
      'popularity': (Random().nextDouble() * 3 + 2).roundToDouble(),
      'discount': Random().nextInt(20),
    });
  }
}

// Service Repository
class ServiceRepository {
  final SimpleHttpClient _client = SimpleHttpClient();
  final String _cacheKey = 'services_cache';

  Future<List<ServiceModel>> fetchServices({
    bool forceRefresh = false,
    String? category,
    String? query,
  }) async {
    try {
      // Use the new services data
      List<ServiceModel> services = ServicesData.getAllServices();
      
      // Apply category filter if specified
      if (category != null && category.isNotEmpty) {
        services = services.where((s) => 
          s.category.toLowerCase() == category.toLowerCase()
        ).toList();
      }
      
      // Apply search query if specified
      if (query != null && query.isNotEmpty) {
        services = services.where((s) => 
          s.name.toLowerCase().contains(query.toLowerCase()) || 
          s.description.toLowerCase().contains(query.toLowerCase()) ||
          s.shortDescription.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
      
      return services;
    } catch (e) {
      // Log the error and rethrow
      print('Error fetching services: $e');
      rethrow;
    }
  }

  Future<List<ServiceModel>> fetchServicesByLocation(double latitude, double longitude) async {
    // In a real app, this would use the coordinates to find nearby services
    // For now, we'll just return some random services
    final services = await fetchServices();
    if (services.isNotEmpty) {
      final shuffledServices = List<ServiceModel>.from(services)..shuffle();
      return shuffledServices.take(5).toList();
    }
    return [];
  }
}

// Providers
final serviceFilterProvider = StateProvider<ServiceFilter>((ref) {
  return ServiceFilter();
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  final filter = ref.watch(serviceFilterProvider);
  final services = await repository.fetchServices();
  
  return services.where((service) {
    // Apply price filter
    if (service.price < filter.priceRange.start || service.price > filter.priceRange.end) {
      return false;
    }
    
    // Apply category filter
    if (filter.categories.isNotEmpty && !filter.categories.contains(service.category)) {
      return false;
    }
    
    // Apply rating filter
    if (service.popularity < filter.minRating) {
      return false;
    }
    
    return true;
  }).toList();
});

final searchServicesProvider = FutureProvider.family<List<ServiceModel>, String>((ref, query) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return await repository.fetchServices(query: query);
});

final categoryServicesProvider = FutureProvider.family<List<ServiceModel>, String>((ref, category) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return await repository.fetchServices(category: category);
});

final nearbyServicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  // Mock location for now
  return repository.fetchServicesByLocation(37.7749, -122.4194);
});

final recommendedServicesProvider = Provider<List<ServiceModel>>((ref) {
  final servicesAsync = ref.watch(servicesProvider);
  
  return servicesAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (services) {
      final List<ServiceModel> recommended = List<ServiceModel>.from(services);
      if (recommended.isNotEmpty) {
        recommended.shuffle();
        return recommended.take(5).toList();
      }
      return [];
    },
  );
});

final popularServicesProvider = Provider<List<ServiceModel>>((ref) {
  final servicesAsync = ref.watch(servicesProvider);
  
  return servicesAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (services) {
      final servicesList = List<ServiceModel>.from(services);
      servicesList.sort((a, b) => b.popularity.compareTo(a.popularity));
      return servicesList.take(8).toList();
    },
  );
});

final trendingServicesProvider = Provider<List<ServiceModel>>((ref) {
  final servicesAsync = ref.watch(servicesProvider);
  
  return servicesAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (services) {
      final servicesList = List<ServiceModel>.from(services);
      final trending = servicesList.where((s) => s.popularity > 4.0).toList();
      if (trending.isNotEmpty) { // Fixed the missing dot
        trending.shuffle();
        return trending.take(5).toList();
      }
      return [];
    },
  );
});

// Add this new provider for managing search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Add a recentlyViewedServicesProvider to replace the undefined one
final recentlyViewedServicesProvider = StateNotifierProvider<RecentlyViewedServicesNotifier, List<ServiceModel>>((ref) {
  return RecentlyViewedServicesNotifier();
});

// Notifier class to manage recently viewed services
class RecentlyViewedServicesNotifier extends StateNotifier<List<ServiceModel>> {
  RecentlyViewedServicesNotifier() : super([]);

  void addService(ServiceModel service) {
    // Remove the service if it already exists to prevent duplicates
    state = state.where((s) => s.id != service.id).toList();
    
    // Add the service to the beginning of the list (most recent first)
    state = [service, ...state];
    
    // Limit the list to 10 items
    if (state.length > 10) {
      state = state.sublist(0, 10);
    }
  }

  void clearAll() {
    state = [];
  }
}

// Add this if servicesDataProvider is referenced elsewhere
final servicesDataProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return await repository.fetchServices();
});

// Fix the seasonal packages provider to use ServiceModel instead of Service
final seasonalPackagesProvider = Provider<List<ServiceModel>>((ref) {
  final servicesAsync = ref.watch(servicesProvider);
  
  return servicesAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (services) {
      // Get services suitable for seasonal packages
      // Filter maintenance services which are good candidates for seasonal packages
      final maintenanceServices = services.where((s) => s.category == 'Maintenance').toList();
      
      // Sort by popularity and take top 4 (with null safety)
      maintenanceServices.sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));
      return maintenanceServices.take(4).toList();
    },
  );
});
