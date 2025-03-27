import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/service_provider.dart';
import 'package:solcare_app4/widgets/service_card.dart';
import 'package:solcare_app4/models/service_model.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'All';
  String _sortBy = 'Popularity';

  final List<String> _categories = [
    'All',
    'Cleaning',
    'Maintenance',
    'Optimization',
    'Inspection',
    'Repair',
  ];

  final List<String> _sortOptions = [
    'Popularity',
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
  ];

  // Helper method to convert Service to ServiceModel with demo data
  ServiceModel _createServiceModel(dynamic service) {
    return ServiceModel(
      id: service.id.toString(),
      name: service.name,
      description: "Professional solar panel service with guaranteed results", 
      price: service.price,
      image: "assets/images/service_${service.id}.jpg",
      category: service.category,
      popularity: service.popularity is int ? service.popularity.toDouble() : service.popularity,
      shortDescription: "Quick and efficient ${service.name.toLowerCase()} service",
      duration: "60",
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    var services = serviceProvider.services;
    
    // Apply category filter
    if (_selectedCategory != 'All') {
      services = services
          .where((service) => service.category == _selectedCategory)
          .toList();
    }
    
    // Apply sorting
    switch (_sortBy) {
      case 'Price: Low to High':
        services.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        services.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Popularity':
        services.sort((a, b) => b.popularity.compareTo(a.popularity));
        break;
      case 'Newest':
        // In a real app, this would sort by creation date if available
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha:0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Sort dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Found ${services.length} services',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _sortBy,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _sortBy = newValue;
                      });
                    }
                  },
                  items: _sortOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // Services grid
          Expanded(
            child: services.isEmpty
                ? const Center(
                    child: Text('No services found in this category'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: services.length,
                    itemBuilder: (ctx, i) => ServiceCard(
                      service: _createServiceModel(services[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
