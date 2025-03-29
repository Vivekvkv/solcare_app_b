import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:solcare_app4/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../models/auth_token_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {

  String? _token;
  late final SharedPreferences _preferences;

  String? get token => _token;
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(AppConstant.keyToken);
  }

  Future<AuthToken> login({
    required String mobileNumber,
   // required String password,
  }) async {
    AuthToken auth = await ApiClient.login(
      mobileNumber: mobileNumber
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

}
