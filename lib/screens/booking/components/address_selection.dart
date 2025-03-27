import 'package:flutter/material.dart';

class AddressSelection extends StatelessWidget {
  final List<String> savedLocations;
  final String? selectedAddress;
  final Function(String?) onAddressChanged;

  const AddressSelection({
    super.key,
    required this.savedLocations,
    required this.selectedAddress,
    required this.onAddressChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Address',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Address',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          value: selectedAddress,
          items: savedLocations.map((location) {
            final displayAddress = location.split(':').length > 1
                ? location.split(':')[1].trim()
                : location;
            final displayType = location.split(':').length > 1
                ? location.split(':')[0].trim()
                : 'Address';
            return DropdownMenuItem<String>(
              value: displayAddress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    displayAddress,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onAddressChanged,
        ),
        TextButton.icon(
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add New Address'),
          onPressed: () {
            // Show dialog to add new address
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text('Feature Coming Soon'),
                content: Text(
                    'Address management functionality will be available in the next update.'),
              ),
            );
          },
        ),
      ],
    );
  }
}
