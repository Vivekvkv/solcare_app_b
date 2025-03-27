import 'package:flutter/material.dart';
import 'package:solcare_app4/models/cart_item_model.dart';
import 'package:solcare_app4/models/service_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItemModel> _items = [];
  double _systemSizeKW = 5.0; // Default system size
  
  List<CartItemModel> get items => [..._items];
  
  int get itemCount => _items.length;
  
  double get systemSizeKW => _systemSizeKW;
  
  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (getAdjustedPrice(item.service) * item.quantity));
  }
  
  // Get price adjusted for system size
  double getAdjustedPrice(ServiceModel service) {
    // Base price for typical 5kW system
    double basePrice = service.price;
    
    // For system sizes different from 5kW, adjust price accordingly
    // Different service types might scale differently with system size
    if (_systemSizeKW != 5.0) {
      double scaleFactor;
      
      // Apply different scaling based on service category
      switch (service.category.toLowerCase()) {
        case 'cleaning':
          // Cleaning scales more directly with system size
          scaleFactor = _systemSizeKW / 5.0;
          break;
        case 'inspection':
          // Inspection doesn't scale as much with size
          scaleFactor = 0.7 + (0.3 * _systemSizeKW / 5.0);
          break;
        case 'maintenance':
          scaleFactor = 0.6 + (0.4 * _systemSizeKW / 5.0);
          break;
        case 'repair':
          // Repairs have a base cost plus variable component
          scaleFactor = 0.5 + (0.5 * _systemSizeKW / 5.0);
          break;
        default:
          // Default scaling formula
          scaleFactor = 0.8 + (0.2 * _systemSizeKW / 5.0);
      }
      
      return basePrice * scaleFactor;
    }
    
    return basePrice;
  }
  
  void setSystemSize(double sizekW) {
    _systemSizeKW = sizekW;
    notifyListeners();
  }
  
  void addItem(ServiceModel service) {
    final existingIndex = _items.indexWhere((item) => item.service.id == service.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex] = CartItemModel(
        service: _items[existingIndex].service,
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(CartItemModel(
        service: service,
        quantity: 1,
      ));
    }
    
    notifyListeners();
  }
  
  void removeItem(String serviceId) {
    _items.removeWhere((item) => item.service.id == serviceId);
    notifyListeners();
  }
  
  void decreaseQuantity(String serviceId) {
    final existingIndex = _items.indexWhere((item) => item.service.id == serviceId);
    
    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex] = CartItemModel(
          service: _items[existingIndex].service,
          quantity: _items[existingIndex].quantity - 1,
        );
      } else {
        _items.removeAt(existingIndex);
      }
      
      notifyListeners();
    }
  }
  
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
