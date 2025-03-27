import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/providers/cart_provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/screens/booking/booking_confirmation_screen.dart';
import 'package:solcare_app4/screens/booking/components/index.dart';

class BookingScreen extends StatefulWidget {
  final ServiceModel? preselectedService;

  const BookingScreen({
    super.key,
    this.preselectedService,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  String? _selectedAddress;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a service address'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final List<ServiceModel> services = [];

      if (widget.preselectedService != null) {
        services.add(widget.preselectedService!);
      } else if (cartProvider.items.isNotEmpty) {
        for (final item in cartProvider.items) {
          for (int i = 0; i < item.quantity; i++) {
            services.add(item.service);
          }
        }
      }

      if (services.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your cart is empty. Please add services to book.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final scheduledDateTime = _combineDateAndTime(_selectedDate, _selectedTime);

      bookingProvider.addBooking(
        services: services,
        scheduledDate: scheduledDateTime,
        address: _selectedAddress!,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Clear cart after successful booking
      if (widget.preselectedService == null) {
        cartProvider.clear();
      }

      // Navigate to confirmation screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(
            bookingId: bookingProvider.bookings.last.id,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      if (profileProvider.profile.savedLocations.isNotEmpty) {
        setState(() {
          _selectedAddress = profileProvider.profile.savedLocations.first.split(':').length > 1
              ? profileProvider.profile.savedLocations.first.split(':')[1].trim()
              : profileProvider.profile.savedLocations.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    
    List<ServiceModel> services = [];
    double totalAmount = 0.0;

    if (widget.preselectedService != null) {
      services = [widget.preselectedService!];
      // Use the adjusted price based on system size
      totalAmount = cartProvider.getAdjustedPrice(widget.preselectedService!);
    } else {
      for (final item in cartProvider.items) {
        for (int i = 0; i < item.quantity; i++) {
          services.add(item.service);
        }
      }
      totalAmount = cartProvider.totalAmount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Services summary
              ServicesSummary(services: services),

              const SizedBox(height: 24),

              // Date and Time
              ScheduleDateTime(
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                onTimeSelected: (time) {
                  setState(() {
                    _selectedTime = time;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Service Address
              AddressSelection(
                savedLocations: profileProvider.profile.savedLocations,
                selectedAddress: _selectedAddress,
                onAddressChanged: (address) {
                  setState(() {
                    _selectedAddress = address;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Additional Notes
              NotesInput(controller: _notesController),

              const SizedBox(height: 24),

              // Order Summary
              OrderSummary(
                services: services,
                totalAmount: totalAmount,
              ),

              const SizedBox(height: 32),

              // Book Now button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: services.isEmpty ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: const Text('Confirm Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
