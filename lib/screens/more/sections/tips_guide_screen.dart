import 'package:flutter/material.dart';

class TipsGuideScreen extends StatelessWidget {
  const TipsGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips & Guides'),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              child: const TabBar(
                tabs: [
                  Tab(text: 'Maintenance'),
                  Tab(text: 'Energy Saving'),
                  Tab(text: 'Safety'),
                ],
                labelColor: Colors.blue,
                indicatorColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Maintenance Tips
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildTipCard(
                        context: context,
                        title: 'Regular Cleaning',
                        description: 'Clean your solar panels at least 3-4 times a year to remove dust, pollen, bird droppings, and other debris that can reduce efficiency.',
                        iconData: Icons.cleaning_services,
                        color: Colors.blue,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Visual Inspection',
                        description: 'Perform a monthly visual inspection to check for damage, cracks, discoloration, or any debris. Look for signs of pest nesting or loose wiring.',
                        iconData: Icons.visibility,
                        color: Colors.green,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Trim Nearby Trees',
                        description: 'Keep trees trimmed to prevent shading of your solar panels. Even partial shading can significantly reduce overall system output.',
                        iconData: Icons.nature,
                        color: Colors.brown,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Monitor Performance',
                        description: 'Regularly check your system\'s performance data to spot any unexpected drops in energy production that might indicate a problem.',
                        iconData: Icons.analytics_outlined, // Changed from Icons.monitoringutlined, // Changed from Icons.monitoring
                        color: Colors.orange,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Inverter Care',
                        description: 'Keep the area around your inverter well-ventilated, clean, and free from dust. Overheating can reduce inverter lifespan and efficiency.',
                        iconData: Icons.electric_bolt,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  
                  // Energy Saving Tips
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildTipCard(
                        context: context,
                        title: 'Time Your Usage',
                        description: 'Schedule high-energy tasks like washing or charging devices during peak sunlight hours to use direct solar power rather than stored energy.',
                        iconData: Icons.schedule,
                        color: Colors.purple,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'LED Lighting',
                        description: 'Replace all lights with LED bulbs to reduce electricity consumption by up to 75% compared to traditional incandescent lighting.',
                        iconData: Icons.lightbulb,
                        color: Colors.amber,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Smart Power Strips',
                        description: 'Use smart power strips to eliminate phantom energy usage from devices that consume power even when turned off.',
                        iconData: Icons.power,
                        color: Colors.teal,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Efficient Appliances',
                        description: 'When replacing appliances, choose energy-efficient models with high BEE star ratings to maximize your solar investment.',
                        iconData: Icons.kitchen,
                        color: Colors.blue,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Weather-Based Adjustments',
                        description: 'Adjust your energy usage based on weather forecasts. Plan high-consumption activities for sunny days and conserve during cloudy periods.',
                        iconData: Icons.wb_sunny,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  
                  // Safety Tips
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildTipCard(
                        context: context,
                        title: 'Shutdown Procedures',
                        description: 'Learn the proper shutdown procedures for your solar system in case of emergency or before attempting any maintenance.',
                        iconData: Icons.power_settings_new,
                        color: Colors.red,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Professional Repairs',
                        description: 'Never attempt to repair electrical components yourself. Always contact a certified solar technician for repairs.',
                        iconData: Icons.engineering,
                        color: Colors.orange,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Roof Safety',
                        description: 'If you need to access your roof for visual inspection, use proper safety equipment and never walk on the panels themselves.',
                        iconData: Icons.roofing,
                        color: Colors.brown,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Water and Electricity',
                        description: 'When cleaning panels, avoid using high-pressure water systems and ensure all electrical components are properly protected from water.',
                        iconData: Icons.water_drop,
                        color: Colors.blue,
                      ),
                      _buildTipCard(
                        context: context,
                        title: 'Weather Awareness',
                        description: 'Be aware of lightning and storms. During severe weather, monitor your system for any anomalies and follow manufacturer safety guidelines.',
                        iconData: Icons.thunderstorm,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Download comprehensive guide
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Downloading comprehensive solar care guide...')),
          );
        },
        icon: const Icon(Icons.download),
        label: const Text('Download Full Guide'),
      ),
    );
  }

  Widget _buildTipCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData iconData,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(iconData, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
