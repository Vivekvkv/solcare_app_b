import 'package:flutter/material.dart';

class FilterPanel extends StatefulWidget {
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;

  const FilterPanel({
    Key? key,
    required this.onApplyFilters,
    required this.onResetFilters,
  }) : super(key: key);

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  RangeValues _priceRange = const RangeValues(0, 5000);
  double _rating = 3.0;
  List<String> _selectedCategories = [];
  
  final List<String> _categories = [
    'Cleaning',
    'Maintenance',
    'Optimization',
    'Inspection',
    'Installation',
    'Repair'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),
          
          // Price Range
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 5000,
            divisions: 50,
            labels: RangeLabels(
              '₹${_priceRange.start.round()}',
              '₹${_priceRange.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Rating
          const Text(
            'Minimum Rating',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _rating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _rating.toString(),
                  onChanged: (double value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
              ),
              Text('${_rating.toStringAsFixed(1)} ★'),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Categories
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              final isSelected = _selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
          
          const Spacer(),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Reset filters
                    setState(() {
                      _priceRange = const RangeValues(0, 5000);
                      _rating = 3.0;
                      _selectedCategories = [];
                    });
                    widget.onResetFilters();
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onApplyFilters,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
