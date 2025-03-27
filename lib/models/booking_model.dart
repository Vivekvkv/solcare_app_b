import 'package:solcare_app4/models/service_model.dart';
import 'package:flutter/material.dart';

enum BookingStatus {
  confirmed,
  technicianAssigned,
  inProgress,
  completed,
  canceled,
}

class BookingModel {
  final String id;
  final List<ServiceModel> services;
  final double totalAmount;
  final DateTime bookingDate;
  final DateTime scheduledDate;
  final BookingStatus status;
  final String address;
  final String? notes;
  final String? technicianName;
  final double? technicianRating;
  final bool isReviewed;
  final BookingReview? review;

  BookingModel({
    required this.id,
    required this.services,
    required this.totalAmount,
    required this.bookingDate,
    required this.scheduledDate,
    required this.status,
    required this.address,
    this.notes,
    this.technicianName,
    this.technicianRating,
    this.isReviewed = false,
    this.review,
  });

  BookingModel copyWith({
    String? id,
    List<ServiceModel>? services,
    double? totalAmount,
    DateTime? bookingDate,
    DateTime? scheduledDate,
    BookingStatus? status,
    String? address,
    String? notes,
    String? technicianName,
    double? technicianRating,
    bool? isReviewed,
    BookingReview? review,
  }) {
    return BookingModel(
      id: id ?? this.id,
      services: services ?? this.services,
      totalAmount: totalAmount ?? this.totalAmount,
      bookingDate: bookingDate ?? this.bookingDate,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      technicianName: technicianName ?? this.technicianName,
      technicianRating: technicianRating ?? this.technicianRating,
      isReviewed: isReviewed ?? this.isReviewed,
      review: review ?? this.review,
    );
  }

  String getStatusText() {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.technicianAssigned:
        return 'Technician Assigned';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.canceled:
        return 'Canceled';
    }
  }

  Color getStatusColor() {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.technicianAssigned:
        return Colors.amber;
      case BookingStatus.inProgress:
        return Colors.orange;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.canceled:
        return Colors.red;
    }
  }
}

class BookingReview {
  final double rating;
  final String? comment;
  final List<String> tags;
  final DateTime timestamp;
  final List<String>? photoUrls;

  BookingReview({
    required this.rating,
    this.comment,
    required this.tags,
    required this.timestamp,
    this.photoUrls,
  });
}


