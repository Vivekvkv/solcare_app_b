import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/models/booking_model.dart';

class BookingTrackingScreen extends StatelessWidget {
  final String bookingId;

  const BookingTrackingScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final booking = bookingProvider.bookings.firstWhere((b) => b.id == bookingId);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    
    // Mock timeline data
    final List<Map<String, dynamic>> timelineEvents = [
      {
        'title': 'Booking Confirmed',
        'time': booking.bookingDate,
        'description': 'Your service request has been confirmed',
        'isCompleted': true,
      },
      {
        'title': 'Technician Assigned',
        'time': booking.bookingDate.add(const Duration(hours: 2)),
        'description': booking.technicianName != 'To be assigned'
            ? '${booking.technicianName} has been assigned to your service'
            : 'A technician will be assigned soon',
        'isCompleted': booking.status != BookingStatus.confirmed,
      },
      {
        'title': 'On The Way',
        'time': booking.scheduledDate.subtract(const Duration(minutes: 30)),
        'description': 'The technician is on the way to your location',
        'isCompleted': booking.status == BookingStatus.inProgress ||
            booking.status == BookingStatus.completed,
      },
      {
        'title': 'Service in Progress',
        'time': booking.scheduledDate,
        'description': 'The technician is currently working on your solar system',
        'isCompleted': booking.status == BookingStatus.inProgress ||
            booking.status == BookingStatus.completed,
      },
      {
        'title': 'Service Completed',
        'time': booking.scheduledDate.add(const Duration(hours: 2)),
        'description': 'Your service has been completed successfully',
        'isCompleted': booking.status == BookingStatus.completed,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking info card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Booking #${booking.id.substring(0, 8)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Chip(
                            label: Text(
                              booking.getStatusText(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: booking.getStatusColor(),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Scheduled for: ${dateFormat.format(booking.scheduledDate)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Address: ${booking.address}',
                              style: const TextStyle(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Technician information
              if (booking.technicianName != 'To be assigned' &&
                  booking.status != BookingStatus.completed)
                Card(
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
                            onPressed: () {
                              bookingProvider.updateBookingStatus(
                                booking.id,
                                BookingStatus.inProgress,
                              );
                            },
                            icon: const Icon(Icons.play_circle_outlined),
                            label: const Text('Start Service'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Timeline
              const Text(
                'Service Timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: timelineEvents.length,
                  itemBuilder: (context, index) {
                    final event = timelineEvents[index];
                    return TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.2,
                      isFirst: index == 0,
                      isLast: index == timelineEvents.length - 1,
                      indicatorStyle: IndicatorStyle(
                        width: 24,
                        height: 24,
                        color: event['isCompleted']
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: event['isCompleted'] ? Icons.check : Icons.circle_outlined,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                        color: index == 0 || timelineEvents[index - 1]['isCompleted']
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        thickness: 2,
                      ),
                      afterLineStyle: LineStyle(
                        color: event['isCompleted']
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        thickness: 2,
                      ),
                      startChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              dateFormat.format(event['time']),
                              style: TextStyle(
                                color: event['isCompleted']
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['title'],
                              style: TextStyle(
                                color: event['isCompleted']
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event['description'],
                              style: TextStyle(
                                color: event['isCompleted']
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Service details
              const Text(
                'Service Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: booking.services.length,
                itemBuilder: (context, index) {
                  final service = booking.services[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(service.name),
                      subtitle: Text(service.duration),
                      trailing: Text(
                        '₹${service.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),

              if (booking.status == BookingStatus.completed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'How was your experience?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to rating screen or show rating dialog
                        showDialog(
                          context: context,
                          builder: (ctx) => const AlertDialog(
                            title: Text('Feature Coming Soon'),
                            content: Text('Rating and review functionality will be available in the next update.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.star_border),
                      label: const Text('Rate this service'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: booking.status != BookingStatus.completed
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Show mock emergency contact
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Emergency Contact'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.phone, color: Colors.red),
                            title: Text('Emergency Helpline'),
                            subtitle: Text('+91 1800-SOL-CARE'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.email, color: Colors.blue),
                            title: Text('Email Support'),
                            subtitle: Text('emergency@solcare.com'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close'),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.phone),
                          label: const Text('Call Now'),
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Calling emergency helpline...')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.emergency),
                label: const Text('Emergency Support'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            )
          : null,
    );
  }
}
