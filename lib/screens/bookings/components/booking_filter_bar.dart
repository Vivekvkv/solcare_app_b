import 'package:flutter/material.dart';

class BookingFilterBar extends StatelessWidget {
  final String sortOption;
  final String? filterStatus;
  final Function(String) onSortChanged;
  final Function(String) onFilterChanged;
  final List<String> sortOptions;
  final List<String> statusOptions;

  const BookingFilterBar({
    super.key,
    required this.sortOption,
    required this.filterStatus,
    required this.onSortChanged,
    required this.onFilterChanged,
    required this.sortOptions,
    required this.statusOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Sort dropdown
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortOption,
                  icon: const Icon(Icons.sort),
                  isExpanded: true,
                  hint: const Text('Sort by'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onSortChanged(newValue);
                    }
                  },
                  items: sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Filter dropdown
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: filterStatus ?? 'All',
                  icon: const Icon(Icons.filter_list),
                  isExpanded: true,
                  hint: const Text('Filter by'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onFilterChanged(newValue);
                    }
                  },
                  items: statusOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
