import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solcare_app4/models/booking_model.dart';
import 'detail_item.dart';

class BookingDetailsCard extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#${booking.id.substring(0, 8)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            const Divider(height: 24),
            
            // Service(s)
            DetailItem(
              title: 'Service(s)',
              content: booking.services.map((s) => s.name).join(', '),
              icon: Icons.home_repair_service,
            ),
            
            // Date & Time
            DetailItem(
              title: 'Date & Time',
              content: dateFormat.format(booking.scheduledDate),
              icon: Icons.calendar_today,
            ),
            
            // Address
            DetailItem(
              title: 'Service Address',
              content: booking.address,
              icon: Icons.location_on,
            ),
            
            // Total Amount
            DetailItem(
              title: 'Total Amount',
              content: '₹${booking.totalAmount.toStringAsFixed(0)}',
              icon: Icons.payments,
              contentStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1E88E5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
