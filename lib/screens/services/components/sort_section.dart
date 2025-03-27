import 'package:flutter/material.dart';

class SortSection extends StatelessWidget {
  final List<String> sortOptions;
  final String selectedSort;
  final Function(String) onSortChanged;

  const SortSection({
    super.key,
    required this.sortOptions,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Sort by: '),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedSort,
            onChanged: (value) {
              if (value != null) {
                onSortChanged(value);
              }
            },
            items: sortOptions.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
