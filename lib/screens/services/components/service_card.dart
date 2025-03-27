import 'package:flutter/material.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                preselectedService: service,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service image
            AspectRatio(
              aspectRatio: 1.5,
              child: Image.asset(
                service.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 40),
                    ),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service name
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Price and discount
                  Row(
                    children: [
                      Text(
                        '₹${service.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: service.discount > 0 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                          color: service.discount > 0 
                            ? Colors.grey 
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (service.discount > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '₹${(service.price * (1 - service.discount / 100)).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 2),
                      Text(
                        service.popularity.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Book button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              preselectedService: service,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      child: const Text('Book'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
