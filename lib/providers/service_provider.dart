import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service.dart';
import 'package:solcare_app4/models/service_model.dart';

class ServiceProvider with ChangeNotifier {
  final List<Service> _services = [
    // Cleaning Services
    Service(id: 1, name: 'Standard Solar Panel Cleaning', category: 'Cleaning', price: 599, discount: 10, rating: 4.5, popularity: 5),
    Service(id: 2, name: 'Deep Solar Panel Cleaning', category: 'Cleaning', price: 899, discount: 15, rating: 4.7, popularity: 4),
    Service(id: 3, name: 'Solar Mirror Cleaning', category: 'Cleaning', price: 499, discount: 5, rating: 4.3, popularity: 4),
    Service(id: 4, name: 'Eco-Friendly Solar Cleaning', category: 'Cleaning', price: 699, discount: 10, rating: 4.6, popularity: 5),
    Service(id: 5, name: 'High Pressure Solar Panel Cleaning', category: 'Cleaning', price: 999, discount: 20, rating: 4.8, popularity: 5),
    Service(id: 6, name: 'Water-Free Solar Panel Cleaning', category: 'Cleaning', price: 1299, discount: 5, rating: 4.9, popularity: 3),
    Service(id: 7, name: 'Seasonal Solar Panel Cleaning', category: 'Cleaning', price: 799, discount: 0, rating: 4.2, popularity: 4),
    Service(id: 8, name: 'Bi-Annual Solar Panel Cleaning', category: 'Cleaning', price: 1199, discount: 10, rating: 4.4, popularity: 3),
    Service(id: 9, name: 'Residential Solar Panel Cleaning', category: 'Cleaning', price: 549, discount: 5, rating: 4.3, popularity: 5),
    Service(id: 10, name: 'Commercial Solar Panel Cleaning', category: 'Cleaning', price: 1999, discount: 15, rating: 4.6, popularity: 4),
    
    // Maintenance Services
    Service(id: 11, name: 'Basic Solar System Maintenance', category: 'Maintenance', price: 899, discount: 0, rating: 4.4, popularity: 5),
    Service(id: 12, name: 'Comprehensive Maintenance Package', category: 'Maintenance', price: 1999, discount: 10, rating: 4.8, popularity: 4),
    Service(id: 13, name: 'Inverter Maintenance', category: 'Maintenance', price: 599, discount: 0, rating: 4.2, popularity: 3),
    Service(id: 14, name: 'Solar Battery Maintenance', category: 'Maintenance', price: 799, discount: 5, rating: 4.5, popularity: 4),
    Service(id: 15, name: 'Annual Maintenance Contract (AMC)', category: 'Maintenance', price: 2999, discount: 20, rating: 4.9, popularity: 5),
    Service(id: 16, name: 'Quarterly Maintenance Package', category: 'Maintenance', price: 1499, discount: 10, rating: 4.6, popularity: 3),
    Service(id: 17, name: 'Solar Mounting System Maintenance', category: 'Maintenance', price: 699, discount: 0, rating: 4.3, popularity: 3),
    Service(id: 18, name: 'Wiring and Connection Maintenance', category: 'Maintenance', price: 599, discount: 0, rating: 4.1, popularity: 2),
    Service(id: 19, name: 'Emergency Maintenance Service', category: 'Maintenance', price: 1299, discount: 0, rating: 4.7, popularity: 4),
    Service(id: 20, name: 'Solar Water Heater Maintenance', category: 'Maintenance', price: 899, discount: 5, rating: 4.4, popularity: 3),
    
    // Optimization Services
    Service(id: 21, name: 'Solar Panel Performance Optimization', category: 'Optimization', price: 1499, discount: 10, rating: 4.7, popularity: 4),
    Service(id: 22, name: 'System Output Efficiency Enhancement', category: 'Optimization', price: 1999, discount: 15, rating: 4.8, popularity: 5),
    Service(id: 23, name: 'Energy Usage Analysis & Optimization', category: 'Optimization', price: 999, discount: 0, rating: 4.5, popularity: 4),
    Service(id: 24, name: 'Panel Angle Optimization', category: 'Optimization', price: 599, discount: 0, rating: 4.3, popularity: 3),
    Service(id: 25, name: 'Solar Tracking System Installation', category: 'Optimization', price: 3999, discount: 20, rating: 4.9, popularity: 4),
    Service(id: 26, name: 'Shade Analysis & Mitigation', category: 'Optimization', price: 899, discount: 5, rating: 4.4, popularity: 3),
    Service(id: 27, name: 'Inverter Efficiency Optimization', category: 'Optimization', price: 1299, discount: 10, rating: 4.6, popularity: 4),
    Service(id: 28, name: 'Battery Storage Optimization', category: 'Optimization', price: 1599, discount: 5, rating: 4.7, popularity: 3),
    Service(id: 29, name: 'Smart Energy Management Setup', category: 'Optimization', price: 2299, discount: 15, rating: 4.8, popularity: 5),
    Service(id: 30, name: 'Load Balancing Optimization', category: 'Optimization', price: 799, discount: 0, rating: 4.2, popularity: 3),
    
    // Inspection Services
    Service(id: 31, name: 'Comprehensive Solar System Inspection', category: 'Inspection', price: 999, discount: 10, rating: 4.6, popularity: 5),
    Service(id: 32, name: 'Thermal Imaging Inspection', category: 'Inspection', price: 1499, discount: 15, rating: 4.8, popularity: 4),
    Service(id: 33, name: 'Electrical Safety Inspection', category: 'Inspection', price: 799, discount: 0, rating: 4.5, popularity: 4),
    Service(id: 34, name: 'Pre-Purchase Solar System Inspection', category: 'Inspection', price: 1299, discount: 5, rating: 4.7, popularity: 3),
    Service(id: 35, name: 'Annual System Performance Audit', category: 'Inspection', price: 1999, discount: 20, rating: 4.9, popularity: 5),
    Service(id: 36, name: 'Post-Installation Quality Inspection', category: 'Inspection', price: 699, discount: 0, rating: 4.4, popularity: 4),
    Service(id: 37, name: 'Insurance Compliance Inspection', category: 'Inspection', price: 899, discount: 0, rating: 4.3, popularity: 3),
    Service(id: 38, name: 'Warranty Claim Inspection', category: 'Inspection', price: 599, discount: 0, rating: 4.2, popularity: 3),
    Service(id: 39, name: 'Roof Integrity & Mounting Inspection', category: 'Inspection', price: 749, discount: 5, rating: 4.4, popularity: 4),
    Service(id: 40, name: 'Drone-Based Solar Panel Inspection', category: 'Inspection', price: 1699, discount: 10, rating: 4.8, popularity: 4),
    
    // Repair Services
    Service(id: 41, name: 'Solar Panel Replacement', category: 'Repair', price: 2499, discount: 10, rating: 4.7, popularity: 5),
    Service(id: 42, name: 'Inverter Repair/Replacement', category: 'Repair', price: 1999, discount: 15, rating: 4.8, popularity: 5),
    Service(id: 43, name: 'Solar Battery Replacement', category: 'Repair', price: 3999, discount: 20, rating: 4.9, popularity: 4),
    Service(id: 44, name: 'Wiring & Connection Repair', category: 'Repair', price: 799, discount: 0, rating: 4.4, popularity: 4),
    Service(id: 45, name: 'Mounting Structure Repair', category: 'Repair', price: 1199, discount: 5, rating: 4.5, popularity: 3),
    Service(id: 46, name: 'Water Damage Repair', category: 'Repair', price: 1499, discount: 10, rating: 4.6, popularity: 4),
    Service(id: 47, name: 'Micro-Inverter Replacement', category: 'Repair', price: 999, discount: 0, rating: 4.5, popularity: 3),
    Service(id: 48, name: 'Junction Box Repair', category: 'Repair', price: 599, discount: 0, rating: 4.2, popularity: 3),
    Service(id: 49, name: 'Emergency Repair Service', category: 'Repair', price: 1799, discount: 0, rating: 4.7, popularity: 5),
    Service(id: 50, name: 'Solar Tracking System Repair', category: 'Repair', price: 2299, discount: 15, rating: 4.8, popularity: 4),
  ];

    List<Service> get services => [..._services];

  Service findById(int id) {
    return _services.firstWhere((service) => service.id == id);
  }

  // Convert Service to ServiceModel
  ServiceModel _convertToServiceModel(Service service) {
    return ServiceModel(
      id: service.id.toString(),
      name: service.name,
      description: 'Detailed description for ${service.name}',
      shortDescription: 'Short description for ${service.name}',
      price: service.price,
      image: 'assets/images/service_${service.id}.jpg', // Default image path
      category: service.category,
      duration: '${service.id % 3 + 1} hours', // Generate a sample duration
      popularity: service.popularity.toDouble(),
      discount: service.discount, // Include the discount value
    );
  }

  // Add the missing getDiscount method
  int getDiscount(ServiceModel service) {
    final int intId = int.tryParse(service.id) ?? 1;
    final Service originalService = findById(intId);
    return originalService.discount;
  }

  // Get a service model by ID
  ServiceModel getServiceById(String id) {
    final int intId = int.tryParse(id) ?? 1;
    final Service service = findById(intId);
    return _convertToServiceModel(service);
  }

  // Get trending services as ServiceModel objects
  List<ServiceModel> get trendingServices {
    // Sort services by popularity in descending order
    List<Service> sortedServices = [..._services];
    sortedServices.sort((a, b) => b.popularity.compareTo(a.popularity));

    // Convert Service objects to ServiceModel objects and return top 5
    return sortedServices.take(5).map((service) => _convertToServiceModel(service)).toList();
  }
  
  // Add the missing featuredServices getter
  List<ServiceModel> get featuredServices {
    // Filter services with high ratings and discounts to feature them
    List<Service> featuredServices = _services.where((service) => 
      service.rating >= 4.5 && service.discount > 0
    ).toList();
    
    // Sort by a combination of rating and discount to prioritize best deals
    featuredServices.sort((a, b) => 
      ((b.rating * 10) + b.discount).compareTo((a.rating * 10) + a.discount)
    );
    
    // Return top 6 featured services converted to ServiceModel
    return featuredServices.take(6).map((service) => _convertToServiceModel(service)).toList();
  }

  // Get all services as ServiceModel objects
  List<ServiceModel> get allServices {
    // Convert all Service objects to ServiceModel objects
    return _services.map((service) => _convertToServiceModel(service)).toList();
  }
}