import 'package:flutter/material.dart';
import 'package:solcare_app4/screens/services/services_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcare_app4/screens/main_screen.dart'; // Add MainScreen import

class TopServicesSection extends ConsumerWidget {
  const TopServicesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List of top service categories with icons
    final topServices = [
      {'name': 'Panel Cleaning', 'icon': Icons.cleaning_services},
      {'name': 'Inspection', 'icon': Icons.search},
      {'name': 'Maintenance', 'icon': Icons.build_circle},
      {'name': 'Repairs', 'icon': Icons.build},
      {'name': 'Monitoring', 'icon': Icons.monitor},
      {'name': 'Installation', 'icon': Icons.precision_manufacturing},
      {'name': 'Emergency Fix', 'icon': Icons.emergency},
      {'name': 'Performance Check', 'icon': Icons.speed},
      {'name': 'Inverter Service', 'icon': Icons.electrical_services},
      {'name': 'System Upgrade', 'icon': Icons.upgrade},
      {'name': 'Troubleshooting', 'icon': Icons.report_problem},
      {'name': 'Remote Support', 'icon': Icons.support_agent},
      {'name': 'Efficiency Boost', 'icon': Icons.trending_up},
      {'name': 'Wiring Check', 'icon': Icons.cable},
      {'name': 'Waterproofing', 'icon': Icons.water_drop},
      {'name': 'Bird Protection', 'icon': Icons.pest_control},
      {'name': 'Shade Analysis', 'icon': Icons.wb_shade},
      {'name': 'Battery Service', 'icon': Icons.battery_charging_full},
      {'name': 'Health Check', 'icon': Icons.health_and_safety},
      {'name': 'Thermal Imaging', 'icon': Icons.thermostat},
      {'name': 'Mounting Fix', 'icon': Icons.settings_applications},
      {'name': 'Annual Plan', 'icon': Icons.calendar_today},
      {'name': 'Cleaning Kit', 'icon': Icons.cleaning_services_outlined},
      {'name': 'Monitoring Setup', 'icon': Icons.monitor_heart},
      {'name': 'Junction Box', 'icon': Icons.settings_input_component},
      {'name': 'Dust Removal', 'icon': Icons.air},
      {'name': 'Snow Removal', 'icon': Icons.ac_unit},
      {'name': 'Panel Tilt', 'icon': Icons.rotate_90_degrees_ccw},
      {'name': 'Pest Control', 'icon': Icons.bug_report},
      {'name': 'Vegetation', 'icon': Icons.grass},
      {'name': 'Panel Coating', 'icon': Icons.format_color_fill},
      {'name': 'Meter Check', 'icon': Icons.speed_outlined},
      {'name': 'Grid Connection', 'icon': Icons.grid_on},
      {'name': 'Parts Replace', 'icon': Icons.swap_horizontal_circle},
      {'name': 'Safety Check', 'icon': Icons.security},
      {'name': 'Full Diagnosis', 'icon': Icons.biotech},
    ];

    // Use a GridView.builder for the 2x4 grid
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: const [
                Icon(Icons.verified, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Our Top Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Replace fixed height container with LayoutBuilder for responsive grid
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive grid parameters
              final screenWidth = constraints.maxWidth;
              // Default to 4 columns for mobile (smallest screens)
              int crossAxisCount = 4;
              // On larger screens, increase columns
              if (screenWidth > 600) crossAxisCount = 4;
              if (screenWidth > 900) crossAxisCount = 4;
              
              // Always show exactly 12 items as requested
              const int itemsToShow = 8;
              
              // Adjust aspect ratio based on screen size for better appearance
              final childAspectRatio = screenWidth > 600 ? 1.3 : 1.2;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: itemsToShow,
                  itemBuilder: (context, index) {
                    // Using only the first 12 services from our list
                    final service = topServices[index];
                    
                    return InkWell(
                      onTap: () {
                        // Navigate to services tab
                        MainScreen.navigateToServicesTab(context);
                      },
                      child: Card(
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              service['icon'] as IconData,
                              size: screenWidth > 600 ? 28 : 24,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                service['name'] as String,
                                style: TextStyle(
                                  fontSize: screenWidth > 600 ? 13 : 12,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
