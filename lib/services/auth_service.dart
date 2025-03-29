import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common/app_constant.dart';
import '../models/auth_token_model.dart';
import '../models/user_me_model.dart';

class ApiClient {
  // Base URL is handled by AppConstant
  static final String _baseUrl = AppConstant.baseUrl1;

  // Method to login using http
  static Future<AuthToken> login({
    required String mobileNumber
    // required String username,
    // required String password,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/auth/send-otp');

    // Send a POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'mobileNumber': mobileNumber.toString(),
      }),
    );
    // final response = await http.post(
    //   url,
    //   body: <String, String>{
    //     'username': username,
    //     'password': password,
    //   },
    // );


    // Check if response status is OK (200)
    if (response.statusCode == 200) {
      // Parse the response data
      return AuthToken.fromJson(json.decode(response.body));
    } else {
      // Handle error, maybe throw an exception
      throw Exception('Failed to login');
    }
  }

  // Method to get the user details
  static Future<UsersMe> getMe(String token) async {
    assert(token.isNotEmpty);

    final Uri url = Uri.parse('$_baseUrl/wp/v2/users/me');

    // Send a GET request with authorization header
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    // Check if response status is OK (200)
    if (response.statusCode == 200) {
      // Parse the response data
      return UsersMe.fromJson(json.decode(response.body));
    } else {
      // Handle error, maybe throw an exception
      throw Exception('Failed to load user data');
    }
  }
}