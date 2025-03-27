import 'package:solcare_app4/models/service_model.dart';

class CartItemModel {
  final ServiceModel service;
  final int quantity;

  CartItemModel({
    required this.service,
    required this.quantity,
  });
  
  double get totalPrice => service.price * quantity;
}
