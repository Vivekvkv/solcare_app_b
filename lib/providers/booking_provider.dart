import 'package:flutter/material.dart';
import 'package:solcare_app4/models/booking_model.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:uuid/uuid.dart';

class BookingProvider with ChangeNotifier {
  final List<BookingModel> _bookings = [];

  BookingProvider() {
    _initDemoBookings();
  }

  List<BookingModel> get bookings => _bookings;

  List<BookingModel> get activeBookings => _bookings
      .where((booking) => booking.status != BookingStatus.completed && booking.status != BookingStatus.canceled)
      .toList();

  List<BookingModel> get completedBookings => _bookings
      .where((booking) => booking.status == BookingStatus.completed)
      .toList();

  List<BookingModel> get canceledBookings => _bookings
      .where((booking) => booking.status == BookingStatus.canceled)
      .toList();

  int _findBookingIndexById(String bookingId) {
    return _bookings.indexWhere((booking) => booking.id == bookingId);
  }

  void addBooking({
    required List<ServiceModel> services,
    required DateTime scheduledDate,
    required String address,
    String? notes,
  }) {
    final uuid = Uuid();

    _bookings.add(
      BookingModel(
        id: uuid.v4(),
        services: services,
        totalAmount: services.fold(0, (sum, service) => sum + service.price),
        scheduledDate: scheduledDate,
        bookingDate: DateTime.now(),
        status: BookingStatus.confirmed,
        address: address,
        notes: notes,
        technicianName: 'To be assigned',
      ),
    );

    // Sort bookings for better UX
    _bookings.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

    notifyListeners();
  }

  void updateBookingStatus(String bookingId, BookingStatus newStatus) {
    final bookingIndex = _findBookingIndexById(bookingId);
    if (bookingIndex == -1) throw Exception("Booking not found!");

    _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(
      status: newStatus,
    );

    notifyListeners();
  }

  void assignTechnician(String bookingId, String technicianName) {
    final bookingIndex = _findBookingIndexById(bookingId);
    if (bookingIndex == -1) throw Exception("Booking not found!");

    _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(
      technicianName: technicianName,
      status: BookingStatus.technicianAssigned,
    );

    notifyListeners();
  }

  void cancelBooking(String bookingId) {
    final bookingIndex = _findBookingIndexById(bookingId);
    if (bookingIndex == -1) throw Exception("Booking not found!");

    _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(
      status: BookingStatus.canceled,
    );
    
    notifyListeners();
  }
  
  void rescheduleBooking(String bookingId, DateTime newDate) {
    final bookingIndex = _findBookingIndexById(bookingId);
    if (bookingIndex == -1) throw Exception("Booking not found!");

    _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(
      scheduledDate: newDate,
      // Reset to confirmed status if it was in progress or assigned
      status: _bookings[bookingIndex].status != BookingStatus.completed && 
              _bookings[bookingIndex].status != BookingStatus.canceled ? 
                BookingStatus.confirmed : _bookings[bookingIndex].status,
      // Reset technician if rescheduled
      technicianName: 'To be assigned',
    );
    
    notifyListeners();
  }
  
  void addReview(String bookingId, double rating, String? comment, List<String> tags, [List<String>? photoUrls]) {
    final bookingIndex = _findBookingIndexById(bookingId);
    if (bookingIndex == -1) throw Exception("Booking not found!");
    
    final review = BookingReview(
      rating: rating,
      comment: comment,
      tags: tags,
      timestamp: DateTime.now(),
      photoUrls: photoUrls,
    );
    
    _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(
      isReviewed: true,
      review: review,
    );
    
    notifyListeners();
  }

  // Initialize demo bookings for testing
  void _initDemoBookings() {
    final now = DateTime.now();
    final uuid = Uuid();
    
    // Demo services with correct parameters
    final cleaningService = ServiceModel(
      id: 'cleaning1',
      name: 'Solar Panel Cleaning',
      description: 'Professional cleaning of solar panels',
      shortDescription: 'Professional cleaning of solar panels',
      price: 1999.0,
      duration: '120 mins',
      image: 'assets/images/service_cleaning.jpg',
      category: 'Cleaning',
      popularity: 85,
    );
    
    final maintenanceService = ServiceModel(
      id: 'maintenance1',
      name: 'Preventive Maintenance',
      description: 'Regular maintenance service for solar systems',
      shortDescription: 'Regular maintenance for solar systems',
      price: 2999.0,
      duration: '180 mins',
      image: 'assets/images/service_maintenance.jpg',
      category: 'Maintenance',
      popularity: 90,
    );
    
    final repairService = ServiceModel(
      id: 'repair1',
      name: 'Inverter Repair',
      description: 'Repair service for solar inverters',
      shortDescription: 'Repair service for solar inverters',
      price: 3499.0,
      duration: '240 mins',
      image: 'assets/images/service_repair.jpg',
      category: 'Repair',
      popularity: 75,
    );
    
    // 1. Upcoming booking (Confirmed)
    _bookings.add(
      BookingModel(
        id: uuid.v4(),
        services: [cleaningService],
        totalAmount: 1999.0,
        bookingDate: now.subtract(const Duration(days: 2)),
        scheduledDate: now.add(const Duration(days: 3)),
        status: BookingStatus.confirmed,
        address: '123 Main Street, Bengaluru, Karnataka',
        notes: 'Please bring ladder for roof access',
        technicianName: 'To be assigned',
      ),
    );
    
    // 2. Upcoming booking with technician assigned
    _bookings.add(
      BookingModel(
        id: uuid.v4(),
        services: [maintenanceService],
        totalAmount: 2999.0,
        bookingDate: now.subtract(const Duration(days: 3)),
        scheduledDate: now.add(const Duration(days: 1)),
        status: BookingStatus.technicianAssigned,
        address: '456 Park Avenue, Bengaluru, Karnataka',
        technicianName: 'Arjun Kumar',
        technicianRating: 4.8,
      ),
    );
    
    // 3. In progress booking
    _bookings.add(
      BookingModel(
        id: uuid.v4(),
        services: [repairService],
        totalAmount: 3499.0,
        bookingDate: now.subtract(const Duration(days: 1)),
        scheduledDate: now.add(const Duration(hours: 2)),
        status: BookingStatus.inProgress,
        address: '789 Solar Street, Bengaluru, Karnataka',
        technicianName: 'Priya Singh',
        technicianRating: 4.9,
      ),
    );
    
    // 4. Completed booking (not reviewed)
    _bookings.add(
      BookingModel(
        id: uuid.v4(),
        services: [cleaningService, maintenanceService],
        totalAmount: 4998.0,
        bookingDate: now.subtract(const Duration(days: 10)),
        scheduledDate: now.subtract(const Duration(days: 3)),
        status: BookingStatus.completed,
        address: '321 Energy Road, Bengaluru, Karnataka',
        technicianName: 'Rahul Sharma',
        technicianRating: 4.7,
        isReviewed: false,
      ),
    );
    
    // 5. Completed and reviewed booking
    _bookings.add(
      BookingModel(
        id: uuid.v4(),
        services: [repairService],
        totalAmount: 3499.0,
        bookingDate: now.subtract(const Duration(days: 20)),
        scheduledDate: now.subtract(const Duration(days: 15)),
        status: BookingStatus.completed,
        address: '555 Solar Park, Bengaluru, Karnataka',
        technicianName: 'Amit Patel',
        technicianRating: 4.6,
        isReviewed: true,
        review: BookingReview(
          rating: 4.5,
          comment: 'Great service! Technician was very knowledgeable and fixed the issue quickly.',
          tags: ['Professional', 'Fast Service', 'Knowledgeable'],
          timestamp: now.subtract(const Duration(days: 14)),
        ),
      ),
    );
    
    // 6. Canceled booking
    _bookings.add(
      BookingModel(
        id: uuid.v4(),
        services: [cleaningService],
        totalAmount: 1999.0,
        bookingDate: now.subtract(const Duration(days: 5)),
        scheduledDate: now.subtract(const Duration(days: 2)),
        status: BookingStatus.canceled,
        address: '888 Panel Avenue, Bengaluru, Karnataka',
      ),
    );
    
    // Sort bookings for better UX
    _bookings.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }
}
