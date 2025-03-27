import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:solcare_app4/models/booking_model.dart';
import 'package:solcare_app4/providers/booking_provider.dart';
import 'package:solcare_app4/screens/booking/booking_tracking_screen.dart';
import 'package:solcare_app4/screens/bookings/components/invoice_viewer.dart';
import 'package:solcare_app4/screens/bookings/components/support_chat.dart';
import 'package:solcare_app4/utils/network_checker.dart';
import 'package:timeline_tile/timeline_tile.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isOnline = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkConnectivity();
  }
  
  Future<void> _checkConnectivity() async {
    final isOnline = await NetworkChecker.isOnline();
    if (mounted && isOnline != _isOnline) {
      setState(() {
        _isOnline = isOnline;
      });
    }
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
          'Booking Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share booking details',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing functionality coming soon!')),
              );
            },
          ),
          _buildMoreMenu(context),
        ],
      ),
      body: !_isOnline 
          ? _buildOfflineView()
          : _buildBookingDetails(),
    );
  }
  
  Widget _buildOfflineView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'You are offline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your internet connection',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              setState(() {
                // Show loading
              });
              await _checkConnectivity();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBookingDetails() {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final booking = bookingProvider.bookings.firstWhere((b) => b.id == widget.bookingId);
    final dateFormat = DateFormat('MMM dd, yyyy h:mm a');
    final bool isUpcoming = booking.status == BookingStatus.confirmed || 
                          booking.status == BookingStatus.technicianAssigned;
    final bool isInProgress = booking.status == BookingStatus.inProgress;
    final bool isCompleted = booking.status == BookingStatus.completed;
    final bool isCanceled = booking.status == BookingStatus.canceled;

    return Column(
      children: [
        // Status banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: booking.getStatusColor().withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: booking.getStatusColor().withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: booking.getStatusColor().withOpacity(0.2),
                    child: Icon(
                      _getStatusIcon(booking.status),
                      color: booking.getStatusColor(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.getStatusText(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: booking.getStatusColor(),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCompleted 
                              ? 'Completed on ${dateFormat.format(booking.scheduledDate)}' 
                              : isInProgress 
                                  ? 'Service in progress' 
                                  : isCanceled 
                                      ? 'Canceled'
                                      : 'Scheduled for ${dateFormat.format(booking.scheduledDate)}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUpcoming || isInProgress)
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingTrackingScreen(bookingId: widget.bookingId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.track_changes, size: 16),
                      label: const Text('Track'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: booking.getStatusColor(),
                        side: BorderSide(color: booking.getStatusColor()),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        
        // Tabs
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Status'),
            Tab(text: 'Support'),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
        ),
        
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Details tab
              _buildDetailsTab(context, booking, dateFormat, isCompleted),
              
              // Status timeline tab
              _buildStatusTab(context, booking, dateFormat),
              
              // Support tab
              _buildSupportTab(context, booking),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetailsTab(BuildContext context, BookingModel booking, DateFormat dateFormat, bool isCompleted) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking info card
            _buildSectionTitle('Booking Information'),
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Booking ID', '#${booking.id.substring(0, 8)}', Icons.confirmation_number_outlined),
                    const SizedBox(height: 12),
                    _buildInfoRow('Booking Date', dateFormat.format(booking.bookingDate), Icons.event_note),
                    const SizedBox(height: 12),
                    _buildInfoRow('Service Date', dateFormat.format(booking.scheduledDate), Icons.event),
                    const SizedBox(height: 12),
                    _buildInfoRow('Technician', booking.technicianName ?? 'To be assigned', Icons.person_outline),
                  ],
                ),
              ),
            ),
            
            // Service location card
            _buildSectionTitle('Service Location'),
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: InkWell(
                onTap: () {
                  // Open map view (implementation would go here)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Map view coming soon!')),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(Icons.location_on, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.address,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to view on map',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            
            // Services ordered
            _buildSectionTitle('Services Ordered'),
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: booking.services.length,
                      separatorBuilder: (context, index) => const Divider(height: 24),
                      itemBuilder: (context, index) {
                        final service = booking.services[index];
                        return Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getServiceIcon(service.category),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    service.shortDescription,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${service.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text('\$${booking.totalAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tax (8%)'),
                        Text('\$${(booking.totalAmount * 0.08).toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${(booking.totalAmount * 1.08).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment Status'),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isCompleted ? 'Paid' : 'Pending',
                            style: TextStyle(
                              color: isCompleted ? Colors.green : Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isCompleted) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InvoiceViewer(bookingId: booking.id),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download_outlined, size: 16),
                          label: const Text('Download Invoice'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Preparation instructions
            _buildSectionTitle('Service Instructions'),
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInstructionItem(
                      'Ensure Clear Access',
                      'Our technicians need clear access to your solar panels and inverter system.',
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionItem(
                      'Secure Pets',
                      'Please ensure pets are kept in a secure area during the service.',
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionItem(
                      'Adult Presence Required',
                      'An adult (18+) must be present at the property during the service appointment.',
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionItem(
                      'Power Interruption',
                      'Your solar system may need to be powered down temporarily during service.',
                    ),
                  ],
                ),
              ),
            ),
            
            // Notes
            if (booking.notes != null && booking.notes!.isNotEmpty) ...[
              _buildSectionTitle('Additional Notes'),
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(booking.notes!),
                ),
              ),
            ],
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusTab(BuildContext context, BookingModel booking, DateFormat dateFormat) {
    final timelineEvents = _getTimelineEvents(booking);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Timeline
          ListView.builder(
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
                  width: 20,
                  height: 20,
                  color: event['isCompleted'] ? Colors.green : Colors.grey.shade300,
                  iconStyle: IconStyle(
                    color: Colors.white,
                    iconData: Icons.check,
                    fontSize: 12,
                  ),
                ),
                beforeLineStyle: LineStyle(
                  color: event['isCompleted'] ? Colors.green : Colors.grey.shade300,
                ),
                endChild: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                startChild: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 24.0),
                  child: Text(
                    dateFormat.format(event['time']),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSupportTab(BuildContext context, BookingModel booking) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Support options
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 1,
            child: Column(
              children: [
                _buildSupportOption(
                  context,
                  'Chat with SolCare Team',
                  'Get immediate assistance for this booking',
                  Icons.chat_outlined,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupportChat(
                          bookingId: booking.id,
                          supportContext: 'general',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 0),
                _buildSupportOption(
                  context,
                  'Call SolCare Support',
                  'Speak directly with our support team',
                  Icons.phone_outlined,
                  Colors.green,
                  () {
                    // Phone call would be initiated here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling functionality coming soon!')),
                    );
                  },
                ),
                const Divider(height: 0),
                _buildSupportOption(
                  context,
                  'Report an Issue',
                  'Let us know if there\'s a problem with your service',
                  Icons.report_problem_outlined,
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupportChat(
                          bookingId: booking.id,
                          supportContext: 'issue',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // FAQs
          const SizedBox(height: 16),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            'What if I need to reschedule my service?',
            'You can reschedule your service up to 24 hours before the scheduled time without any fees. Rescheduling within 24 hours may incur a fee.',
          ),
          _buildFaqItem(
            'How long will the service take?',
            'Service duration depends on the specific service and the size of your system. Most services take between 1-3 hours to complete.',
          ),
          _buildFaqItem(
            'Do I need to be present during the service?',
            'Yes, an adult (18+) needs to be present at the property during the service appointment for access and to sign off on completion.',
          ),
          _buildFaqItem(
            'What payment methods do you accept?',
            'We accept all major credit cards, digital wallets, and bank transfers. Payment is processed after service completion.',
          ),
          _buildFaqItem(
            'What is your cancellation policy?',
            'Free cancellation is available up to 24 hours before service. Cancellation within 24 hours may incur a fee of 10% of the service cost.',
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildInstructionItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSupportOption(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            answer,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMoreMenu(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final booking = bookingProvider.bookings.firstWhere((b) => b.id == widget.bookingId);
        final bool isUpcoming = booking.status == BookingStatus.confirmed || 
                              booking.status == BookingStatus.technicianAssigned;
        final bool isCompleted = booking.status == BookingStatus.completed;
        
        return PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'reschedule' && isUpcoming) {
              _showRescheduleDialog(context, booking);
            } else if (value == 'cancel' && isUpcoming) {
              _showCancelDialog(context, booking);
            } else if (value == 'review' && isCompleted && !booking.isReviewed) {
              _showReviewDialog(context, booking);
            } else if (value == 'invoice') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceViewer(bookingId: booking.id),
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              if (isUpcoming)
                const PopupMenuItem<String>(
                  value: 'reschedule',
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 20),
                      SizedBox(width: 12),
                      Text('Reschedule'),
                    ],
                  ),
                ),
              if (isUpcoming)
                const PopupMenuItem<String>(
                  value: 'cancel',
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Cancel', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              if (isCompleted && !booking.isReviewed)
                const PopupMenuItem<String>(
                  value: 'review',
                  child: Row(
                    children: [
                      Icon(Icons.star_outline, size: 20, color: Colors.amber),
                      SizedBox(width: 12),
                      Text('Leave Review'),
                    ],
                  ),
                ),
              const PopupMenuItem<String>(
                value: 'invoice',
                child: Row(
                  children: [
                    Icon(Icons.receipt_long, size: 20),
                    SizedBox(width: 12),
                    Text('View Invoice'),
                  ],
                ),
              ),
            ];
          },
        );
      },
    );
  }
  
  List<Map<String, dynamic>> _getTimelineEvents(BookingModel booking) {
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
  
  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Icons.check_circle_outline;
      case BookingStatus.technicianAssigned:
        return Icons.person_outline;
      case BookingStatus.inProgress:
        return Icons.engineering;
      case BookingStatus.completed:
        return Icons.verified;
      case BookingStatus.canceled:
        return Icons.cancel_outlined;
      default:
        return Icons.schedule;
    }
  }
  
  IconData _getServiceIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cleaning':
        return Icons.cleaning_services;
      case 'repair':
        return Icons.build;
      case 'inspection':
        return Icons.search;
      case 'maintenance':
        return Icons.handyman;
      case 'optimization':
        return Icons.auto_graph;
      case 'protection':
        return Icons.security;
      default:
        return Icons.solar_power;
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
                    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                    
                    // Simulating rescheduling functionality
                    // We would need to add a method to the BookingProvider
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
  
  void _showCancelDialog(BuildContext context, BookingModel booking) {
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
                final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                bookingProvider.cancelBooking(booking.id);
                
                Navigator.pop(context);
                Navigator.pop(context); // Go back to bookings list
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
    final reviewController = TextEditingController();
    double rating = 5.0;
    List<String> selectedTags = [];
    final List<String> feedbackTags = [
      'Punctual', 'Professional', 'Knowledgeable', 'Friendly', 
      'Clean Work', 'Fair Price', 'Fast Service', 'Great Communication'
    ];
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rate Your Experience'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How would you rate your service?',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < rating 
                                  ? Icons.star 
                                  : (index + 0.5 == rating 
                                      ? Icons.star_half 
                                      : Icons.star_border),
                              color: index < rating 
                                  ? Colors.amber 
                                  : (index + 0.5 == rating 
                                      ? Colors.amber 
                                      : Colors.grey),
                              size: 36,
                            ),
                            onPressed: () {
                              setState(() {
                                rating = index + 1.0;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'What went well?',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: feedbackTags.map((tag) {
                        final isSelected = selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          selectedColor: Colors.blue.shade100,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedTags.add(tag);
                              } else {
                                selectedTags.remove(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reviewController,
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
                            // Photo upload functionality
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
                    // Implement review submission
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your feedback!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    
                    // Mark booking as reviewed (would need to implement this in provider)
                    // final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                    // bookingProvider.addReview(booking.id, rating, reviewController.text, selectedTags);
                  },
                  child: const Text('Submit Review'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
