import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';

class BookingBottomSheet extends StatefulWidget {
  final ServiceModel service;  // Changed from Service to ServiceModel

  const BookingBottomSheet({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedTime = '10:00 AM';
  final List<String> timeSlots = [
    '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            
            // Service name
            Text(
              widget.service.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Service image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/service_${widget.service.id}.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Details table
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Price', '₹${widget.service.price.toStringAsFixed(0)}'),
                  _buildDetailRow('Category', widget.service.category),
                  _buildDetailRow('Rating', '${widget.service.popularity.toStringAsFixed(1)}★'),
                  if (widget.service.discount > 0)
                    _buildDetailRow('Discount', '${widget.service.discount}%'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'This premium solar service includes professional ${widget.service.name.toLowerCase()} '
              'by trained technicians using industry-standard equipment. We ensure your solar system '
              'works at peak efficiency after service completion.',
              style: const TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 32),
            
            // Book now button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToBooking(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
  
  void _navigateToBooking(BuildContext context) {
    // No need to convert Service to ServiceModel anymore
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(preselectedService: widget.service),
      ),
    );
  }
}