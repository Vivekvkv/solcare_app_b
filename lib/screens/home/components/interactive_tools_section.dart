import 'package:flutter/material.dart';
import 'tools/advanced_solar_health_calculator.dart';
import 'tools/roi_calculator.dart';
import 'tools/trees_saved_calculator.dart';
import 'tools/carbon_footprint_calculator.dart';

class InteractiveToolsSection extends StatelessWidget {
  const InteractiveToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interactive Tools',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildToolCard(
                  context,
                  'Solar Health',
                  'Check your system health',
                  Icons.health_and_safety,
                  Colors.green.shade100,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdvancedSolarHealthCalculator(),
                    ),
                  ),
                ),
                _buildToolCard(
                  context,
                  'ROI Calculator',
                  'Calculate investment returns',
                  Icons.monetization_on,
                  Colors.blue.shade100,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ROICalculator(),
                    ),
                  ),
                ),
                _buildToolCard(
                  context,
                  'Trees Saved',
                  'Environmental impact',
                  Icons.nature,
                  Colors.brown.shade100,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TreesSavedCalculator(),
                    ),
                  ),
                ),
                _buildToolCard(
                  context,
                  'Carbon Footprint',
                  'Your climate contribution',
                  Icons.co2,
                  Colors.orange.shade100,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarbonFootprintCalculator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildToolCard(
    BuildContext context, 
    String title, 
    String description, 
    IconData icon, 
    Color bgColor, 
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: bgColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: iconColor),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
