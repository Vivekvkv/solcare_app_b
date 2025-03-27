import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:solcare_app4/models/booking_model.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/screens/bookings/booking_details_screen.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';
import 'package:solcare_app4/widgets/empty_state.dart';
import 'package:solcare_app4/screens/bookings/components/booking_list_item.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTabIndex = 0;
  String _sortOption = 'Newest First';
  String? _filterStatus;
  bool _isLoading = false;

  final List<String> _tabOptions = ['Upcoming', 'Ongoing', 'Completed', 'Canceled'];
  final List<String> _sortOptions = ['Newest First', 'Oldest First'];
  final List<String> _statusOptions = ['All', 'Confirmed', 'Pending', 'In Progress', 'Completed', 'Canceled'];

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Tab selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _tabOptions.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_tabOptions[index]),
                      selected: _selectedTabIndex == index,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: _selectedTabIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black87,
                        fontWeight: _selectedTabIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Bookings list
          Expanded(
            child: _buildBookingsList(bookingProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(BookingProvider bookingProvider) {
    // Get filtered bookings based on tab selection and filters
    final List<BookingModel> filteredBookings = _getFilteredBookings(bookingProvider);

    // If loading
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // If no bookings after filtering
    if (filteredBookings.isEmpty) {
      return EmptyState(
        icon: _getEmptyStateIcon(),
        title: 'No ${_tabOptions[_selectedTabIndex].toLowerCase()} bookings',
        message: _getEmptyStateMessage(),
        buttonText: _selectedTabIndex == 0 ? 'Book a Service' : null,
        onButtonPressed: _selectedTabIndex == 0 
            ? () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const BookingScreen())
              )
            : null,
      );
    }

    // Show bookings list
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        setState(() {
          _isLoading = true;
        });
        await Future.delayed(const Duration(milliseconds: 800));
        setState(() {
          _isLoading = false;
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          return BookingListItem(
            booking: booking,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailsScreen(bookingId: booking.id),
                ),
              );
            },
            onReschedule: _selectedTabIndex <= 1 ? (booking) {
              _showRescheduleDialog(context, booking);
            } : null,
            onCancel: _selectedTabIndex <= 1 ? (booking) {
              _showCancellationDialog(context, booking);
            } : null,
            onReview: _selectedTabIndex == 2 && !booking.isReviewed ? (booking) {
              _showReviewDialog(context, booking);
            } : null,
          );
        },
      ),
    );
  }

  List<BookingModel> _getFilteredBookings(BookingProvider provider) {
    List<BookingModel> result = [];
    
    switch (_selectedTabIndex) {
      case 0: // Upcoming
        result = provider.bookings.where((b) => 
          b.status == BookingStatus.confirmed && 
          b.scheduledDate.isAfter(DateTime.now())
        ).toList();
        break;
      case 1: // Ongoing
        result = provider.bookings.where((b) => 
          b.status == BookingStatus.inProgress || 
          (b.status == BookingStatus.technicianAssigned)
        ).toList();
        break;
      case 2: // Completed
        result = provider.bookings.where((b) => 
          b.status == BookingStatus.completed
        ).toList();
        break;
      case 3: // Canceled
        result = provider.bookings.where((b) => 
          b.status == BookingStatus.canceled
        ).toList();
        break;
    }
    
    // Apply status filter if set
    if (_filterStatus != null) {
      result = result.where((b) => b.getStatusText() == _filterStatus).toList();
    }
    
    // Apply sorting
    if (_sortOption == 'Newest First') {
      result.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
    } else {
      result.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    }
    
    return result;
  }

  IconData _getEmptyStateIcon() {
    switch (_selectedTabIndex) {
      case 0: return Icons.event_available;
      case 1: return Icons.handyman;
      case 2: return Icons.check_circle_outline;
      case 3: return Icons.cancel_outlined;
      default: return Icons.calendar_today;
    }
  }

  String _getEmptyStateMessage() {
    switch (_selectedTabIndex) {
      case 0: return 'Schedule a service to get started!';
      case 1: return 'You don\'t have any ongoing services.';
      case 2: return 'Your completed services will appear here.';
      case 3: return 'You don\'t have any canceled bookings.';
      default: return 'No bookings found.';
    }
  }

  void _showRescheduleDialog(BuildContext context, BookingModel booking) {
    DateTime selectedDate = booking.scheduledDate;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(booking.scheduledDate);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Reschedule Service'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select new date and time:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 60)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = pickedTime;
                                selectedDate = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(selectedTime.format(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reschedule Policy:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Free rescheduling up to 24 hours before service\n'
                    '• Rescheduling fee may apply within 24 hours of service\n'
                    '• Subject to technician availability',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement actual rescheduling functionality
                    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                    // Assuming we have a rescheduleBooking method in the provider
                    // bookingProvider.rescheduleBooking(booking.id, selectedDate);
                    
                    // For now, just show a confirmation
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Service rescheduled successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCancellationDialog(BuildContext context, BookingModel booking) {
    // Calculate cancellation fee based on how close we are to the scheduled date
    final hours = booking.scheduledDate.difference(DateTime.now()).inHours;
    final bool feeApplies = hours < 24;
    final double cancellationFee = feeApplies ? (booking.totalAmount * 0.1) : 0;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to cancel this service?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cancellation Policy:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Free cancellation up to 24 hours before service\n'
                '• Cancellation fee applies within 24 hours of service\n'
                '• No refund for same-day cancellations',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              if (feeApplies)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'A cancellation fee of \$${cancellationFee.toStringAsFixed(2)} will be applied.',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Keep Booking'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Implement actual cancellation functionality
                final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                bookingProvider.cancelBooking(booking.id);
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Service canceled'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Cancel Service'),
            ),
          ],
        );
      },
    );
  }

  void _showReviewDialog(BuildContext context, BookingModel booking) {
    final _reviewController = TextEditingController();
    double _rating = 5.0;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rate Your Service'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating 
                                ? Icons.star 
                                : (index + 0.5 == _rating 
                                    ? Icons.star_half 
                                    : Icons.star_border),
                            color: index < _rating 
                                ? Colors.amber 
                                : (index + 0.5 == _rating 
                                    ? Colors.amber 
                                    : Colors.grey),
                            size: 36,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Share your experience (optional)',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.camera_alt_outlined, 
                        color: Theme.of(context).primaryColor),
                      TextButton(
                        onPressed: () {
                          // Photo upload functionality would go here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Photo upload coming soon!'))
                          );
                        },
                        child: const Text('Add Photos'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Submit review logic would go here
                    // For now just mark the booking as reviewed
                    // BookingProvider would need an addReview method
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your feedback!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
