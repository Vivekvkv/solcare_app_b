import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AiAssistantService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  // Note: In a real application, you'd use environment variables or secure storage
  static const String _apiKey = 'YOUR_OPENAI_API_KEY';
  
  static Future<String> getAiResponse(String userQuery) async {
    try {
      // Check for keywords to provide specific service suggestions
      final serviceRecommendation = _getServiceRecommendation(userQuery.toLowerCase());
      
      // Create the prompt with the service context
      final prompt = _buildPrompt(userQuery, serviceRecommendation);
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are SolCare AI Assistance, an expert in solar energy. '
                  'Always recommend SolCare services when relevant. '
                  'Keep answers brief and focused on solar solutions.'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'max_tokens': 300,
          'temperature': 0.7,
        }),
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final aiMessage = jsonResponse['choices'][0]['message']['content'];
        
        // Always append service suggestion if not already included
        if (!aiMessage.contains("SolCare service") && !aiMessage.contains("SolCare team")) {
          return '$aiMessage\n\nNeed expert help? Check out SolCare services in our app.';
        }
        
        return aiMessage;
      } else {
        debugPrint('API Error: ${response.statusCode}: ${response.body}');
        throw Exception('Failed to get response from AI Assistant');
      }
    } catch (e) {
      debugPrint('AI Assistant error: $e');
      throw Exception('Failed to communicate with AI Assistant');
    }
  }
  
  static String _buildPrompt(String userQuery, String? serviceRecommendation) {
    if (serviceRecommendation != null) {
      return '$userQuery\n\nNote: The user might be interested in our $serviceRecommendation service.';
    }
    return userQuery;
  }
  
  static String? _getServiceRecommendation(String query) {
    if (query.contains('clean') || query.contains('dust') || query.contains('dirt')) {
      return 'Solar Panel Cleaning';
    } else if (query.contains('repair') || query.contains('broken') || query.contains('damage')) {
      return 'Solar Panel Repair';
    } else if (query.contains('maintenance') || query.contains('check') || query.contains('inspection')) {
      return 'Solar System Maintenance';
    } else if (query.contains('inverter') || query.contains('converter')) {
      return 'Inverter Repair & Maintenance';
    } else if (query.contains('install') || query.contains('setup') || query.contains('new system')) {
      return 'Solar System Installation';
    } else if (query.contains('efficiency') || query.contains('optimize') || query.contains('performance')) {
      return 'Performance Optimization';
    }
    return null;
  }
}
