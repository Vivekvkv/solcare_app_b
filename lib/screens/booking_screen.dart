import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/providers/cart_provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/screens/booking_confirmation_screen.dart';
import 'package:solcare_app4/screens/services/services_screen.dart';
import 'package:solcare_app4/widgets/universal_app_header.dart';

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
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
    final dateFormat = DateFormat('dd MMM yyyy');
    
    List<ServiceModel> services = [];
    double totalAmount = 0.0;

    if (widget.preselectedService != null) {
      services = [widget.preselectedService!];
      totalAmount = widget.preselectedService!.price;
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
          'Book a Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Services summary
              const Text(
                'Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (services.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Your cart is empty. Please add services to book.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              if (services.isNotEmpty)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: services.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(services[index].image),
                          radius: 20,
                        ),
                        title: Text(services[index].name),
                        subtitle: Text(services[index].duration),
                        trailing: Text(
                          '₹${services[index].price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 24),

              // Date and Time
              const Text(
                'Schedule Date & Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(dateFormat.format(_selectedDate)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Time',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(_selectedTime.format(context)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Service Address
              const Text(
                'Service Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Address',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedAddress,
                items: profileProvider.profile.savedLocations.map((location) {
                  final displayAddress = location.split(':').length > 1
                      ? location.split(':')[1].trim()
                      : location;
                  final displayType = location.split(':').length > 1
                      ? location.split(':')[0].trim()
                      : 'Address';
                  return DropdownMenuItem<String>(
                    value: displayAddress,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          displayAddress,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAddress = value;
                  });
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add New Address'),
                onPressed: () {
                  // Show dialog to add new address
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text('Feature Coming Soon'),
                      content: Text(
                          'Address management functionality will be available in the next update.'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Additional Notes
              const Text(
                'Additional Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Any specific instructions for the technician',
                  prefixIcon: const Icon(Icons.note_add),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Order Summary
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Services'),
                          Text('${services.length} item(s)'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text('₹${totalAmount.toStringAsFixed(0)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Service Fee'),
                          Text('₹${(totalAmount * 0.05).toStringAsFixed(0)}'),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '₹${(totalAmount * 1.05).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'You\'ll earn ${(totalAmount * 0.1).toInt()} reward points',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to services screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServicesScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Book a Service'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
