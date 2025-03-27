import 'package:flutter/material.dart';
import 'package:solcare_app4/models/booking_model.dart';

class TechnicianInfoCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onStartService;

  const TechnicianInfoCard({
    super.key,
    required this.booking,
    required this.onStartService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Technician Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.person, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.technicianName ?? 'Technician',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Solar Maintenance Specialist',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    // Call technician
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Calling technician...'),
                      ),
                    );
                  },
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (booking.status == BookingStatus.inProgress)
              const LinearProgressIndicator(
                value: 0.6, // Mock progress
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            if (booking.status == BookingStatus.technicianAssigned)
              ElevatedButton.icon(
                onPressed: onStartService,
                icon: const Icon(Icons.play_circle_outlined),
                label: const Text('Start Service'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
