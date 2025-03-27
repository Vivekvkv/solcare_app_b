import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/screens/booking_tracking_screen.dart';
import 'package:solcare_app4/screens/home_screen.dart';
import 'dart:math' as math;
import 'package:solcare_app4/screens/booking_status.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String bookingId;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Start the confetti animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _confettiController.play();
    });
    
    // Add reward points using a post-frame callback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      final booking = bookingProvider.bookings.firstWhere((b) => b.id == widget.bookingId);
      final points = (booking.totalAmount * 0.1).toInt();
      
      if (points > 0) {
        Provider.of<ProfileProvider>(context, listen: false).addRewardPoints(points);
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti overlay
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -math.pi / 2, // Straight up
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 10,
            gravity: 0.1,
            particleDrag: 0.05,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.orange,
              Colors.purple,
              Colors.yellow,
            ],
          ),
          
          // Main content using Consumer for efficient rebuilds
          SafeArea(
            child: Consumer<BookingProvider>(
              builder: (context, bookingProvider, _) {
                final booking = bookingProvider.bookings.firstWhere(
                  (b) => b.id == widget.bookingId,
                  orElse: () => throw Exception('Booking not found'),
                );
                final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
                final rewardPoints = (booking.totalAmount * 0.1).toInt();

                // Simulate automatic technician assignment after 5 seconds
                if (booking.status == BookingStatus.confirmed) {
                  Future.delayed(const Duration(seconds: 5), () {
                    bookingProvider.assignTechnician(booking.id, 'Arjun Kumar');
                  });
                }
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      
                      _buildSuccessIcon(),
                      
                      const SizedBox(height: 24),
                      
                      const Text(
                        'Booking Successful!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Your booking has been confirmed',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      if (rewardPoints > 0) 
                        _buildRewardPointsBadge(context, rewardPoints),
                      
                      const SizedBox(height: 40),
                      
                      _buildBookingDetailsCard(context, booking, dateFormat),
                      
                      const SizedBox(height: 32),
                      
                      _buildNextStepsSection(context, booking),
                      
                      const SizedBox(height: 40),
                      
                      _buildActionButtons(context, booking),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 80,
      ),
    );
  }

  Widget _buildRewardPointsBadge(BuildContext context, int points) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.card_giftcard,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Text(
            'You earned $points reward points!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard(BuildContext context, dynamic booking, DateFormat dateFormat) {
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
            
            _buildDetailItem(
              title: 'Service(s)',
              content: booking.services.map<String>((s) => s.name).join(', '),
              icon: Icons.home_repair_service,
            ),
            
            _buildDetailItem(
              title: 'Date & Time',
              content: dateFormat.format(booking.scheduledDate),
              icon: Icons.calendar_today,
            ),
            
            _buildDetailItem(
              title: 'Service Address',
              content: booking.address,
              icon: Icons.location_on,
            ),
            
            _buildDetailItem(
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

  Widget _buildNextStepsSection(BuildContext context, dynamic booking) {
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
        
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: booking.status == BookingStatus.confirmed
                  ? Colors.amber.withOpacity(0.2) // Fixed: changed withValues to withOpacity
                  : Colors.green.withOpacity(0.2), // Fixed: changed withValues to withOpacity
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

  Widget _buildActionButtons(BuildContext context, dynamic booking) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingTrackingScreen(bookingId: booking.id),
                ),
              );
            },
            icon: const Icon(Icons.location_on),
            label: const Text('Track Service'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Back to Home'),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String content,
    required IconData icon,
    TextStyle? contentStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: contentStyle ?? const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

