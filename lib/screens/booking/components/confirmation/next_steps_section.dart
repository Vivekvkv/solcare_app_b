import 'package:flutter/material.dart';
import 'package:solcare_app4/models/booking_model.dart';

class NextStepsSection extends StatelessWidget {
  final BookingModel booking;

  const NextStepsSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Next Steps',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Assigning technician card
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: booking.status == BookingStatus.confirmed
                  ? Colors.amber.withOpacity(0.2) // Changed from withAlpha(50) to withOpacity(0.2)
                  : Colors.green.withOpacity(0.2), // Changed from withAlpha(50) to withOpacity(0.2)
              child: Icon(
                Icons.person_outline,
                color: booking.status == BookingStatus.confirmed
                    ? Colors.amber
                    : Colors.green,
              ),
            ),
            title: const Text('Assigning Technician'),
            subtitle: Text(
              booking.status == BookingStatus.confirmed
                  ? 'We\'re assigning the best technician for your service'
                  : 'Technician ${booking.technicianName} has been assigned',
            ),
            trailing: booking.status == BookingStatus.confirmed
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
          ),
        ),
        
        // Preparation card
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.tips_and_updates,
                color: Colors.white,
              ),
            ),
            title: Text('Prepare for the Service'),
            subtitle: Text(
              'Ensure access to your solar system and clear any obstructions',
            ),
          ),
        ),
      ],
    );
  }
}
