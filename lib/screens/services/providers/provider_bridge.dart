import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/providers/services_providers.dart';

/// This class acts as a bridge between Riverpod providers and Consumer widgets
/// It allows us to use the providers in widgets that aren't wrapped in a Riverpod Consumer
class ServiceProviderBridge {
  final WidgetRef ref;
  
  ServiceProviderBridge(this.ref);
  
  List<ServiceModel> getPopularServices() {
    return ref.read(popularServicesProvider);
  }
  
  List<ServiceModel> getTrendingServices() {
    return ref.read(trendingServicesProvider);
  }
  
  List<ServiceModel> getRecentlyViewedServices() {
    return ref.read(recentlyViewedServicesProvider);
  }
  
  Future<List<ServiceModel>> getNearbyServices() async {
    return ref.read(nearbyServicesProvider.future);
  }
  
  Future<List<ServiceModel>> getServices() async {
    return ref.read(servicesProvider.future);
  }
  
  void addRecentlyViewedService(ServiceModel service) {
    ref.read(recentlyViewedServicesProvider.notifier).addService(service);
  }
  
  void clearRecentlyViewedServices() {
    ref.read(recentlyViewedServicesProvider.notifier).clearAll();
  }
  
  void updateSearchQuery(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }
  
  String getSearchQuery() {
    return ref.read(searchQueryProvider);
  }
}
