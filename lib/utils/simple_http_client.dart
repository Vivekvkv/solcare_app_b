import 'dart:math';

/// A simple mock HTTP client for demo purposes
class SimpleHttpClient {
  final Random _random = Random();
  
  /// Simulates an HTTP GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));
    
    // Mock response based on endpoint
    if (endpoint == 'api/services') {
      return {
        'status': 'success',
        'data': _generateMockServiceData(),
      };
    }
    
    // Default response
    return {
      'status': 'error',
      'message': 'Endpoint not found',
    };
  }
  
  /// Generates mock service data
  List<Map<String, dynamic>> _generateMockServiceData() {
    // Generate mock service data similar to what the API would return
    return List.generate(20, (index) => {
      'id': 'service_${index + 1}',
      'name': 'Service ${index + 1}',
      'description': 'Description for service ${index + 1}',
      'shortDescription': 'Short description for service ${index + 1}',
      'price': (_random.nextDouble() * 5000 + 500).roundToDouble(),
      'image': 'assets/images/service_${(index % 10) + 1}.jpg',
      'category': ['Cleaning', 'Maintenance', 'Repair', 'Installation'][index % 4],
      'duration': '${(index % 3) + 1} hours',
      'popularity': (_random.nextDouble() * 3 + 2).roundToDouble(),
      'discount': _random.nextInt(20),
    });
  }
  
  /// Simulates an HTTP POST request
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));
    
    // Default response
    return {
      'status': 'success',
      'data': {'id': 'mock_id_${_random.nextInt(1000)}', ...data},
    };
  }
}
