import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/models/booking_model.dart';
import 'package:solcare_app4/screens/booking/components/tracking/index.dart';

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

    // Timeline event data
    final timelineEvents = getTimelineEvents(booking);

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
              BookingInfoCard(booking: booking, dateFormat: dateFormat),

              const SizedBox(height: 24),

              // Technician information
              if (booking.technicianName != null &&
                  booking.technicianName != 'To be assigned' &&
                  booking.status != BookingStatus.completed)
                TechnicianInfoCard(
                  booking: booking,
                  onStartService: () {
                    bookingProvider.updateBookingStatus(
                      booking.id,
                      BookingStatus.inProgress,
                    );
                  },
                ),

              const SizedBox(height: 24),

              // Timeline
              TrackingTimeline(
                timelineEvents: timelineEvents,
                dateFormat: dateFormat
              ),

              const SizedBox(height: 24),

              // Service details
              ServiceDetailsList(services: booking.services),

              if (booking.status == BookingStatus.completed) 
                const ServiceRatingSection(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: booking.status != BookingStatus.completed
          ? const EmergencySupportBar()
          : null,
    );
  }

  List<Map<String, dynamic>> getTimelineEvents(BookingModel booking) {
    return [
      {
        'title': 'Booking Confirmed',
        'time': booking.bookingDate,
        'description': 'Your service request has been confirmed',
        'isCompleted': true,
      },
      {
        'title': 'Technician Assigned',
        'time': booking.bookingDate.add(const Duration(hours: 2)),
        'description': booking.technicianName != null && booking.technicianName != 'To be assigned'
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
  }
}
