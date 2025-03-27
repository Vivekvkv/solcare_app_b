import 'package:flutter/material.dart';

class LocationBasedSuggestions extends StatelessWidget {
  const LocationBasedSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock location data - in a real app, this would come from user's location
    const userLocation = 'Mumbai, Maharashtra';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.teal.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.teal),
              const SizedBox(width: 8),
              const Text(
                'Suggested for your area',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Chip(
                label: const Text(userLocation),
                backgroundColor: Colors.white,
                avatar: const Icon(Icons.location_city, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'These services are popular in your location:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          
          // Location-specific recommendations
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip('Monsoon Ready Cleaning'),
              _buildSuggestionChip('Dust Protection'),
              _buildSuggestionChip('UV Coating'),
              _buildSuggestionChip('High Wind Inspection'),
              _buildSuggestionChip('Coastal Area Maintenance'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuggestionChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        // Navigate to service details or filter by this suggestion
      },
      avatar: const Icon(Icons.trending_up, size: 16),
    );
  }
}
