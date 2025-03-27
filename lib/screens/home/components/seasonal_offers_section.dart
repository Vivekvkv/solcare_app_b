import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeasonalOffersSection extends StatelessWidget {
  const SeasonalOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    // List of seasonal offers with their details
    final List<Map<String, dynamic>> offers = [
      {
        'title': 'Welcome Discount',
        'description': 'Get 15% off on your first service booking',
        'code': 'WELCOME15',
        'validUntil': 'No expiry',
        'color': const Color(0xFF5C6BC0), // Indigo
        'icon': Icons.celebration,
      },
      {
        'title': 'Summer Special',
        'description': 'Keep your panels clean with 20% off on all cleaning services',
        'code': 'SUMMER20',
        'validUntil': 'Valid till 31st August',
        'color': const Color(0xFFFFA726), // Orange
        'icon': Icons.wb_sunny,
      },
      {
        'title': 'Holi Festival Offer',
        'description': 'Colorful savings of 25% on maintenance packages',
        'code': 'HOLI25',
        'validUntil': 'Valid till 15th March',
        'color': const Color(0xFF42A5F5), // Blue
        'icon': Icons.color_lens,
      },
      {
        'title': 'Monsoon Ready',
        'description': '10% off on weatherproofing services',
        'code': 'MONSOON10',
        'validUntil': 'Valid till 30th June',
        'color': const Color(0xFF66BB6A), // Green
        'icon': Icons.water_drop,
      },
      {
        'title': 'Diwali Discount',
        'description': 'Brighten your solar setup with 30% off on performance checks',
        'code': 'DIWALI30',
        'validUntil': 'Valid till 5th November',
        'color': const Color(0xFFEF5350), // Red
        'icon': Icons.local_fire_department,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Seasonal Offers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.local_offer),
                label: const Text('View All'),
                onPressed: () {
                  // Navigate to all offers page (could be implemented later)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All offers page coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        
        // Horizontal scrollable offer cards
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Copy promo code to clipboard
                    Clipboard.setData(ClipboardData(text: offer['code']));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Promo code ${offer['code']} copied to clipboard!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          offer['color'],
                          offer['color'].withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: offer['color'].withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background pattern for visual interest
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            offer['icon'],
                            size: 120,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        // Offer content
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    offer['icon'],
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    offer['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                offer['description'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      offer['code'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: offer['color'],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.copy,
                                      size: 14,
                                      color: offer['color'],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                offer['validUntil'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
