import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:solcare_app4/widgets/solar_health_card.dart';

class CarouselSection extends StatelessWidget {
  const CarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _carouselItems = [
      {
        'title': 'Check Solar Health',
        'description': 'Get a detailed report on your solar system\'s efficiency.',
        'icon': Icons.health_and_safety,
        'color': Colors.blue,
      },
      {
        'title': 'Solar Panel Cleaning',
        'description': 'Calculate optimal cleaning schedule for your panels.',
        'icon': Icons.cleaning_services,
        'color': Colors.green,
      },
      {
        'title': 'Inverter Check-Up',
        'description': 'Test your inverter\'s performance and efficiency.',
        'icon': Icons.bolt,
        'color': Colors.amber,
      },
      {
        'title': 'Maintenance Cost Estimator',
        'description': 'Calculate your solar maintenance expenses.',
        'icon': Icons.calculate,
        'color': Colors.purple,
      },
      {
        'title': 'Energy Savings Estimator',
        'description': 'See how much you save with solar power.',
        'icon': Icons.savings,
        'color': Colors.teal,
      },
      {
        'title': 'CO₂ Emissions Reduction',
        'description': 'Calculate your environmental impact with solar.',
        'icon': Icons.eco,
        'color': Colors.lightGreen,
      },
    ];
    
    return SizedBox(
      height: 180,
      child: CarouselSlider.builder(
        itemCount: _carouselItems.length,
        itemBuilder: (context, index, realIndex) {
          final item = _carouselItems[index];
          return SolarHealthCard(
            title: item['title'],
            description: item['description'],
            icon: item['icon'],
            color: item['color'],
            onTap: () {
              // Navigate to the specific calculator/tool
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${item['title']}...'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
        options: CarouselOptions(
          height: 180,
          aspectRatio: 16/9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
