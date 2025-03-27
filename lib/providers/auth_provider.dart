import 'package:flutter/material.dart';
import 'package:solcare_app4/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../models/auth_token_model.dart';
import '../services/auth_service.dart';

class ProfileProvider with ChangeNotifier {

  String? _token;
  late final SharedPreferences _preferences;

  String? get token => _token;
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(AppConstant.keyToken);
  }

  Future<AuthToken> login({
    required String username,
    required String password,
  }) async {
    AuthToken auth = await ApiClient.login(
      username: username,
      password: password,
    );
    _token = auth.token;
    if (auth.token != null) {
      await _preferences.setString(
        AppConstant.keyToken,
        auth.token!,
      );
    }
    notifyListeners();
    return auth;
  }



  ProfileModel _profile = ProfileModel(
    id: 'default_user_id',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+91 9876543210',
    address: '123 Solar Avenue, Green City',
    profileImage: null,
    rewardPoints: 150,
    savedLocations: [
      'Home: 123 Solar Avenue, Green City',
      'Office: 456 Eco Park, Sustainable Heights',
    ],
    paymentMethods: [
      'XXXX XXXX XXXX 4321 (VISA)',
      'john.doe@upi',
    ],
    subscriptionType: 'Premium',
    subscriptionExpiry: DateTime.now().add(const Duration(days: 180)),
  );

  ProfileProvider() {
    // Initialize with default profile
    _profile = ProfileModel(
      id: 'user_1', // Added the required id parameter
      name: 'Rajesh Kumar',
      email: 'rajesh.kumar@example.com',
      phone: '+91 98765-43210',
      address: '123 Solar Avenue, Indore, MP',
      profileImage: '',
      rewardPoints: 250,
      savedLocations: ['Home', 'Office'],
      paymentMethods: ['Credit Card', 'UPI'],
      subscriptionType: 'Pro',
      subscriptionExpiry: DateTime.now().add(const Duration(days: 365)),
      solarSystemSize: '5.8',
      numberOfPanels: '24',
      panelType: 'Monocrystalline',
      inverterSize: '5.0',
      panelBrand: 'SunPower',
      subscriptionPlan: 'Yearly',
    );
  }
  
  ProfileModel get profile => _profile;
  
  void updateProfile(ProfileModel updatedProfile) {
    _profile = updatedProfile;
    notifyListeners();
  }
  
  void updateName(String name) {
    _profile = _profile.copyWith(name: name);
    notifyListeners();
  }
  
  void updateEmail(String email) {
    _profile = _profile.copyWith(email: email);
    notifyListeners();
  }
  
  void updatePhone(String phone) {
    _profile = _profile.copyWith(phone: phone);
    notifyListeners();
  }
  
  void updateAddress(String address) {
    _profile = _profile.copyWith(address: address);
    notifyListeners();
  }
  
  void updateProfileImage(String? profileImagePath) {
    _profile = _profile.copyWith(profileImage: profileImagePath);
    notifyListeners();
  }
  
  void addRewardPoints(int points) {
    _profile = _profile.copyWith(rewardPoints: _profile.rewardPoints + points);
    notifyListeners();
  }
  
  void addSavedLocation(String location) {
    final updatedLocations = List<String>.from(_profile.savedLocations)..add(location);
    _profile = _profile.copyWith(savedLocations: updatedLocations);
    notifyListeners();
  }
  
  void addPaymentMethod(String paymentMethod) {
    final updatedPaymentMethods = List<String>.from(_profile.paymentMethods)..add(paymentMethod);
    _profile = _profile.copyWith(paymentMethods: updatedPaymentMethods);
    notifyListeners();
  }
  
  void updateSubscription(String type, DateTime expiry) {
    _profile = _profile.copyWith(
      subscriptionType: type,
      subscriptionExpiry: expiry,
    );
    notifyListeners();
  }

  void updateSolarSystemInfo({
    required String systemSize,
    required String panelCount,
    required String panelType,
    required String inverterSize,
    required String panelBrand,
  }) {
    _profile = _profile.copyWith(
      solarSystemSize: systemSize,
      numberOfPanels: panelCount,
      panelType: panelType,
      inverterSize: inverterSize,
      panelBrand: panelBrand,
    );
    notifyListeners();
  }
}
