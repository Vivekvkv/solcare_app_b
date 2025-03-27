import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solcare_app4/models/service_model.dart';

class ServiceRating extends StatelessWidget {
  final ServiceModel service;

  const ServiceRating({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: service.popularity,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 20,
          ignoreGestures: true,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {},
        ),
        const SizedBox(width: 8),
        Text(
          service.popularity.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${(service.popularity * 25).toInt()} reviews)',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
