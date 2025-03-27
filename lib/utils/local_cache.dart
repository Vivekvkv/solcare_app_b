import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A utility class for caching data locally.
class LocalCache {
  static final Map<String, dynamic> _memoryCache = {};
  
  /// Checks if a key exists in the cache
  static bool containsKey(String key) {
    return _memoryCache.containsKey(key);
  }
  
  /// Gets a value from the cache
  static dynamic get(String key) {
    return _memoryCache[key];
  }
  
  /// Puts a value in the cache
  static Future<void> put(String key, dynamic value) async {
    _memoryCache[key] = value;
    
    // Also store in persistent storage if possible
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is List || value is Map) {
        await prefs.setString(key, jsonEncode(value));
      } else if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      }
    } catch (e) {
      print('Error storing in shared preferences: $e');
    }
  }
  
  /// Clears the cache
  static Future<void> clear() async {
    _memoryCache.clear();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing shared preferences: $e');
    }
  }
  
  /// Removes a key from the cache
  static Future<void> remove(String key) async {
    _memoryCache.remove(key);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      print('Error removing from shared preferences: $e');
    }
  }
}
