import 'package:flutter/material.dart';

class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? profileImage;
  final int rewardPoints;
  final List<String> savedLocations;
  final List<String> paymentMethods;
  final String subscriptionType;
  final DateTime subscriptionExpiry;
  
  // Add new properties for solar system info
  final String? solarSystemSize;
  final String? numberOfPanels;
  final String? panelType;
  final String? inverterSize;
  final String? panelBrand;
  final String? subscriptionPlan;
  final String id; // Add this for the referral code

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImage,
    required this.rewardPoints,
    required this.savedLocations,
    required this.paymentMethods,
    required this.subscriptionType,
    required this.subscriptionExpiry,
    this.solarSystemSize,
    this.numberOfPanels,
    this.panelType,
    this.inverterSize,
    this.panelBrand,
    this.subscriptionPlan,
    required this.id,
  });

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImage,
    int? rewardPoints,
    List<String>? savedLocations,
    List<String>? paymentMethods,
    String? subscriptionType,
    DateTime? subscriptionExpiry,
    String? solarSystemSize,
    String? numberOfPanels,
    String? panelType,
    String? inverterSize,
    String? panelBrand,
    String? subscriptionPlan,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      savedLocations: savedLocations ?? this.savedLocations,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      solarSystemSize: solarSystemSize ?? this.solarSystemSize,
      numberOfPanels: numberOfPanels ?? this.numberOfPanels,
      panelType: panelType ?? this.panelType,
      inverterSize: inverterSize ?? this.inverterSize,
      panelBrand: panelBrand ?? this.panelBrand,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      id: this.id,
    );
  }
}
