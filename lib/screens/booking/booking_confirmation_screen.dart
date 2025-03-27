import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/screens/home/home_screen.dart';
import 'package:solcare_app4/screens/booking/booking_tracking_screen.dart';
import 'package:solcare_app4/screens/booking/components/confirmation/index.dart';
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    // Start the confetti animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _confettiController.play();
    });

    // Add reward points after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final booking = Provider.of<BookingProvider>(context, listen: false)
          .bookings
          .firstWhere((b) => b.id == widget.bookingId);
      
      final points = (booking.totalAmount * 0.1).toInt();
      
      if (points > 0) {
        Provider.of<ProfileProvider>(context, listen: false).addRewardPoints(points);
      }

      // Simulate automatic technician assignment after 5 seconds
      if (booking.status == BookingStatus.confirmed) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            Provider.of<BookingProvider>(context, listen: false)
                .assignTechnician(booking.id, 'Arjun Kumar');
          }
        });
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
    final bookingProvider = Provider.of<BookingProvider>(context);
    final booking = bookingProvider.bookings.firstWhere((b) => b.id == widget.bookingId);
    final rewardPoints = (booking.totalAmount * 0.1).toInt();

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
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Success header
                  const SuccessHeader(),
                  
                  // Reward points notification
                  if (rewardPoints > 0) 
                    RewardPointsNotification(points: rewardPoints),
                  
                  const SizedBox(height: 40),
                  
                  // Booking details card
                  BookingDetailsCard(booking: booking),
                  
                  const SizedBox(height: 32),
                  
                  // Next steps
                  NextStepsSection(booking: booking),
                  
                  const SizedBox(height: 40),
                  
                  // Action buttons
                  ActionButtons(
                    bookingId: booking.id,
                    onTrackService: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingTrackingScreen(bookingId: booking.id),
                        ),
                      );
                    },
                    onBackToHome: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
