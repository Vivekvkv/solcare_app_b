import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/models/booking_model.dart';
import 'package:solcare_app4/screens/booking/booking_tracking_screen.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Booking History',
            onPressed: () {
              // Show booking history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking history feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ActiveBookingsTab(),
          CompletedBookingsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookingScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Book New Service'),
      ),
    );
  }
}

class ActiveBookingsTab extends StatelessWidget {
  const ActiveBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final activeBookings = bookingProvider.activeBookings;

    if (activeBookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No active bookings',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Book a service to get started!',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeBookings.length,
      itemBuilder: (context, index) {
        final booking = activeBookings[index];
        return BookingCard(
          booking: booking,
          isActive: true,
        );
      },
    );
  }
}

class CompletedBookingsTab extends StatelessWidget {
  const CompletedBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final completedBookings = bookingProvider.completedBookings;

    if (completedBookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No completed bookings yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedBookings.length,
      itemBuilder: (context, index) {
        final booking = completedBookings[index];
        return BookingCard(
          booking: booking,
          isActive: false,
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isActive;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = booking.getStatusColor();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking ID: ${booking.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
                  backgroundColor: statusColor,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            
            const Divider(),
            
            // Services
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: booking.services.map((service) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18),
                      const SizedBox(width: 8),
                      Text(service.name),
                      const Spacer(),
                      Text(
                        '₹${service.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            
            const Divider(),
            
            // Date, Technician and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scheduled For',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      dateFormat.format(booking.scheduledDate),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '₹${booking.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Technician
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Technician: ${booking.technicianName ?? 'To be assigned'}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                if (isActive) 
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.location_on, size: 16),
                      label: const Text('Track Service'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingTrackingScreen(bookingId: booking.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                if (isActive) const SizedBox(width: 12),
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(
                      isActive ? Icons.cancel : Icons.refresh,
                      size: 16,
                    ),
                    label: Text(isActive ? 'Cancel' : 'Rebook'),
                    onPressed: () {
                      if (isActive) {
                        // Show confirmation dialog for cancellation
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Cancel Booking'),
                            content: const Text('Are you sure you want to cancel this booking?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<BookingProvider>(context, listen: false)
                                      .cancelBooking(booking.id);
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Booking cancelled successfully'),
                                    ),
                                  );
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Rebook logic
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              preselectedService: booking.services.first,
                            ),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: isActive ? Colors.red : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
