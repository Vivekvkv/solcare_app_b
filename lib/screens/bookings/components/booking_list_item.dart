import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solcare_app4/models/booking_model.dart';

class BookingListItem extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;
  final Function(BookingModel)? onReschedule;
  final Function(BookingModel)? onCancel;
  final Function(BookingModel)? onReview;

  const BookingListItem({
    super.key,
    required this.booking,
    required this.onTap,
    this.onReschedule,
    this.onCancel,
    this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActionable = onReschedule != null || onCancel != null || onReview != null;
    
    return Dismissible(
      key: Key(booking.id),
      direction: isActionable ? DismissDirection.horizontal : DismissDirection.none,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart && onCancel != null) {
          onCancel!(booking);
          return false; // Don't dismiss, we handle this in the dialog
        } else if (direction == DismissDirection.startToEnd && onReschedule != null) {
          onReschedule!(booking);
          return false; // Don't dismiss, we handle this in the dialog
        }
        return false;
      },
      background: onReschedule != null ? Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.blue,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_calendar, color: Colors.white),
            SizedBox(height: 4),
            Text('Reschedule', style: TextStyle(color: Colors.white)),
          ],
        ),
      ) : null,
      secondaryBackground: onCancel != null ? Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel, color: Colors.white),
            SizedBox(height: 4),
            Text('Cancel', style: TextStyle(color: Colors.white)),
          ],
        ),
      ) : null,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: booking.getStatusColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with booking ID and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking #${booking.id.substring(0, 8)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    _buildStatusBadge(context, booking),
                  ],
                ),
                const Divider(),
                
                // Service info
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: booking.services.length > 2 
                      ? 2 
                      : booking.services.length,
                  itemBuilder: (context, index) {
                    final service = booking.services[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
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
                          const SizedBox(width: 12),
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
                                  '\$${service.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                if (booking.services.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                    child: Text(
                      '+${booking.services.length - 2} more services',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                
                const Divider(),
                
                // Date, time and address
                Row(
                  children: [
                    Icon(Icons.event, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM dd, yyyy').format(booking.scheduledDate),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('hh:mm a').format(booking.scheduledDate),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.address,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                // Action buttons - shown based on booking status
                if (isActionable)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onReview != null)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.star, size: 16),
                            label: const Text('Review'),
                            onPressed: () => onReview!(booking),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        if (onReschedule != null) ...[
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.schedule, size: 16),
                            label: const Text('Reschedule'),
                            onPressed: () => onReschedule!(booking),
                          ),
                        ],
                        if (onCancel != null) ...[
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.cancel_outlined, size: 16),
                            label: const Text('Cancel'),
                            onPressed: () => onCancel!(booking),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, BookingModel booking) {
    final color = booking.getStatusColor();
    final status = booking.getStatusText();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
}
