import 'package:flutter/material.dart';

class SavedLocationsSection extends StatelessWidget {
  final List<String> savedLocations;

  const SavedLocationsSection({
    super.key,
    required this.savedLocations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Saved Locations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add New'),
              onPressed: () {
                // Show add location dialog
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...savedLocations.map((location) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(location.split(':')[0]),
              subtitle: Text(location.split(':').length > 1 ? location.split(':')[1] : ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  // Delete location
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
