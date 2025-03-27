import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ServiceCardShimmer extends StatelessWidget {
  const ServiceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 140,
              width: double.infinity,
              color: Colors.white,
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description placeholder
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 12,
                    width: 150,
                    color: Colors.white,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Price and rating placeholder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 16,
                        width: 80,
                        color: Colors.white,
                      ),
                      Container(
                        height: 16,
                        width: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Button placeholder
                  Container(
                    height: 36,
                    width: double.infinity,
                    color: Colors.white,
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
